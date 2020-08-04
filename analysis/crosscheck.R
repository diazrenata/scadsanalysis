library(dplyr)
library(ggplot2)
all_di <- read.csv(here::here("analysis", "reports", "all_di_old.csv"), stringsAsFactors = F)
all_di_old <- read.csv(here::here("all_di.csv"), stringsAsFactors = F)

fia_small_provisional <- filter(all_di_old, dat == "fia_small")

all_di_spring <- bind_rows(all_di, fia_small_provisional)


rm(all_di)
rm(all_di_old)
rm(fia_small_provisional)

all_di_summer <- read.csv(here::here("analysis", "reports", "all_di.csv"), stringsAsFactors = F) %>%
  mutate(site = as.character(site))

colnames(all_di_summer)
colnames(all_di_spring)

check_di <- all_di_spring %>%
  filter(dat != "portal_rodents", dat != "portal_plants") %>%
  select(dat, site, singletons, nparts, skew_percentile, simpson_percentile, s0, n0, nsamples, skew_range) %>%
  rename(         skew_percentile_s = skew_percentile,
         simpson_percentile_s = simpson_percentile,
         skew_range_s = skew_range) %>%
  full_join(select(all_di_summer, dat, site, singletons, nparts, skew_percentile, simpson_percentile, s0, n0, skew_range)) %>%
  filter(dat != "fia_small") %>% # different set of sites
  mutate(skew_change = skew_percentile - skew_percentile_s,
         even_change = simpson_percentile - simpson_percentile_s)

sort(as.numeric(filter(all_di_summer, dat == "fia_small")$site)) == sort(as.numeric(filter(all_di_spring, dat == "fia_small")$site))

head((filter(all_di_summer, dat == "fia_small")$site))
head((filter(all_di_spring, dat == "fia_small")$site))

ggplot(check_di, aes(skew_percentile_s, skew_percentile, color = nsamples)) + geom_point()


ggplot(filter(check_di, log(nparts) > log(20), s0 > 2), aes(skew_percentile_s, skew_percentile, color = nsamples)) + geom_point()

ggplot(filter(check_di, log(nparts) > log(150), s0 > 2), aes(skew_percentile_s, skew_percentile, color = nsamples)) + geom_point()


filter(check_di, !singletons,log(nparts) > log(50), skew_percentile_s == 0, skew_percentile > 95)

ggplot(filter(check_di, s0 > 2), aes(log(nparts), skew_change)) +
  geom_point()


ggplot(filter(check_di, s0 > 2), aes((nparts), skew_change, color = skew_percentile >= 95)) +
  geom_point() +
  xlim(0, 300)


all_di_summer %>%
  filter(!singletons) %>%
  group_by(dat) %>%
  summarize(
    propbelow_50 = mean(nparts < 50),
    nsites = dplyr::n()
  )

all_di_summer %>%
  filter(!singletons, s0 > 2) %>%
  group_by(dat) %>%
  summarize(
    propbelow_50 = mean(nparts < 50),
    nsites = dplyr::n()
  )

all_di_summer %>%
  filter(!singletons)  %>%
  summarize(
    propbelow_50 = mean(nparts < 50),
    nsites = dplyr::n()
  )


all_di_summer %>%
  filter(!singletons, s0 >2)  %>%
  summarize(
    propbelow_50 = mean(nparts < 50),
    nsites = dplyr::n()
  )


ggplot(filter(all_di_summer, !singletons), aes(log(s0), log(n0), color = nparts < 50)) +
  geom_point()



ggplot(filter(all_di_summer, !singletons), aes((s0), (n0), color = nparts < 50)) +
  geom_point() +
  xlim(0, 30) +
  ylim(0, 120)

