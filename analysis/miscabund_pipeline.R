library(drake)
library(scadsanalysis)
library(ggplot2)

expose_imports("scadsanalysis")

datasets <- "misc_abund_short"

sites_list <- list_sites("misc_abund_short")
ndraws = 4000
#sites_list <- sites_list[1:15, ]
set.seed(1981)

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
  fs = target(sample_fs_wrapper(dataset = dat_s_dat_misc_abund_short, site_name = s, singletonsyn = singletons, n_samples = ndraws, p_table = tall_p, seed = !!sample.int(10^6, size = 1)),
              transform = cross(s = !!sites_list$site,
                                singletons = !!c(TRUE, FALSE))),
  di = target(add_dis(fs),
              transform = map(fs)),
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
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-miscabund.sqlite"))
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
       cache_log_file = here::here("analysis", "drake", "cache_log_miscabund.txt"),
       verbose = 2,
       parallelism = "clustermq",
       jobs = 20,
       caching = "master",
       memory_strategy = "autoclean") # Important for DBI caches!
} else {
  library(clustermq)
  options(clustermq.scheduler = "multicore")
  # Run the pipeline on multiple local cores
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_miscabund.txt"), parallelism = "clustermq", jobs = 2))
}

DBI::dbDisconnect(db)
rm(cache)

print("Completed OK")
