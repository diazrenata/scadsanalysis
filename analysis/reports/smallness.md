Size class small comparisons
================
Renata Diaz
2020-08-05

##### Results for small (FIA sized) communities

Here are the results when we try to tell whether FIA communities differ
qualitatively from similarly-sized communities from other datasets…

###### Small sites

Note that, even for small sites, “other datasets” are generally larger
than FIA….

![](smallness_files/figure-gfm/small-1.png)<!-- -->![](smallness_files/figure-gfm/small-2.png)<!-- -->

###### Skew for small sites

![](smallness_files/figure-gfm/skewness%20small-1.png)<!-- -->![](smallness_files/figure-gfm/skewness%20small-2.png)<!-- -->

    ## `summarise()` ungrouping output (override with `.groups` argument)

<div class="kable-table">

| fia\_yn        | prop\_skew\_high\_ltet | prop\_skew\_high\_lt | n\_skew\_sites |
| :------------- | ---------------------: | -------------------: | -------------: |
| fia            |              0.0694752 |             0.048879 |          20295 |
| other datasets |              0.1314387 |             0.079929 |            563 |

</div>

###### Evenness

![](smallness_files/figure-gfm/evenness%20result%20small-1.png)<!-- -->![](smallness_files/figure-gfm/evenness%20result%20small-2.png)<!-- -->

    ## `summarise()` ungrouping output (override with `.groups` argument)

<div class="kable-table">

| fia\_yn        | prop\_even\_low\_ltet | prop\_even\_low\_lt | n\_even\_sites |
| :------------- | --------------------: | ------------------: | -------------: |
| fia            |             0.0844543 |           0.1113575 |          20295 |
| other datasets |             0.1493411 |           0.3045388 |            683 |

</div>

For these comparisons, - For skewness, the effect is weak for both FIA
and not-FIA (5% and 8% in the extremes, respectively) - For evenness,
the effect is much stronger for not-FIA (8 vs 15%) - \< vs \<= matters
quite a bit - Many of these sites can be quite small. Since we flagged a
concern about having fewer than, arbitrarily, 100 elements, let’s remove
those:

###### Skew for small sites, removing very small

![](smallness_files/figure-gfm/skewness%20small%20no%20tiny-1.png)<!-- -->![](smallness_files/figure-gfm/skewness%20small%20no%20tiny-2.png)<!-- -->

    ## `summarise()` ungrouping output (override with `.groups` argument)

<div class="kable-table">

| fia\_yn        | prop\_skew\_high\_ltet | prop\_skew\_high\_lt | n\_skew\_sites |
| :------------- | ---------------------: | -------------------: | -------------: |
| fia            |              0.0662983 |            0.0636017 |          15204 |
| other datasets |              0.1277174 |            0.1222826 |            368 |

</div>

###### Evenness

![](smallness_files/figure-gfm/evenness%20result%20small%20no%20tiny-1.png)<!-- -->![](smallness_files/figure-gfm/evenness%20result%20small%20no%20tiny-2.png)<!-- -->

    ## `summarise()` ungrouping output (override with `.groups` argument)

<div class="kable-table">

| fia\_yn        | prop\_even\_low\_ltet | prop\_even\_low\_lt | n\_even\_sites |
| :------------- | --------------------: | ------------------: | -------------: |
| fia            |              0.101618 |           0.1051697 |          15204 |
| other datasets |              0.250000 |           0.2527174 |            368 |

</div>

Removing sites with fewer than 100 elements in the feasible set

  - *eliminates the difference between \<= and \<*
  - We see a difference between FIA and other datasets
      - For skew, 6 vs 12% in the extremes
      - For even, 10 vs 25% in the extremes

I am skeptical of these comparisons. It may be that FIA is behaving
qualitatively differently, but it may also be that, because the other
datasets are less concentrated at *very small* FS, the effect of FS size
still drives the difference even when we filter like this. On the
strength of this filtering I’m not confident arguing *either* that FIA
is qualitatively different, independent of size, or that these subsets
are behaving the same.

I think a stronger comparison would be to break into size classes based
on the number of parts.
