Filtering datasets
================
Renata Diaz
2020-12-07

While preparing the filtering report, RMD noticed that some communities
in Misc. Abund have a **mixture** of relative abundance and count data.
This is a report to record that rabbit hole. It turned out not to be
problematic.

Here we can also identify which of the Misc Abund communities have the
*mixture* of relative and count data.

``` r
misc_abund_raw <- read.csv(here::here("working-data", "abund_data", "misc_abund_spab.csv"))

misc_abund_raw <- misc_abund_raw %>%
  dplyr::rename(site = Site_ID,
                abund = Abundance)

misc_abund_raw <- misc_abund_raw %>%
  mutate(site = as.character(site),
         dat = "misc_abund",
         singletons = F,
         sim = -99,
         source = "observed") %>%
  filter(abund > 0) %>%
  group_by(site) %>%
  arrange(abund) %>%
  mutate(rank = row_number()) %>%
  ungroup()



misc_abund_statevars <- get_statevars(misc_abund_raw)

misc_abund_sv_filtered <- misc_abund_statevars %>%
  filter(n0 <= 40720)

misc_abund_filtered <- filter(misc_abund_raw, site %in% misc_abund_sv_filtered$site)

misc_abund <- read.csv(here::here("working-data", "abund_data", "misc_abund_spab.csv"))

misc_abund <- misc_abund %>%
  dplyr::rename(site = Site_ID,
                abund = Abundance)

miscabund_issues <- misc_abund %>%
  group_by(site) %>%
  summarize(
    nspecies = dplyr::n(),
    nas.in.count = sum(is.na(abund)),
    n.nonzero.species = sum(abund > 0, na.rm = T)
  )

filter(miscabund_issues, nas.in.count > 0, n.nonzero.species > 0)
```

<div class="kable-table">

| site | nspecies | nas.in.count | n.nonzero.species |
| ---: | -------: | -----------: | ----------------: |
|  144 |       46 |           34 |                 3 |
|  145 |       46 |           34 |                 3 |
|  146 |       46 |           34 |                 3 |
|  147 |       46 |           34 |                 4 |
|  178 |       42 |            1 |                22 |
|  446 |      170 |            1 |               169 |

</div>

There are 6 sites for Misc Abund that have **both** NA’s recorded for
counted abundance **and** any non-0, non-NA records for counted
abundance. So that is, they have **some** actual count data (not 100%
relative abundance), but they also have NA’s for the counts.

For four of these - 144, 145, 146, and 147 - this appears to be because
reptiles are recorded in counts and arachnids are recorded as relative
abundances. Therefore, for these sites, the SAD we end up working with
is just the one for reptiles. For example:

``` r
filter(misc_abund, site == 145)
```

<div class="kable-table">

