library(drake)
library(scadsanalysis)
library(ggplot2)

expose_imports("scadsanalysis")

datasets <- "portal_plants"

sites_list <- list_sites("portal_plants")
ndraws = 4000
nresamples <- 4000

#sites_list <- sites_list[1:15, ]
set.seed(1977)

all <- drake_plan(
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
  fs = target(sample_fs_wrapper(dataset = dat_s_dat_portal_plants, site_name = s, singletonsyn = singletons, n_samples = ndraws, p_table = tall_p, seed = !!sample.int(10^6, size = 1)),
              transform = cross(s = !!sites_list$site,
                                singletons = !!c(TRUE, FALSE))),
  di = target(add_dis(fs),
              transform = map(fs)),
  diffs = target(rep_diff_sampler(fs, ndraws = !!nresamples),
                 transform = map(fs)),
  diffs_summary = target(summarize_diffs(diffs),
                         transform = map(diffs)),
  di_obs = target(pull_di(di),
                  transform = map(di)),
  di_obs_s = target(dplyr::bind_rows(di_obs),
                    transform = combine(di_obs, .by = singletons)),
  all_di_obs = target(dplyr::bind_rows(di_obs_s_TRUE, di_obs_s_FALSE)),
  report = target(render_report(here::here("analysis", "reports", "dat_report_template.Rmd"), dependencies = all_di_obs, is_template = TRUE, dat_name = !!datasets),
                  trigger = trigger(condition = T),
                  hpc = F)
)


## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-portal_plants.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)
cache$del(key = "lock", namespace = "session")

## View the graph of the plan
if (interactive())
{
  config <- drake_config(all, cache = cache)
  sankey_drake_graph(config, build_times = "none")  # requires "networkD3" package
  vis_drake_graph(config, build_times = "none")     # requires "visNetwork" package
}

## Run the pipeline
nodename <- Sys.info()["nodename"]
if(grepl("ufhpc", nodename)) {
  print("I know I am on the HiPerGator!")
  library(clustermq)
  options(clustermq.scheduler = "slurm", clustermq.template = "slurm_clustermq.tmpl")
  ## Run the pipeline parallelized for HiPerGator
  make(all,
       force = TRUE,
       cache = cache,
       cache_log_file = here::here("analysis", "drake", "cache_log_portal_plants.txt"),
       verbose = 2,
       parallelism = "clustermq",
       jobs = 15,
       caching = "master") # Important for DBI caches!
} else {
  library(clustermq)
  options(clustermq.scheduler = "multicore")
  # Run the pipeline on multiple local cores
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_portal_plants.txt"), parallelism = "clustermq", jobs = 2))
}


## make .csv files for easier portability
summary_targets <- dplyr::filter(dat_plan, substr(target, 0, 8) == "diffs_su")
diffs_summaries <- list()
for(i in 1:length(summary_targets$target)) {
  diffs_summaries[[i]] <- readd(summary_targets$target[i], cache = cache, character_only = T)
}
all_summaries <- dplyr::bind_rows(diffs_summaries)
write.csv(all_summaries, here::here("analysis", "results", "diff_summaries_portal.csv"), row.names = F)
rm(diffs_summaries)
rm(all_summaries)
all_di <- readd(all_di_obs, cache = cache)
write.csv(all_di, here::here("analysis", "results", "all_di_portal.csv"), row.names = F)
rm(all_di)

DBI::dbDisconnect(db)
rm(cache)
print("Completed OK")
