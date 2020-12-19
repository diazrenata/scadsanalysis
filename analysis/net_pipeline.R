library(drake)
library(scadsanalysis)
library(ggplot2)
library(dplyr)

expose_imports("scadsanalysis")

net <- build_net()

net_sites <- net %>%
  select(-rank, -abund)

ndraws = 4000
ncomparisons = 200
#net_sites <- net_sites[1:10, ]
set.seed(1978)

dat_plan <- drake_plan(
  dat = target(build_net(),
               hpc = F
  ),
  tall_p = target(readRDS(here::here("analysis", "masterp_tall.Rds")),
                  hpc = F),
  fs = target(sample_fs_wrapper(dataset = dat, site_name = s, singletonsyn = FALSE, n_samples = ndraws, p_table = tall_p, seed = !!sample.int(10^6, size = 1)),
              transform = map(s = !!net_sites$site)),
  di = target(add_dis(fs),
              transform = map(fs)),
   di_summary = target(pull_di_net(di),
                   transform = map(di)),
  all_di_summary = target(dplyr::bind_rows(di_summary),
                     transform = combine(di_summary)),
  diffs = target(rep_diff_sampler(fs, ndraws = !!ncomparisons),
                 transform = map(fs)),
  all_diffs = target(dplyr::bind_rows(diffs),
                     transform = combine(diffs))
)


all <- dat_plan

## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-net.sqlite"))
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
  options(clustermq.scheduler = "slurm", clustermq.template = here::here("slurm_clustermq.tmpl"))
  ## Run the pipeline parallelized for HiPerGator
  make(all,
       force = TRUE,
       cache = cache,
       cache_log_file = here::here("analysis", "drake", "cache_log_net.txt"),
       verbose = 2,
       parallelism = "clustermq",
       jobs = 20,
       caching = "master", memory_strategy = "autoclean") # Important for DBI caches!
} else {

  # Run the pipeline on multiple local cores
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_net.txt")))
}

DBI::dbDisconnect(db)
rm(cache)
print("Completed OK")
