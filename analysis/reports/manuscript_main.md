Figures and results for main manuscript
================

# Final dataset in S and N space

![](manuscript_main_files/figure-gfm/final%20dataset%20s%20and%20n%20space-1.png)<!-- -->

# Illustrations of 95% interval

To show the 95% interval, we need to load the distribution of shape
metric values from the samples from the feasible set for a few
communities.

# Skewness and evenness histograms by dataset

![](manuscript_main_files/figure-gfm/first%20hists-1.png)<!-- -->![](manuscript_main_files/figure-gfm/first%20hists-2.png)<!-- -->![](manuscript_main_files/figure-gfm/first%20hists-3.png)<!-- -->![](manuscript_main_files/figure-gfm/first%20hists-4.png)<!-- -->

# Proportion of sites with highly skewed or uneven SADs

    ## `summarise()` ungrouping output (override with `.groups` argument)
    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## Joining, by = "dat"

<div class="kable-table">

| dat         | proportion\_skew\_high | nsites\_skew | proportion\_even\_low | nsites\_even |
| :---------- | ---------------------: | -----------: | --------------------: | -----------: |
| bbs         |              0.1301839 |         2773 |             0.2596466 |         2773 |
| fia         |              0.0694752 |        20295 |             0.0844543 |        20295 |
| gentry      |              0.1883408 |          223 |             0.1517857 |          224 |
| mcdb        |              0.1672131 |          610 |             0.2713287 |          715 |
| misc\_abund |              0.3389199 |          537 |             0.5270758 |          554 |

</div>

    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## Joining, by = "dat"

<div class="kable-table">

| dat         | proportion\_skew\_high | nsites\_skew | proportion\_even\_low | nsites\_even |
| :---------- | ---------------------: | -----------: | --------------------: | -----------: |
| bbs         |              0.1301839 |         2773 |             0.2596466 |         2773 |
| fia         |              0.0631523 |        16959 |             0.0975883 |        16959 |
| gentry      |              0.1883408 |          223 |             0.1524664 |          223 |
| mcdb        |              0.1756487 |          501 |             0.3742574 |          505 |
| misc\_abund |              0.3526971 |          482 |             0.6033058 |          484 |

</div>

There are fewer sites for skewness because we exclude sites with only 2
species.

# Size of feasible set for each dataset

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](manuscript_main_files/figure-gfm/fs%20size%20hists-1.png)<!-- -->

    ## `summarise()` ungrouping output (override with `.groups` argument)

<div class="kable-table">

| dat         | prop\_smaller\_than\_5 | prop\_smaller\_than\_7 | prop\_smaller\_than\_10 |
| :---------- | ---------------------: | ---------------------: | ----------------------: |
| bbs         |              0.0000000 |              0.0003606 |               0.0007212 |
| fia         |              0.3012072 |              0.6217788 |               0.9243163 |
| gentry      |              0.0044643 |              0.0044643 |               0.0178571 |
| mcdb        |              0.3776224 |              0.4797203 |               0.6000000 |
| misc\_abund |              0.1407942 |              0.1660650 |               0.2184116 |

</div>

FIA is the only dataset that is overwhelmingly dominated by sites with
fewer than 2.202646610^{4} elements in the feasible set. MCDB also has
many small sites, but these are counterbalanced by larger ones.

62% of the FIA sites have fewer than 1096.6331584 elements in the
feasible set, and 30% have fewer than 148.4131591.

![](manuscript_main_files/figure-gfm/fs%20size%20to%20s0%20and%20n0-1.png)<!-- -->![](manuscript_main_files/figure-gfm/fs%20size%20to%20s0%20and%20n0-2.png)<!-- -->![](manuscript_main_files/figure-gfm/fs%20size%20to%20s0%20and%20n0-3.png)<!-- -->

Having fewer than 150 elements \~ fewer than 3 species, or fewer than
15.6426319 individuals with up to 20 species.

Fewer than 1000 elements \~ fewer than 3 species, or fewer than
25.7903399 individuals with up to 20 species.

Fewer than 20000 elements \~ fewer than 4 species, or fewer than
54.59815 individuals.

# 95% interval for small versus large communities

    ## Warning: Removed 249 rows containing missing values (geom_point).

![](manuscript_main_files/figure-gfm/95%20interval-1.png)<!-- -->

    ## Warning: Removed 3795 rows containing missing values (geom_point).

![](manuscript_main_files/figure-gfm/95%20interval-2.png)<!-- -->

    ## Warning: Removed 172 rows containing missing values (geom_point).

![](manuscript_main_files/figure-gfm/95%20interval-3.png)<!-- -->

    ## Warning: Removed 3718 rows containing missing values (geom_point).

![](manuscript_main_files/figure-gfm/95%20interval-4.png)<!-- -->

The 95% ratio decreases for large FS.

For skewness, it is still quite high even up to 20,000 elements in the
FS. But it is starting to decline by then?

# Comparison of FIA to similarly-sized communities

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](manuscript_main_files/figure-gfm/fia%20sized-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](manuscript_main_files/figure-gfm/fia%20sized-2.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](manuscript_main_files/figure-gfm/fia%20sized-3.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](manuscript_main_files/figure-gfm/fia%20sized-4.png)<!-- -->

    ## `summarise()` ungrouping output (override with `.groups` argument)

<div class="kable-table">

| fia\_yn        | prop\_skew\_high | nsites |
| :------------- | ---------------: | -----: |
| FIA            |        0.0694752 |  20295 |
| Other datasets |        0.1314985 |    654 |

</div>

    ## `summarise()` ungrouping output (override with `.groups` argument)

<div class="kable-table">

| fia\_yn        | prop\_skew\_high | nsites |
| :------------- | ---------------: | -----: |
| FIA            |        0.0631523 |  16959 |
| Other datasets |        0.1224490 |    490 |

</div>

    ## `summarise()` ungrouping output (override with `.groups` argument)

<div class="kable-table">

| fia\_yn        | prop\_even\_low | nsites |
| :------------- | --------------: | -----: |
| FIA            |       0.0844543 |  20295 |
| Other datasets |       0.1718346 |    774 |

</div>

    ## `summarise()` ungrouping output (override with `.groups` argument)

<div class="kable-table">

| fia\_yn        | prop\_even\_low | nsites |
| :------------- | --------------: | -----: |
| FIA            |       0.0975883 |  16959 |
| Other datasets |       0.2591837 |    490 |

</div>

# Removing the smallest communities from FIA

![](manuscript_main_files/figure-gfm/fia%20no%20small-1.png)<!-- -->![](manuscript_main_files/figure-gfm/fia%20no%20small-2.png)<!-- -->![](manuscript_main_files/figure-gfm/fia%20no%20small-3.png)<!-- -->![](manuscript_main_files/figure-gfm/fia%20no%20small-4.png)<!-- -->![](manuscript_main_files/figure-gfm/fia%20no%20small-5.png)<!-- -->![](manuscript_main_files/figure-gfm/fia%20no%20small-6.png)<!-- -->
