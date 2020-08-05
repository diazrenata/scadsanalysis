Effect of \< v \<= in percentile definition
================
Renata Diaz
2020-08-05

You can define the %ile score as either

  - the % of values in a comparison vector that are **less than** a
    focal value
  - the % of values that are **less than or equal to** that value

You see both definitions out in the world.

When I initially coded up the analysis, I used **\<**. I didn’t think
about it much and as I was writing the manuscript I wrote **\<=**. So
that got me curious if it matters.

It *should not* matter too much as long as there are many unique values
in the comparison vector. However, if there are only a handful, and the
focal value is equal to an element of the comparison vector, using \<=
will cause the score to jump up. The jumps will be in increments of
100/n, with n the number of unique elements in the comparison vector.
Meaning if there is only one value, \< will give a score of 0 and \<=
will give a score of 100\!

#### Demo with toy data

``` r
percentile_lt <- function(focal, comparison) {
  100 * (sum(comparison < focal) / length(comparison))
}

percentile_ltet <- function(focal, comparison) {
  100 * (sum(comparison <= focal) / length(comparison))
}


# Many values

many <- seq(1, 100, by = .1)

focal <- runif(1, 1, 100)
focal <- round(focal, 1) # rounding so focal == a value in many gives you the largest possible jump for this scenario

percentile_lt(focal, many)
```

    ## [1] 21.59435

``` r
percentile_ltet(focal, many) 
```

    ## [1] 21.59435

``` r
# A few values
few <- seq(1, 101, by = 20)

focal <- ceiling(focal / 20) * 20 + 1 # again, rounding so focal == a value in few gives the largest possible jump

percentile_lt(focal, few)
```

    ## [1] 33.33333

``` r
percentile_ltet(focal, few)
```

    ## [1] 50

``` r
# Just one value

one <- runif(1, 1, 100)

focal <- one # for our purposes, if there is only 1 element in one, focal MUST be that element

percentile_lt(focal, one)
```

    ## [1] 0

``` r
percentile_ltet(focal, one)
```

    ## [1] 100

<!-- ```{r real data, include=FALSE} -->

<!-- all_di <- read.csv(here::here("analysis", "reports", "all_di.csv"), stringsAsFactors = F) -->

<!-- all_di <- all_di %>% -->

<!--   mutate(log_nparts = log(gmp:::as.double.bigz(nparts)), -->

<!--          log_nsamples = log(nsamples), -->

<!--          log_s0 = log(s0), -->

<!--          log_n0 = log(n0)) %>% -->

<!--   filter(n0 > s0, -->

<!--          !singletons, -->

<!--          dat %in% c("bbs", "fia_short", "fia_small", "gentry", "mcdb", "misc_abund_short")) %>% -->

<!--   mutate(dat = ifelse(grepl(dat, pattern = "fia"), "fia", dat), -->

<!--          dat = ifelse(dat == "misc_abund_short", "misc_abund", dat)) -->

<!-- ``` -->

<!-- # Final dataset in S and N space -->

<!-- ```{r final dataset s and n space} -->

<!-- ggplot(all_di, aes(x = log_s0, y = log_n0, color = dat)) + -->

<!--   geom_point(alpha = .01) + -->

<!--   geom_point(data = filter(all_di, log_nparts > log(50)), alpha = .4) + -->

<!--   theme_bw() + -->

<!--   scale_color_viridis_d() + -->

<!--   ggtitle("Communities by S and N") -->

<!-- ``` -->

<!-- ```{r skew change} -->

<!-- ggplot(filter(all_di, s0 > 2), aes(x = skew_percentile_excl, y = skew_percentile, color = nsamples)) + -->

<!--   geom_point() + -->

<!--   facet_wrap(vars(dat)) -->

<!-- all_di <- all_di  %>% -->

<!--   mutate(skew_change = skew_percentile - skew_percentile_excl, -->

<!--          even_change = simpson_percentile - -->

<!--            simpson_percentile_excl) -->

<!-- ggplot(filter(all_di, s0 > 2), aes(x = log_nparts, y = skew_change)) + -->

<!--   geom_point() + -->

<!--   xlim(0,15) + -->

<!--   facet_wrap(vars(dat)) -->

<!-- ``` -->

<!-- ```{r hists} -->

<!-- ``` -->
