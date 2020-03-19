library(drake)
library(scadsanalysis)
library(ggplot2)

expose_imports("scadsanalysis")

datasets <- "fia_small"

sites_list <- list_sites("fia_small")
ndraws = 4000
nresamples <- 4000

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
  mamm_p = target(readRDS(here::here("analysis", "masterp_mamm.Rds")),
                  hpc = F),
  fs = target(sample_fs_wrapper(dataset = dat_s_dat_fia_small, site_name = s, singletonsyn = singletons, n_samples = ndraws, p_table = mamm_p, seed = !!sample.int(10^6, size = 1)),
                   transform = cross(s = !!sites_list$site,
                                     singletons = !!c(TRUE, FALSE))),
  di = target(add_dis(fs),
              transform = map(fs)),
  diffs = target(rep_diff_sampler(fs, ndraws = !!nresamples),
                 transform = map(fs)),
  diffs_summary = target(summarize_diffs(diffs),
                         transform = map(diffs)),
  all_diffs = target(dplyr::bind_rows(diffs_summary),
                     transform = combine(diffs_summary)),
  di_obs = target(pull_di(di),
                  transform = map(di)),
  di_obs_s = target(dplyr::bind_rows(di_obs),
                    transform = combine(di_obs, .by = singletons)),
  all_di_obs = target(dplyr::bind_rows(di_obs_s_TRUE, di_obs_s_FALSE)),
  report = target(render_report(here::here("analysis", "reports", "dat_report_template.Rmd"), dependencies = all_di_obs, is_template = TRUE, dat_name = !!datasets),
                  trigger = trigger(condition = T),
                  hpc = F)
)

all <- dat_plan

## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-fia_small.sqlite"))
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
       cache_log_file = here::here("analysis", "drake", "cache_log_fia_small.txt"),
       verbose = 2,
       parallelism = "clustermq",
       jobs = 20,
       caching = "master", memory_strategy = "autoclean") # Important for DBI caches!
} else {
  library(clustermq)
  options(clustermq.scheduler = "multicore")
  # Run the pipeline on multiple local cores
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_fia_small.txt"), parallelism = "clustermq", jobs = 2))
}

DBI::dbDisconnect(db)
rm(cache)
print("Completed OK")
