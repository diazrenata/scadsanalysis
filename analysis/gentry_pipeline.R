library(drake)
library(scadsanalysis)
library(ggplot2)

expose_imports("scadsanalysis")

datasets <- "gentry"

sites_list <- list_sites("gentry")
ndraws = 2500
#sites_list <- sites_list[1:15, ]

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
  wide_p = target(readRDS(here::here("analysis", "masterp_wide.Rds")),
                  hpc = F),
  fs = target(sample_fs_wrapper(dataset = dat_s_dat_gentry, site_name = s, singletonsyn = singletons, n_samples = ndraws, p_table = wide_p),
                   transform = cross(s = !!sites_list$site,
                                     singletons = !!c(TRUE, FALSE))),
  di = target(add_dis(fs),
              transform = map(fs)),
  all_di = target(dplyr::bind_rows(di),
                  transform = combine(di),
                  hpc = F),
  report = target(render_report(here::here("analysis", "reports", "dat_report_template.Rmd"), dependencies = all_di, is_template = TRUE, dat_name = !!datasets),
                  trigger = trigger(condition = T),
                  hpc = F)
)

## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-gentry.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)

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
       cache_log_file = here::here("analysis", "drake", "cache_log_gentry.txt"),
       verbose = 2,
       parallelism = "clustermq",
       jobs = 20,
       caching = "master",
       memory_strategy = "autoclean") # Important for DBI caches!
} else {
  library(clustermq)
  options(clustermq.scheduler = "multicore")
  # Run the pipeline on multiple local cores
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_gentry.txt"), parallelism = "clustermq", jobs = 2))
}

DBI::dbDisconnect(db)
rm(cache)

print("Completed OK")
