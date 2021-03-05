Jackknife
================
Renata Diaz
2021-03-02

  - [Skewness](#skewness)
  - [Evenness](#evenness)
  - [Shannon](#shannon)
  - [Percent off](#percent-off)
  - [Nsingletons excl](#nsingletons-excl)

<!-- ## S and N -->

<!-- ```{r} -->

<!-- ggplot(jk_di_mean_results, aes(s0_actual, s0)) + -->

<!--   geom_point() + -->

<!--   geom_line(aes(s0_actual, s0_actual)) + -->

<!--   facet_wrap(vars(dat), scales = "free") -->

<!-- ggplot(jk_di_mean_results, aes(n0_actual, n0)) + -->

<!--   geom_point() + -->

<!--   geom_line(aes(n0_actual, n0_actual)) + -->

<!--   facet_wrap(vars(dat), scales = "free") -->

<!-- ``` -->

## Skewness

![](jacknife_results_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->![](jacknife_results_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

<div class="kable-table">

| dat         | prop\_skew\_high\_jk | prop\_skew\_high\_raw | prop\_skew\_low\_jk | prop\_skew\_low\_raw | nsites\_included |
| :---------- | -------------------: | --------------------: | ------------------: | -------------------: | ---------------: |
| bbs         |            0.1100000 |             0.1366667 |           0.0366667 |            0.0366667 |              300 |
| fia         |            0.0207219 |             0.0628342 |           0.0006684 |            0.0106952 |             1496 |
| gentry      |            0.0986547 |             0.1883408 |           0.0762332 |            0.0896861 |              223 |
| mcdb        |            0.1172840 |             0.1748971 |           0.0020576 |            0.0144033 |              486 |
| misc\_abund |            0.2955975 |             0.3563941 |           0.0020964 |            0.0041929 |              477 |

</div>

## Evenness

![](jacknife_results_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->![](jacknife_results_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

<div class="kable-table">

| dat         | prop\_simpson\_high\_jk | prop\_simpson\_high\_raw | prop\_simpson\_low\_jk | prop\_simpson\_low\_raw | nsites\_included |
| :---------- | ----------------------: | -----------------------: | ---------------------: | ----------------------: | ---------------: |
| bbs         |               0.0433333 |                0.0333333 |              0.1866667 |               0.2900000 |              300 |
| fia         |               0.0006684 |                0.0026738 |              0.0541444 |               0.1076203 |             1496 |
| gentry      |               0.2276786 |                0.2723214 |              0.0758929 |               0.1517857 |              224 |
| mcdb        |               0.0060976 |                0.0101626 |              0.2865854 |               0.3861789 |              492 |
| misc\_abund |               0.0020877 |                0.0041754 |              0.5073069 |               0.6096033 |              479 |

</div>

## Shannon

![](jacknife_results_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->![](jacknife_results_files/figure-gfm/unnamed-chunk-3-2.png)<!-- -->

<div class="kable-table">

| dat         | prop\_shannon\_high\_jk | prop\_shannon\_high\_raw | prop\_shannon\_low\_jk | prop\_shannon\_low\_raw | nsites\_included |
| :---------- | ----------------------: | -----------------------: | ---------------------: | ----------------------: | ---------------: |
| bbs         |               0.0333333 |                0.0333333 |              0.1900000 |               0.3200000 |              300 |
| fia         |               0.0006684 |                0.0006684 |              0.0508021 |               0.0989305 |             1496 |
| gentry      |               0.2500000 |                0.2500000 |              0.0669643 |               0.1294643 |              224 |
| mcdb        |               0.0060976 |                0.0060976 |              0.3231707 |               0.4186992 |              492 |
| misc\_abund |               0.0020877 |                0.0020877 |              0.5219207 |               0.6367432 |              479 |

</div>

## Percent off

![](jacknife_results_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->![](jacknife_results_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->

<div class="kable-table">

| dat         | prop\_mean\_po\_comparison\_high\_jk | prop\_mean\_po\_comparison\_high\_raw | nsites\_included |
| :---------- | -----------------------------------: | ------------------------------------: | ---------------: |
| bbs         |                            0.1433333 |                             0.2500000 |              300 |
| fia         |                            0.0374332 |                             0.0929144 |             1496 |
| gentry      |                            0.1741071 |                             0.3125000 |              224 |
| mcdb        |                            0.2621951 |                             0.3536585 |              492 |
| misc\_abund |                            0.4885177 |                             0.6033403 |              479 |

</div>

<!-- ## Nsingletons -->

<!-- ```{r} -->

<!-- ggplot(filter(jk_di_mean_results, nparts > 20), aes(nsingletons_percentile_excl)) + -->

<!--   geom_histogram(bins = 100) + -->

<!--   facet_wrap(vars(dat), scales = "free_y", ncol = 1) + -->

<!--   geom_vline(xintercept = 95) -->

<!-- ggplot(filter(jk_di_mean_results, nparts > 20), aes(nsingletons_percentile_actual)) + -->

<!--   geom_histogram(bins = 100) + -->

<!--   facet_wrap(vars(dat), scales = "free_y", ncol = 1) + -->

<!--   geom_vline(xintercept = 95) -->

<!-- jk_di_mean_results  %>%  -->

<!--   group_by(dat) %>% -->

<!--   summarize(prop_nsingletons_high_jk = mean(nsingletons_percentile > 95), -->

<!--             prop_nsingletons_high_raw = mean(nsingletons_percentile_actual > 95), -->

<!--             nsites_included = dplyr::n()) -->

<!-- ``` -->

## Nsingletons excl

Visualization and analysis of nsingletons has a little more nuance than
the others, because there are often relatively few values for
nsingletons at all. 80% of sites have fewer than 20 singletons as the
95th percentile, which is just a rough way of saying that a **lot** of
these are going to be sensitive to whether you define the percentiles as
\> or \>=.

In general the strict \> percentile will give you an (appropriately)
conservative estimate of how many are extraordinarily **high** and the
\>= will give you an appropriate estimate of how many are unusually
**low**. For most metrics it doesn’t really matter, writ large, which
you use, because ties are rare. For this one, you get large numbers of
sites where a lot of values are = to the observed values, and the \>=
decision will therefore give you a jump of a lot of percentile scores.

For the “proportions high/low” calculations, we use *the \> percentile
for high* and *the \>= percentile for low*. For visualization, because
we are interested in both unusually high and unusually low scores, we
can’t just pick one or the other. The histogram using \>= is reliable at
the high end but has a misleading spike at 0, and vice versa. I am
making these plots using the *mean*, which doesn’t have the misleading
spikes at the extremes but does smear things out a little bit.

![](jacknife_results_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->![](jacknife_results_files/figure-gfm/unnamed-chunk-6-2.png)<!-- -->

<div class="kable-table">

| dat         | prop\_nsingletons\_high\_jk | prop\_nsingletons\_high\_raw | prop\_nsingletons\_low\_jk | prop\_nsingletons\_low\_raw | nsites\_included |
| :---------- | --------------------------: | ---------------------------: | -------------------------: | --------------------------: | ---------------: |
| bbs         |                   0.0466667 |                    0.0833333 |                  0.0000000 |                   0.0000000 |              300 |
| fia         |                   0.0080214 |                    0.0307487 |                  0.0006684 |                   0.0000000 |             1496 |
| gentry      |                   0.0133929 |                    0.0178571 |                  0.2366071 |                   0.2991071 |              224 |
| mcdb        |                   0.0670732 |                    0.1747967 |                  0.0000000 |                   0.0000000 |              492 |
| misc\_abund |                   0.2066806 |                    0.3444676 |                  0.0000000 |                   0.0000000 |              479 |

</div>

<!-- ```{r, fig.dim = c(8,8)} -->

<!-- fia_max_n = 150 -->

<!-- fia_max_s = 21 -->

<!-- ggplot(jk_di_mean_results, aes(s0, n0, color = dat)) + -->

<!--   geom_point(aes(s0_actual, n0_actual), color = "grey", alpha  = .2)+ -->

<!--     geom_point(aes(s0, n0, color = dat), alpha = .5) + -->

<!--   theme_bw() + -->

<!--   scale_x_log10() + -->

<!--   scale_y_log10() + -->

<!--   facet_wrap(vars(dat)) + -->

<!--   geom_vline(xintercept = fia_max_s) + -->

<!--   geom_hline(yintercept = fia_max_n) + -->

<!--   theme(legend.position = "top") -->

<!-- jk_di_mean_results <- jk_di_mean_results %>% -->

<!--   group_by_all() %>% -->

<!--   mutate(fiasized = (s0 <= fia_max_s) && (n0 <= fia_max_n), -->

<!--          fiasized_acutal =(s0_actual <= fia_max_s) && (n0_actual <= fia_max_n) ) %>% -->

<!--   ungroup() -->

<!-- jk_di_mean_results %>% -->

<!--   group_by(dat) %>% -->

<!--   summarize(jk_small = mean(fiasized), actual_small = mean(fiasized_acutal), nsites = dplyr::n()) -->

<!-- jk_di_mean_results %>% -->

<!--   group_by(dat, fiasized) %>% -->

<!--   summarize( nsingletons_high  = mean(nsingletons_percentile_excl > 95), nsites = dplyr::n()) -->

<!-- ``` -->

<!-- ```{r, fig.dim = c(6,6)} -->

<!-- jk_di_mean_results <- jk_di_mean_results %>% -->

<!--  #select(-singletons_percentile_excl_high_insig, -singletons_percentile_low_insig) -->

<!--   group_by_all() %>% -->

<!--   mutate(prop_singletons = nsingletons / s0, -->

<!--          prop_singletons_actual = nsingletons_actual / s0, -->

<!--          singletons_percentile_high_change = paste0("actual", (nsingletons_percentile_excl_actual > 95), "_jk", (nsingletons_percentile_excl > 95)), -->

<!--          singletons_percentile_low_change = paste0("actual", (nsingletons_percentile_actual <5), "_jk", (nsingletons_percentile < 5))) %>% -->

<!--   ungroup() %>% -->

<!--   mutate(prop_singletons_change = prop_singletons - prop_singletons_actual) -->

<!-- ggplot(jk_di_mean_results, aes(prop_singletons_actual, prop_singletons, color =singletons_percentile_high_change)) + geom_point() + geom_line(aes(prop_singletons_actual,prop_singletons_actual), inherit.aes = F) -->

<!-- ggplot(jk_di_mean_results, aes(nsingletons_actual, nsingletons,color = singletons_percentile_high_change)) + geom_point() + geom_line(aes(nsingletons_actual,nsingletons_actual), inherit.aes = F) +facet_wrap(vars(dat), scales = "free") + theme(legend.position = "top") -->

<!-- ggplot(jk_di_mean_results, aes(s0,n0, color =  -->

<!-- ggplot(jk_di_mean_results, aes(nsingletons_actual, nsingletons,color = singletons_percentile_high_change)) + geom_point() + geom_line(aes(nsingletons_actual,nsingletons_actual), inherit.aes = F) +facet_wrap(vars(dat), scales = "free") + theme(legend.position = "top") -->

<!-- )) + geom_point() +scale_x_log10() +scale_y_log10() + -->

<!--   facet_wrap(vars(dat), scales = "free") + -->

<!--   theme(legend.position = "top") -->

<!-- ggplot(jk_di_mean_results, aes(s0,n0, color = singletons_percentile_low_change)) + geom_point() +scale_x_log10() +scale_y_log10()+ -->

<!--   facet_wrap(vars(dat), scales = "free") + -->

<!--   theme(legend.position = "top") -->

<!-- ggplot(jk_di_mean_results, aes(n0/s0, nsingletons_percentile_excl, color = singletons_percentile_high_change)) + geom_point()+ -->

<!--   facet_wrap(vars(dat), scales = "free") + -->

<!--   theme(legend.position = "top") -->

<!-- ``` -->
