Shannon diversity
================
Renata Diaz
2021-02-25

![](nsingletons_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->![](nsingletons_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

![](nsingletons_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

    ## `summarise()` has grouped output by 'dat'. You can override using the `.groups` argument.

<div class="kable-table">

| dat         | singletons | prop\_high\_singles | prop\_high\_singles\_ex | prop\_low\_singles | prop\_low\_singles\_ex | nsites |
| :---------- | :--------- | ------------------: | ----------------------: | -----------------: | ---------------------: | -----: |
| bbs         | FALSE      |           0.1244140 |               0.0796971 |          0.0000000 |              0.0046881 |   2773 |
| fia         | FALSE      |           0.1356860 |               0.0264542 |          0.0000000 |              0.0992573 |  18447 |
| gentry      | FALSE      |           0.0446429 |               0.0178571 |          0.2991071 |              0.3169643 |    224 |
| mcdb        | FALSE      |           0.4710145 |               0.1630435 |          0.0000000 |              0.3695652 |    552 |
| misc\_abund | FALSE      |           0.5121457 |               0.3340081 |          0.0000000 |              0.1376518 |    494 |

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
| fia         | FALSE      |           0.0204849 |               0.0026311 |          0.0000000 |              0.0041346 |   5321 |
| gentry      | FALSE      |           0.0000000 |               0.0000000 |          0.7093023 |              0.7325581 |     86 |
| mcdb        | FALSE      |           0.3000000 |               0.0000000 |          0.0000000 |              0.0000000 |     10 |
| misc\_abund | FALSE      |           0.0000000 |               0.0000000 |          0.0000000 |              0.0000000 |     13 |

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
| mcdb        | FALSE      |           0.5506849 |               0.2136986 |                  0 |              0.4438356 |    365 |
| misc\_abund | FALSE      |           0.6627566 |               0.4398827 |                  0 |              0.1847507 |    341 |

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
