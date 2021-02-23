library(drake)
library(scadsanalysis)
library(ggplot2)
library(dplyr)

expose_imports("scadsanalysis")

dataset <- read.csv(here::here("analysis", "rev_prototyping", "jacknifed_datasets", "fia_small_jk.csv"))

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
  dat = target(read.csv(here::here("analysis", "rev_prototyping", "jacknifed_datasets", "fia_small_jk.csv")),
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
                    transform = combine(di_obs))
)

## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-fia_small-jk.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)
cache$del(key = "lock", namespace = "session")
#
# ## View the graph of the plan
# if (interactive())
# {
#   config <- drake_config(all, cache = cache)
#   sankey_drake_graph(config, build_times = "none")  # requires "networkD3" package
#   vis_drake_graph(config, build_times = "none")     # requires "visNetwork" package
# }
#
## Run the pipeline
nodename <- Sys.info()["nodename"]
if(grepl("ufhpc", nodename)) {
  print("I know I am on the HiPerGator!")
  library(clustermq)
  options(clustermq.scheduler = "slurm", clustermq.template = here::here("slurm_clustermq.tmpl"))
  ## Run the pipeline parallelized for HiPerGator
  make(all,
       force = TRUE,
       cache = cache,
       cache_log_file = here::here("analysis", "drake", "cache_log_fia_small_jk.txt"),
       verbose = 1,
       parallelism = "clustermq",
       jobs = 50,
       caching = "master",
       memory_strategy = "autoclean",
       garbage_collection = TRUE) # Important for DBI caches!
} else {
  # library(clustermq)
  # options(clustermq.scheduler = "multicore")
  # Run the pipeline on multiple local cores
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_fia_small_jk.txt")))
}

DBI::dbDisconnect(db)
rm(cache)

print("Completed OK")
