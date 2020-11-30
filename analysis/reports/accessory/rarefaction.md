Effects of rarefaction
================
Renata Diaz
2020-08-12

It is often not possible to exhaustively sample all the species and
individuals present in a real system. Therefore empirical observations
of SADs may be missing species and individuals that are part of the true
distribution.

We explored whether our results change if we adjust for for the species
and individuals that might be missed via sampling. We used species
richness estimators to estimate the true number of species for a
community given the observed SAD, and re-ran our analytical pipeline on
SADs adjusted to match the estimated richness.

### Adjusting for rarefaction

For an observed SAD, we take the estimated species richness from the
bias-corrected Chao and ACE estimators (as implemented in
`vegan::estimateR`) as the estimated “true” number of species in the
community. To err on the side of overestimating the number of species
missed via sampling, we used the estimated mean + 1 standard deviation
as the estimate for each estimator. We take the mean of these two
estimates, rounded up to the next integer, as the estimated true
richness for that community. We adjusted the raw SAD to match this
estimated richness by adding the appropriate number of species with an
abundance of 1 individual each. We reason that species that are missed
during sampling are likely to be rare, so adding them as rare species is
appropriate. This also allows us to explore the effects of rarefaction
while making the smallest possible changes to S and N.

![](rarefaction_files/figure-gfm/show%20an%20observed%20vector%20and%20adjusted%20for%20singletons-1.png)<!-- -->

The green points are the species we added to match the estimated species
richness for the raw SAD (purple points).

### Adjusted vs. raw results

![](rarefaction_files/figure-gfm/skew-1.png)<!-- -->![](rarefaction_files/figure-gfm/skew-2.png)<!-- -->

<div class="kable-table">

| dat         | proportion\_skew\_high\_raw | proportion\_skew\_high\_adjusted | nsites\_skew |
| :---------- | --------------------------: | -------------------------------: | -----------: |
| bbs         |                   0.1301839 |                        0.1402813 |         2773 |
| fia         |                   0.0542106 |                        0.0950872 |        18299 |
| gentry      |                   0.1883408 |                        0.1883408 |          223 |
| mcdb        |                   0.1582868 |                        0.2532588 |          537 |
| misc\_abund |                   0.3455285 |                        0.4024390 |          492 |

</div>

![](rarefaction_files/figure-gfm/skew-3.png)<!-- -->![](rarefaction_files/figure-gfm/skew-4.png)<!-- -->

<div class="kable-table">

| dat         | proportion\_simpson\_low\_raw | proportion\_simpson\_low\_adjusted | nsites\_simpson |
| :---------- | ----------------------------: | ---------------------------------: | --------------: |
| bbs         |                     0.2596466 |                          0.3220339 |            2773 |
| fia         |                     0.0939657 |                          0.1596643 |           18113 |
| gentry      |                     0.1517857 |                          0.1875000 |             224 |
| mcdb        |                     0.3542435 |                          0.5092251 |             542 |
| misc\_abund |                     0.5959184 |                          0.6653061 |             490 |

</div>

In all cases, adjusting for rarefaction increases the proportion of
extreme values. Most adjusted SADs have more extreme values than their
non-adjusted counterparts.

This makes sense given that we add species at low abundance (and are
more likely to fail to observe rare species). Adding rare species would
tend to increase skewness and decrease evenness.

If anything, missing species due to the limitations on empirical
sampling causes us to **underestimate** the extreme-ness of observed
SADs relative to their feasible sets.
