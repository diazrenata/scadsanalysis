library(drake)
library(scadsanalysis)
library(dplyr)
source(here::here("analysis", "helper_scripts", "kernels.R"))
sites <- list_sites("mcdb")
set.seed(1978)
sites <- sites [ sample.int(nrow(sites), size = 20, replace = F),]

#sites <- data.frame(site = c(1879, 1469, 1218))
## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-mcdb.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)
cache$del(key = "lock", namespace = "session")

## Get kernels

skew_kernels <- list()

for(i in 1:nrow(sites)) {
  fs_name <- paste0("di_fs_", sites$site[i], "_FALSE")
  this_fs <- readd(fs_name, cache = cache, character_only = T)
  skew_kernels[[i]] <- get_standardized_kernel(this_fs, nsims = 10000)

}

skew_kernels <- dplyr::bind_rows(skew_kernels)

skew_kernels <- skew_kernels %>%
  filter(!is.na(val)) %>%
  mutate(log_nparts = log(as.numeric(nparts)))

library(ggplot2)
ggplot(skew_kernels, aes(x = index, y = density, group = site, color = twotailed_95)) +
  geom_line() +
  theme_bw()

simpson_kernels <- list()

for(i in 1:nrow(sites)) {
  fs_name <- paste0("di_fs_", sites$site[i], "_FALSE")
  this_fs <- readd(fs_name, cache = cache, character_only = T)
  simpson_kernels[[i]] <- get_standardized_kernel(this_fs, nsims = 10000, metric = "simpson")

}

simpson_kernels <- dplyr::bind_rows(simpson_kernels)

simpson_kernels <- simpson_kernels %>%
  filter(!is.na(val)) %>%
  mutate(log_nparts = log(as.numeric(nparts)))

ggplot(simpson_kernels, aes(x = index, y = density, group = site, color = onetailed_95)) +
  geom_line() +
  theme_bw()


ggplot(simpson_kernels, aes(x = index, y = density, group = site, color = twotailed_95)) +
  geom_line() +
  theme_bw()
