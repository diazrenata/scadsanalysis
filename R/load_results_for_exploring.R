library(dplyr)

all_di <- read.csv(here::here("analysis", "reports", "submission2", "all_di.csv"), stringsAsFactors = F)

all_ct <-  read.csv(here::here("analysis",  "reports", "submission2","all_ct.csv"), stringsAsFactors = F)


all_ct <- all_ct %>%
  mutate(dat = ifelse(grepl(dat, pattern = "fia"), "fia", dat),
         dat = ifelse(dat == "misc_abund_short", "misc_abund", dat))

all_di <- all_di %>%
  mutate(log_nparts = log(gmp:::as.double.bigz(nparts)),
         log_nsamples = log(nsamples),
         log_s0 = log(s0),
         log_n0 = log(n0)) %>%
  filter(n0 != s0,
         s0 != 1,
         !singletons,
         n0 != (s0 + 1)) %>%
  mutate(dat = ifelse(grepl(dat, pattern = "fia"), "fia", dat),
         dat = ifelse(dat == "misc_abund_short", "misc_abund", dat)) %>%
  mutate(Dataset = dat,
         Dataset = ifelse(Dataset == "fia", "FIA", Dataset),
         Dataset = ifelse(Dataset == "bbs", "Breeding Bird Survey", Dataset),
         Dataset = ifelse(Dataset == "mcdb", "Mammal Communities", Dataset),
         Dataset = ifelse(Dataset == "gentry", "Gentry", Dataset),
         Dataset = ifelse(Dataset == "misc_abund", "Misc. Abundance", Dataset)) %>%
  filter(nparts > 20) %>%
  left_join(all_ct)

all_di <- all_di %>%
  group_by_all() %>%
  mutate(real_po_percentile_mean = mean(real_po_percentile, real_po_percentile_excl),
         skew_percentile_mean = mean(skew_percentile, skew_percentile_excl),
         simpson_percentile_mean = mean(simpson_percentile,simpson_percentile_excl),
         shannon_percentile_mean = mean(shannon_percentile, shannon_percentile_excl),
         nsingletons_percentile_mean = mean(nsingletons_percentile, nsingletons_percentile_excl),) %>%
  ungroup()

all_di <- all_di %>%
  mutate(in_fia = ifelse(Dataset == "FIA", "FIA", "Other datasets"))
