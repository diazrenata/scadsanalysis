library(drake)
library(scadsanalysis)
library(ggplot2)

expose_imports("scadsanalysis")

library(dplyr)
dat <- portalr::summarise_individual_rodents(type = "Granivores")

dat <- dat %>%
  filter(treatment == "control") %>%
  group_by(period, species) %>%
  summarize(abund = n()) %>%
  ungroup() %>%
  group_by(period) %>%
  arrange(abund) %>%
  mutate(rank = row_number()) %>%
  ungroup() %>%
  select(rank, abund, period) %>%
  mutate(site = as.character(period),
         dat = "portal_rodents",
         singletons = F,
         sim = -99,
         source = "observed") %>%
  select(-period)


sites_list <- dat %>%
  select(site, source) %>%
  distinct()


#sites_list <- sites_list[1:2, ]
set.seed(1977)

all <- drake_plan(
  dat_s = target(add_singletons_dataset(dat),
                 hpc = F),
  wide_p = target(readRDS(here::here("analysis", "masterp_wide.Rds")),
                  hpc = F),
  fs = target(sample_fs_wrapper(dataset = dat_s_dat, site_name = s, singletonsyn = singletons, n_samples = ndraws, p_table = wide_p, seed = !!sample.int(10^6, size = 1)),
              transform = cross(s = !!sites_list$site,
                                singletons = !!c(TRUE, FALSE))),
  di = target(add_dis(fs),
              transform = map(fs)),
  di_obs = target(pull_di(di),
                  transform = map(di)),
  di_obs_s = target(dplyr::bind_rows(di_obs),
                    transform = combine(di_obs, .by = singletons)),
  all_di_obs = target(dplyr::bind_rows(di_obs_s_TRUE, di_obs_s_FALSE))
)


## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-portal_rodents.sqlite"))
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
#if(FALSE){
  print("I know I am on the HiPerGator!")
  library(clustermq)
  options(clustermq.scheduler = "slurm", clustermq.template = "slurm_clustermq.tmpl")
  ## Run the pipeline parallelized for HiPerGator
  make(all,
       force = TRUE,
       cache = cache,
       cache_log_file = here::here("analysis", "drake", "cache_log_portal_rodents.txt"),
       verbose = 2,
       parallelism = "clustermq",
       jobs = 15,
       caching = "master") # Important for DBI caches!
} else {
  library(clustermq)
  options(clustermq.scheduler = "multicore")
  # Run the pipeline on multiple local cores
  system.time(make(all, cache = cache, cache_log_file = here::here("analysis", "drake", "cache_log_portal_rodents.txt"), parallelism = "clustermq", jobs = 2))
}

DBI::dbDisconnect(db)
rm(cache)
print("Completed OK")
