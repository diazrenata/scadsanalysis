library(ggplot2)
library(dplyr)
statevars_orig <- statevars %>%
  filter(singletons == FALSE) %>%
  select(-singletons)

statevars_single <- statevars %>%
  filter(singletons == TRUE) %>%
  rename(s0_est = s0,
         n0_est = n0) %>%
  select(-singletons)

statevars <- left_join(statevars_orig, statevars_single, by = c("site", "sim", "dat", "source"))
head(statevars)
rarefac <- ggplot(data = statevars, aes(x = s0, y = s0_est)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0) +
  theme_bw()
rarefac



library(scadsanalysis)
mcdb <- load_dataset("mcdb")

mcdb_sites <- list_sites("mcdb")

singles <- list()

for(i in 179:180) {

  thissite <- filter(mcdb, site == mcdb_sites$site[i])

  singles[[i]] <- try(add_singletons(thissite, use_max =  T))

}


library(drake)

## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-dat.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)

cs <- cached(cache = cache)