| Class     | Family         | Genus        | Species      | Relative\_abundance | abund | site | Citation |
| :-------- | :------------- | :----------- | :----------- | ------------------: | ----: | ---: | -------: |
| Reptilia  |                | Eumeces      | obsoletus    |                  NA |     0 |  145 |       12 |
| Reptilia  |                | Sceloporus   | magister     |                  NA |     0 |  145 |       12 |
| Reptilia  |                | Crotaphytus  | collaris     |                  NA |     0 |  145 |       12 |
| Reptilia  |                | Aspidoscelis | tesselatus   |                  NA |     0 |  145 |       12 |
| Reptilia  |                | Aspidoscelis | inornatus    |                  NA |     0 |  145 |       12 |
| Reptilia  |                | Aspidoscelis | tigris       |                  NA |     0 |  145 |       12 |
| Reptilia  |                | Cophosaurus  | texanus      |                  NA |     0 |  145 |       12 |
| Reptilia  |                | Gambelia     | wislizeni    |                  NA |     0 |  145 |       12 |
| Reptilia  |                | Holbrookia   | maculata     |                  NA |     0 |  145 |       12 |
| Reptilia  |                | Aspidoscelis | uniparens    |                  NA |     1 |  145 |       12 |
| Reptilia  |                | Uta          | stansburiana |                  NA |     2 |  145 |       12 |
| Reptilia  |                | Phrynosoma   | cornutum     |                  NA |     3 |  145 |       12 |
| Arachnida | Linyphiidae    |              | sp.          |                0.00 |    NA |  145 |       17 |
| Arachnida | Araneidae      |              | sp.          |                0.00 |    NA |  145 |       17 |
| Arachnida | Araneidae      |              | sp.          |                0.00 |    NA |  145 |       17 |
| Arachnida | Araneidae      |              | sp.          |                0.00 |    NA |  145 |       17 |
| Arachnida | Araneidae      |              | sp.          |                0.00 |    NA |  145 |       17 |
| Arachnida | Tetragnathidae |              | sp.          |                0.00 |    NA |  145 |       17 |
| Arachnida | Oxyopidae      |              | sp.          |                0.00 |    NA |  145 |       17 |
| Arachnida | Dictynidae     | Dictyna      | altamira     |               25.13 |    NA |  145 |       17 |
| Arachnida | Theridiidae    | Achaearanaea | globosus     |                0.00 |    NA |  145 |       17 |
| Arachnida | Linyphiidae    | Crammonota   | trivitatta   |              150.85 |    NA |  145 |       17 |
| Arachnida | Linyphiidae    | Erigone      | tenuipalpis  |               12.44 |    NA |  145 |       17 |
| Arachnida | Linyphiidae    | Floricomus   | crosbyi      |                0.00 |    NA |  145 |       17 |
| Arachnida | Linyphiidae    | Pelecopsis   | excavatum    |                0.00 |    NA |  145 |       17 |
| Arachnida | Araneidae      | Hyposinga    | variabilis   |               15.93 |    NA |  145 |       17 |
| Arachnida | Araneidae      | Neoscona     | pratensis    |                0.70 |    NA |  145 |       17 |
| Arachnida | Araneidae      | Argiope      | trifasciata  |                0.00 |    NA |  145 |       17 |
| Arachnida | Araneidae      | Acanthepeira | sp.          |                0.00 |    NA |  145 |       17 |
| Arachnida | Araneidae      | Eustala      | emertoni     |                0.09 |    NA |  145 |       17 |
| Arachnida | Tetragnathidae | Glenognatha  | ivei         |                0.00 |    NA |  145 |       17 |
| Arachnida | Tetragnathidae | Glenognatha  | sp.          |                6.85 |    NA |  145 |       17 |
| Arachnida | Tetragnathidae | Tetragnatha  | caudata      |                0.03 |    NA |  145 |       17 |
| Arachnida | Lycosidae      | Pardosa      | littoralis   |                2.45 |    NA |  145 |       17 |
| Arachnida | Lycosidae      | Lycosa       | modesta      |               37.81 |    NA |  145 |       17 |
| Arachnida | Lycosidae      | Pirata       | marxii       |                0.95 |    NA |  145 |       17 |
| Arachnida | Gnaphosidae    | Zelotes      | pullis       |                0.03 |    NA |  145 |       17 |
| Arachnida | Gnaphosidae    | Callilepis   | sp.          |                0.00 |    NA |  145 |       17 |
| Arachnida | Clubionidae    | Clubiona     | saltitans    |               10.45 |    NA |  145 |       17 |
| Arachnida | Clubionidae    | Clubiona     | nicholsi     |                0.06 |    NA |  145 |       17 |
| Arachnida | Thomisidae     | Misumenops   | sp.          |                0.03 |    NA |  145 |       17 |
| Arachnida | Philodromidae  | Tibellus     | oblongus     |                0.03 |    NA |  145 |       17 |
| Arachnida | Philodromidae  | Thanatus     | striatus     |                0.03 |    NA |  145 |       17 |
| Arachnida | Salticidae     | Marpissa     | pikei        |                0.15 |    NA |  145 |       17 |
| Arachnida | Salticidae     | Metacyrba    | undata       |                0.12 |    NA |  145 |       17 |
| Arachnida | Salticidae     | Sitticus     | palustris    |                0.92 |    NA |  145 |       17 |

</div>

``` r
filter(misc_abund_filtered, site == "145")
```

<div class="kable-table">

| Class    | Family | Genus        | Species      | Relative\_abundance | abund | site | Citation | dat         | singletons |  sim | source   | rank |
| :------- | :----- | :----------- | :----------- | ------------------: | ----: | :--- | -------: | :---------- | :--------- | ---: | :------- | ---: |
| Reptilia |        | Aspidoscelis | uniparens    |                  NA |     1 | 145  |       12 | misc\_abund | FALSE      | \-99 | observed |    1 |
| Reptilia |        | Uta          | stansburiana |                  NA |     2 | 145  |       12 | misc\_abund | FALSE      | \-99 | observed |    2 |
| Reptilia |        | Phrynosoma   | cornutum     |                  NA |     3 | 145  |       12 | misc\_abund | FALSE      | \-99 | observed |    3 |

</div>

Given that this appears to reflect different conventions for very
different **taxa** (and not a mix of data currencies for what we would
in other contexts consider the same community), RMD is comfortable
leaving these 4 sites in.

For 178 and 446, there are individual species (one at each site) with
“NA” and not 0 for abundance. RMD is leaving these in; it should have
no impact on the final results.

``` r
filter(misc_abund, site == 178, is.na(abund))
```

<div class="kable-table">

| Class          | Family     | Genus    | Species   | Relative\_abundance | abund | site | Citation |
| :------------- | :--------- | :------- | :-------- | ------------------: | ----: | ---: | -------: |
| Actinopterygii | Cyprinidae | Notropis | buchanani |                  NA |    NA |  178 |       30 |

</div>

``` r
filter(misc_abund, site == 446, is.na(abund))
```

<div class="kable-table">

| Class          | Family     | Genus     | Species | Relative\_abundance | abund | site | Citation |
| :------------- | :--------- | :-------- | :------ | ------------------: | ----: | ---: | -------: |
| Actinopterygii | Characidae | Roeboides | dayi    |                  NA |    NA |  446 |       71 |

</div>
