library(drake)
library(dplyr)
library(ggplot2)
library(scadsanalysis)

all_di <- list()
all_diffs <- list()
datasets <- c("bbs", "fia_short", "gentry", "mcdb", "misc_abund_short", "portal_plants", "fia_small")

#datasets <- c("fia", "gentry", "mcdb", "misc_abund_short", "portal_plants")

for(i in 1:length(datasets)) {

  this_dataset = datasets[i]
  if(this_dataset == "misc_abund_short") {
    cache_loc = "miscabund"
  } else if(this_dataset == "fia_short") {

    cache_loc = "fia"
  } else {
    cache_loc = this_dataset
  }

  ## Set up the cache and config
  db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", paste0("drake-cache-", cache_loc, ".sqlite")))
  cache <- storr::storr_dbi("datatable", "keystable", db)

  all_di[[i]] <- readd(all_di_obs, cache = cache)

  all_di[[i]] <- filter(all_di[[i]], source == "observed")

  if("all_diffs" %in% cached(cache)) {
    all_diffs[[i]] <- readd(all_diffs, cache = cache)

    all_diffs[[i]] <- select(all_diffs[[i]], -source)

    all_di[[i]] <- left_join(all_di[[i]], all_diffs[[i]])
  }
  #this_dat <- readd(paste0("dat_s_dat_", this_dataset), cache = cache, character_only = T)
  # sv <- get_statevars(this_dat)
  #  all_di[[i]] <- left_join(all_di[[i]], sv, by = c("sim", "site", "source", "singletons", "dat"))


  DBI::dbDisconnect(db)
  rm(cache)
  rm(db)
}


all_di <- bind_rows(all_di)

write.csv(all_di, "all_di.csv", row.names = F)
