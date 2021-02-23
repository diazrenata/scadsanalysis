Shannon diversity
================
Renata Diaz
2021-02-23

    ## Warning: Removed 8 rows containing missing values (geom_bar).

![](nsingletons_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

    ## Warning: Removed 8 rows containing missing values (geom_bar).

![](nsingletons_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

![](nsingletons_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

    ## `summarise()` has grouped output by 'dat'. You can override using the `.groups` argument.

<div class="kable-table">

| dat         | singletons | prop\_high\_singles | prop\_high\_singles\_ex | prop\_low\_singles | prop\_low\_singles\_ex | nsites |
| :---------- | :--------- | ------------------: | ----------------------: | -----------------: | ---------------------: | -----: |
| bbs         | FALSE      |           0.1244140 |               0.0796971 |          0.0000000 |              0.0046881 |   2773 |
| gentry      | FALSE      |           0.0446429 |               0.0178571 |          0.2991071 |              0.3169643 |    224 |
| mcdb        | FALSE      |           0.4347181 |               0.1335312 |          0.0000000 |              0.3679525 |    674 |
| misc\_abund | FALSE      |           0.4823748 |               0.3061224 |          0.0000000 |              0.1391466 |    539 |

</div>

``` r
ggplot(all_di, aes(n0/s0, nsingletons_percentile_excl, color = singles_desc)) +
  geom_point() +
  facet_wrap(vars(dat), scales = "free") +
  scale_x_log10() +
  geom_vline(xintercept = c(3, 5, 10))
```

![](nsingletons_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
ggplot(all_di, aes(n0/s0, nsingletons_percentile_excl, color = singles_desc)) +
  geom_point(data = filter(all_di, singles_desc != "int")) +
  geom_point(alpha = .1, color = "grey") +
  facet_wrap(vars(dat), scales = "free") +
  scale_x_log10() +
  geom_vline(xintercept = c(3, 5, 10))
```

![](nsingletons_files/figure-gfm/unnamed-chunk-3-2.png)<!-- -->

``` r
all_di %>%
  filter(n0/s0 < 3) %>%
  group_by(dat, singletons) %>%
  summarize(prop_high_singles = mean(high_singles),
            prop_high_singles_ex = mean(high_singles_ex),
            prop_low_singles = mean(low_singles),
            prop_low_singles_ex = mean(low_singles_ex),
            nsites= dplyr::n()) %>%
  ungroup()
```

    ## `summarise()` has grouped output by 'dat'. You can override using the `.groups` argument.

<div class="kable-table">

| dat         | singletons | prop\_high\_singles | prop\_high\_singles\_ex | prop\_low\_singles | prop\_low\_singles\_ex | nsites |
| :---------- | :--------- | ------------------: | ----------------------: | -----------------: | ---------------------: | -----: |
| bbs         | FALSE      |           0.0000000 |                       0 |          0.0000000 |              0.0000000 |      1 |
| gentry      | FALSE      |           0.0000000 |                       0 |          0.7093023 |              0.7325581 |     86 |
| mcdb        | FALSE      |           0.2777778 |                       0 |          0.0000000 |              0.0740741 |     54 |
| misc\_abund | FALSE      |           0.1250000 |                       0 |          0.0000000 |              0.0833333 |     48 |

</div>

``` r
all_di %>%
  filter(n0/s0 > 10) %>%
  group_by(dat, singletons) %>%
  summarize(prop_high_singles = mean(high_singles),
            prop_high_singles_ex = mean(high_singles_ex),
            prop_low_singles = mean(low_singles),
            prop_low_singles_ex = mean(low_singles_ex),
            nsites= dplyr::n()) %>%
  ungroup()
```

    ## `summarise()` has grouped output by 'dat'. You can override using the `.groups` argument.

<div class="kable-table">

| dat         | singletons | prop\_high\_singles | prop\_high\_singles\_ex | prop\_low\_singles | prop\_low\_singles\_ex | nsites |
| :---------- | :--------- | ------------------: | ----------------------: | -----------------: | ---------------------: | -----: |
| bbs         | FALSE      |           0.1645873 |               0.1060461 |                  0 |              0.0062380 |   2084 |
| gentry      | FALSE      |           0.4285714 |               0.1904762 |                  0 |              0.0952381 |     21 |
| mcdb        | FALSE      |           0.5406824 |               0.2047244 |                  0 |              0.4540682 |    381 |
| misc\_abund | FALSE      |           0.6608187 |               0.4385965 |                  0 |              0.1871345 |    342 |

</div>

<!-- ```{r} -->

<!-- ggplot(filter(all_di, nsingletons >= nsingletons_95), aes(nsingletons_mean, nsingletons)) + -->

<!--   geom_point(alpha = .2) + -->

<!-- #  geom_line(aes(nsingletons_mean, nsingletons_mean)) + -->

<!--     geom_line(aes(nsingletons_95, nsingletons_95)) + -->

<!--   facet_wrap(vars(dat), scales = "free") -->

<!-- ggplot(filter(all_di, nsingletons >= nsingletons_95), aes(nsingletons, nsingletons-nsingletons_95)) + -->

<!--   geom_point(alpha = .2) + -->

<!-- #  geom_line(aes(nsingletons_mean, nsingletons_mean)) + -->

<!--   facet_wrap(vars(dat), scales = "free") -->

<!-- ``` -->
