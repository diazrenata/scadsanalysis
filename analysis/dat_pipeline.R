library(drake)
library(scadsanalysis)
library(ggplot2)

expose_imports("scadsanalysis")

#sites_list <- lapply(list("mcdb", "gentry", "fia", "bbs", "misc_abund"), FUN = list_sites)
sites_list <- lapply(list("misc_abund"), FUN = list_sites)

sites_list <- dplyr::bind_rows(sites_list)

dat_plan <- drake_plan(
  dat = target(load_sad(dataset_name = d, site_name = s),
               transform = map(
                 d = !!sites_list$dat,
                 s = !!sites_list$site
               )
  ),
  singles = target(add_singletons(dat),
                   transform = map(dat)),
  all_dat = target(dplyr::bind_rows(dat, singles),
                   transform = combine(dat, singles)),
  statevars = target(get_statevars(all_dat)),
  statevars_report = target(render_report(here::here("analysis", "reports", "statevars.Rmd"), dependencies = statevars))
)

all <- dat_plan

## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-dat.sqlite"))
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
  library(future.batchtools)
  print("I know I am on SLURM!")
  ## Run the pipeline parallelized for HiPerGator
  future::plan(batchtools_slurm, template = "slurm_batchtools.tmpl")
  make(all,
       force = TRUE,
       cache = cache,
       cache_log_file = here::here("analysis", "drake", "cache_log_dat.txt"),
       verbose = 2,
       parallelism = "future",
       jobs = 200,
       caching = "master") # Important for DBI caches!
} else {
  # Run the pipeline on a single local core
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_dat.txt")))
}


print("Completed OK")
