library(drake)
library(scadsanalysis)
library(ggplot2)
library(dplyr)

expose_imports("scadsanalysis")

dataset <- read.csv(here::here("analysis", "rev_prototyping", "jacknifed_datasets", "misc_jk.csv"))

max_n_sites = 1000

sites_list <- dataset %>%
  select(site, dat) %>%
  distinct() %>%
  group_by_all() %>%
  mutate(site_source = unlist(strsplit(site, "_")[[1]][[1]])) %>%
  ungroup()

sites_list <- sites_list %>%
  filter(site_source %in% unique(sites_list$site_source)[1:max_n_sites]) %>%
  select(-site_source)

ndraws = 4000


#sites_list <- sites_list[1:5, ]
set.seed(1980)


all <- drake_plan(
  dat = target(read.csv(here::here("analysis", "rev_prototyping", "jacknifed_datasets", "misc_jk.csv")),
               hpc = F
  ),
  tall_p = target(readRDS(here::here("analysis", "masterp_tall.Rds")),
                  hpc = F),
  fs = target(sample_fs_wrapper(dataset = dat, site_name = s, singletonsyn = FALSE, n_samples = ndraws, p_table = tall_p, seed = !!sample.int(10^6, size = 1)),
              transform = map(s = !!sites_list$site)),
 # fs_diffs = target(get_fs_diffs(fs),
 #                  transform = map(fs)),
  fs_pc = target(compare_props_fs(fs),
                 transform = map(fs)),
  di = target(add_dis(fs, props_comparison = fs_pc),
              transform = map(fs, fs_pc)),
  di_obs = target(pull_di(di),
                  transform = map(di)),
  all_di_obs = target(dplyr::bind_rows(di_obs),
                    transform = combine(di_obs))#,
 # cts = target(po_central_tendency(fs, fs_pc),
 #              transform = map(fs, fs_pc)),
 # all_cts = target(dplyr::bind_rows(cts),
 #                  transform = combine(cts))
)

## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-misc-jk.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)
cache$del(key = "lock", namespace = "session")
#
#


fs_pc_names <- all$target[ grepl("fs_pc_", all$target)]
fs_pc_names <- fs_pc_names[ !grepl("di_fs", fs_pc_names)]
fs_pc_names <- fs_pc_names[ !grepl("cts_", fs_pc_names)]
fs_names <- substr(fs_pc_names, 7, nchar(fs_pc_names))

all_cts <- list()
for(i in 1:length(fs_pc_names)) {

  this_pc <- readd(fs_pc_names[i], character_only = T, cache = cache)
  this_fs <- readd(fs_names[i], character_only = T, cache = cache)

  all_cts[[i]] <- po_central_tendency(this_fs, this_pc)
}

all_cts <- dplyr::bind_rows(all_cts)

write.csv(all_cts, "misc_jk_cts.csv", row.names = F)



DBI::dbDisconnect(db)
rm(cache)

print("Completed OK")
