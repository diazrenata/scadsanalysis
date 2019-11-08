library(drake)
library(scadsanalysis)
library(ggplot2)

expose_imports("scadsanalysis")

datasets <- c("mcdb", "gentry", "bbs", "misc_abund", "fia")

#datasets <- c("mcdb", "bbs")

sites_list <- lapply(as.list(datasets), FUN = list_sites)
names(sites_list) <- datasets
#sites_list$mcdb <- sites_list$mcdb[1:10, ]
ndraws = 100

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
  sv = target(get_statevars(dat_s),
              transform = map(dat_s),
              hpc = F),
  all_sv = target(dplyr::bind_rows(sv),
                  transform = combine(sv),
                  hpc = F),
  sv_report = target(render_report(here::here("analysis", "reports", "statevars.Rmd"), dependencies = all_sv),
                     trigger = trigger(condition = T),
                     hpc = F),
  mamm_p = target(readRDS(here::here("analysis", "masterp_mamm.Rds")),
                  hpc = F),
  wide_p = target(readRDS(here::here("analysis", "masterp_wide.Rds")),
                  hpc = F),
  fs_mcdb = target(sample_fs_wrapper(dataset = dat_s_dat_mcdb, site_name = s, singletonsyn = singletons, n_samples = ndraws, p_table = mamm_p),
                   transform = cross(s = !!sites_list$mcdb$site,
                                     singletons = !!c(TRUE, FALSE))),
  # fs_fia = target(sample_fs_wrapper(dataset = dat_s_dat_fia, site_name = s, singletonsyn = singletons, n_samples = ndraws, p_table = wide_p),
  #                 transform = cross(s = !!sites_list$fia$site,
  #                                   singletons = !!c(TRUE, FALSE))),
  # fs_gentry = target(sample_fs_wrapper(dataset = dat_s_dat_gentry, site_name = s, singletonsyn = singletons, n_samples = ndraws, p_table = wide_p),
  #                 transform = cross(s = !!sites_list$gentry$site,
  #                                   singletons = !!c(TRUE, FALSE))),
  fs_bbs = target(sample_fs_wrapper(dataset = dat_s_dat_bbs, site_name = s, singletonsyn = singletons, n_samples = ndraws, p_table = wide_p),
                  transform = cross(s = !!sites_list$bbs$site,
                                    singletons = !!c(TRUE, FALSE))),
  mcdb_di = target(add_dis(fs_mcdb),
              transform = map(fs_mcdb)),
  bbs_di = target(add_dis(fs_bbs),
              transform = map(fs_bbs)),
  all_mcdb_di = target(dplyr::bind_rows(mcdb_di),
                    transform = combine(mcdb_di),
                    hpc = F),
  all_bbs_di = target(dplyr::bind_rows(bbs_di),
                      transform = combine(bbs_di),
                      hpc = F),
  all_di = target(dplyr::bind_rows(all_mcdb_di, all_bbs_di),
                  hpc = F)
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
  print("I know I am on the HiPerGator!")
  library(clustermq)
  options(clustermq.scheduler = "slurm", clustermq.template = "slurm_clustermq.tmpl")
  ## Run the pipeline parallelized for HiPerGator
  make(all,
       force = TRUE,
       cache = cache,
       cache_log_file = here::here("analysis", "drake", "cache_log_dat.txt"),
       verbose = 2,
       parallelism = "clustermq",
       jobs = 20,
       caching = "master") # Important for DBI caches!
} else {
  library(clustermq)
  options(clustermq.scheduler = "multicore")
  # Run the pipeline on multiple local cores
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_dat.txt"), parallelism = "clustermq", jobs = 2))
}


print("Completed OK")
