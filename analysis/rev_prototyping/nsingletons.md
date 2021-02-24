Shannon diversity
================
Renata Diaz
2021-02-23

    ## Warning: Removed 10 rows containing missing values (geom_bar).

![](nsingletons_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

    ## Warning: Removed 10 rows containing missing values (geom_bar).

![](nsingletons_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

![](nsingletons_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

    ## `summarise()` has grouped output by 'dat'. You can override using the `.groups` argument.

<div class="kable-table">

| dat         | singletons | prop\_high\_singles | prop\_high\_singles\_ex | prop\_low\_singles | prop\_low\_singles\_ex | nsites |
| :---------- | :--------- | ------------------: | ----------------------: | -----------------: | ---------------------: | -----: |
| bbs         | FALSE      |           0.1244140 |               0.0796971 |          0.0000000 |              0.0046881 |   2773 |
| fia         | FALSE      |           0.1367263 |               0.0241836 |          0.0000000 |              0.1062986 |  20179 |
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
| bbs         | FALSE      |           0.0000000 |               0.0000000 |          0.0000000 |              0.0000000 |      1 |
| fia         | FALSE      |           0.0440663 |               0.0021273 |          0.0000000 |              0.0284151 |   6581 |
| gentry      | FALSE      |           0.0000000 |               0.0000000 |          0.7093023 |              0.7325581 |     86 |
| mcdb        | FALSE      |           0.2777778 |               0.0000000 |          0.0000000 |              0.0740741 |     54 |
| misc\_abund | FALSE      |           0.1250000 |               0.0000000 |          0.0000000 |              0.0833333 |     48 |

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
| fia         | FALSE      |           0.4256804 |               0.0865318 |                  0 |              0.4996511 |   1433 |
| gentry      | FALSE      |           0.4285714 |               0.1904762 |                  0 |              0.0952381 |     21 |
| mcdb        | FALSE      |           0.5406824 |               0.2047244 |                  0 |              0.4540682 |    381 |
| misc\_abund | FALSE      |           0.6608187 |               0.4385965 |                  0 |              0.1871345 |    342 |

</div>

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](nsingletons_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

<div class="kable-table">

| dat         | mean\_singles\_change |   n |
| :---------- | --------------------: | --: |
| bbs         |             0.0667465 | 221 |
| fia         |             0.2174023 | 488 |
| gentry      |             0.1054487 |   4 |
| mcdb        |             0.2015754 |  90 |
| misc\_abund |             0.1607340 | 165 |

</div>
