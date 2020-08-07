Figures and results for main manuscript
================

# Final dataset in S and N space

![](manuscript_main_files/figure-gfm/final%20dataset%20s%20and%20n%20space-1.png)<!-- -->

# Illustrations of 95% interval

To show the 95% interval, we need to load the distribution of shape
metric values from the samples from the feasible set for a few
communities.

# Skewness and evenness histograms by dataset

![](manuscript_main_files/figure-gfm/first%20hists-1.png)<!-- -->![](manuscript_main_files/figure-gfm/first%20hists-2.png)<!-- -->

# Proportion of sites with highly skewed or uneven SADs

    ## `summarise()` ungrouping output (override with `.groups` argument)
    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## Joining, by = "dat"

<div class="kable-table">

| dat         | proportion\_skew\_high | nsites\_skew | proportion\_even\_low | nsites\_even |
| :---------- | ---------------------: | -----------: | --------------------: | -----------: |
| bbs         |              0.1301839 |         2773 |             0.2596466 |         2773 |
| fia         |              0.0488790 |        20295 |             0.0844543 |        20295 |
| gentry      |              0.1883408 |          223 |             0.1517857 |          224 |
| mcdb        |              0.1393443 |          610 |             0.2848752 |          681 |
| misc\_abund |              0.3165736 |          537 |             0.5347985 |          546 |

</div>

    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## Joining, by = "fia_yn"

<div class="kable-table">

| fia\_yn | proportion\_skew\_high | nsites\_skew | proportion\_even\_low | nsites\_even |
| :------ | ---------------------: | -----------: | --------------------: | -----------: |
| fia     |              0.0488790 |        20295 |             0.0844543 |        20295 |
| not fia |              0.1588221 |         4143 |             0.2935606 |         4224 |

</div>

    ## Warning: Removed 237 rows containing missing values (geom_point).

![](manuscript_main_files/figure-gfm/95%20intervals-1.png)<!-- -->

    ## Warning: Removed 160 rows containing missing values (geom_point).

![](manuscript_main_files/figure-gfm/95%20intervals-2.png)<!-- -->
