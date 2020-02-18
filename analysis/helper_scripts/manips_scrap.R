library(drake)

cache_loc = "macdb"
## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", paste0("drake-cache-", cache_loc, ".sqlite")))
cache <- storr::storr_dbi("datatable", "keystable", db)
all_di_macd <- readd(all_di_manip, cache = cache)
macd_dat <- readd(dat_s_dat_macdb, cache = cache)
DBI::dbDisconnect(db)
rm(cache)

storage_path = here::here("working-data", "macdb_data")
all_di <- all_di_macd
