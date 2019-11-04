library(drake)
library(scadsanalysis)
library(ggplot2)

expose_imports("scadsanalysis")

# datasets <- c("mcdb", "gentry", "bbs", "misc_abund", "fia")

#datasets <- c("mcdb", "gentry", "bbs", "misc_abund")

datasets <- c("mcdb")

sites_list <- lapply(as.list(datasets), FUN = list_sites)
names(sites_list) <- datasets
ndraws = 10000
#sites_list$mcdb <- sites_list$mcdb[1:10, ]

dat_plan <- drake_plan(
  dat = target(load_dataset(dataset_name = d),
               transform = map(
                 d = !!datasets
               )
  ),
  dat_s = target(add_singletons_dataset(dat),
                 transform = map(dat)),
  sv = target(get_statevars(dat_s),
              transform = map(dat_s)),
  all_sv = target(dplyr::bind_rows(sv),
                  transform = combine(sv)),
  sv_report = target(render_report(here::here("analysis", "reports", "statevars.Rmd"), dependencies = all_sv),
                     trigger = trigger(condition = T)),
 mamm_p = target(readRDS(here::here("analysis", "masterp_mamm.Rds"))),
  fs_mcdb = target(sample_fs_wrapper(dataset = dat_s_dat_mcdb, site_name = s, singletonsyn = singletons, n_samples = ndraws, p_table = mamm_p),
                   transform = cross(s = !!sites_list$mcdb$site,
                                      singletons = !!c(TRUE, FALSE))),
   all_mcdb = target(dplyr::bind_rows(fs_mcdb),
                        transform = combine(fs_mcdb)),
   di_mcdb = target(dis_wrapper(all_mcdb))
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
       jobs = 10,
       caching = "master") # Important for DBI caches!
} else {
  # Run the pipeline on a single local core
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_dat.txt")))
}


print("Completed OK")
