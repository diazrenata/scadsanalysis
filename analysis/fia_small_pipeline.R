library(drake)
library(scadsanalysis)
library(ggplot2)

expose_imports("scadsanalysis")

datasets <- "fia_small"

sites_list <- list_sites("fia_small")
ndraws = 4000
#sites_list <- sites_list[1:4, ]
set.seed(1978)

dat_plan <- drake_plan(
  dat = target(load_dataset(dataset_name = d),
               transform = map(
                 d = !!datasets
               ),
               hpc = F
  ),
  dat_s = target(add_singletons_dataset(dat),
                 transform = map(dat),
                 hpc = F),
  tall_p = target(readRDS(here::here("analysis", "masterp_tall.Rds")),
                  hpc = F),
  fs = target(sample_fs_wrapper(dataset = dat_s_dat_fia_small, site_name = s, singletonsyn = singletons, n_samples = ndraws, p_table = tall_p, seed = !!sample.int(10^6, size = 1)),
                   transform = cross(s = !!sites_list$site,
                                     singletons = !!c(TRUE, FALSE))),
 # fs_diffs = target(get_fs_diffs(fs),
  #                  transform = map(fs)),
  fs_pc = target(compare_props_fs(fs),
                 transform = map(fs)),
  di = target(add_dis(fs, props_comparison = fs_pc),
              transform = map(fs, fs_pc)),
  di_obs = target(pull_di(di),
                  transform = map(di)),
  di_obs_s = target(dplyr::bind_rows(di_obs),
                    transform = combine(di_obs, .by = singletons)),
  all_di_obs = target(dplyr::bind_rows(di_obs_s_TRUE, di_obs_s_FALSE)),
 cts = target(po_central_tendency(fs, fs_pc),
              transform = map(fs, fs_pc)),
 all_cts = target(dplyr::bind_rows(cts),
                  transform = combine(cts))
)

all <- dat_plan

## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-fia_small.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)
cache$del(key = "lock", namespace = "session")

## Run the pipeline
nodename <- Sys.info()["nodename"]
# if(grepl("ufhpc", nodename)) {
#   print("I know I am on the HiPerGator!")
#   library(clustermq)
#   options(clustermq.scheduler = "slurm", clustermq.template = here::here("slurm_clustermq.tmpl"))
#   ## Run the pipeline parallelized for HiPerGator
#   make(all,
#        force = TRUE,
#        cache = cache,
#        cache_log_file = here::here("analysis", "drake", "cache_log_fia_small.txt"),
#        verbose = 1,
#        parallelism = "clustermq",
#        jobs = 25,
#        caching = "master",
#        memory_strategy = "autoclean",
#        garbage_collection = TRUE) # Important for DBI caches!
# } else {
#   library(clustermq)
#   options(clustermq.scheduler = "multicore")
  # Run the pipeline on multiple local cores
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_fia_small.txt"), verbose = 1, memory_strategy = "autoclean"))
# }

#system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_fia_small.txt")))


DBI::dbDisconnect(db)
rm(cache)
print("Completed OK")
