Self-similarity of the elements of the feasible set
================
Renata Diaz
2020-08-12

We are interested in how the self-similarity of the elements of the
feasible set varies over gradients in S and N. The intuition from
“common-sense” probability theory, statistical mechanics,
law-of-large-numbers intuition is that, as the number of possible
arrangements becomes large, the different possible arrangements should
become more self-similar. However, we don’t know that this is the case
for SADs, nor do we know the values for S and N where things really
start to converge.

In the manuscript, I use the ratio of the 95% interval of summary
statistic values, to the full range of summary statistic values. This
can be calculated quickly and without introducing new statistics, etc to
the main manuscript. It also directly reflects the distributions to
which we are comparing our observations. However, it may not tell the
full story: if the summary statistic values are idiosyncratic (skewness
in particular can behave counterintuitively), it reflects those
idiosyncracies.

With more computing, we can explore how similar the elements of the
feasible set are to each other by comparing them to each other directly.
Then we can ask whether, as the feasible set gets large, the elements
become more similar and converge on a dominant form.

I initially did this analysis in
<https://github.com/diazrenata/sadspace> and am porting the functions
and analysis over to this repo for the supplement.

### Directly establishing self-similarity

#### Overview

We can describe how self-similar the elements of a feasible set are via
numerous pairwise comparisons. Given a body of samples drawn from a
feasible set, we draw two samples and compute some metric that describes
how similar these two samples are to each other. We do this many times,
making many pairwise comparisons, to generate a distribution of the
self-similarity metric for that feasible set. We then compare how
self-similar different feasible sets are by comparing the distributions
of self-similarity metrics for the different feasible sets.

#### Walkthrough

Here we have a bank of 3870 samples from the feasible set for SADs with
7 species and 71 individuals.

![](self_similarity_files/figure-gfm/illustrate%20self%20similarity-1.png)<!-- -->

We draw two of these samples to compare.

![](self_similarity_files/figure-gfm/draw%20two-1.png)<!-- -->

I have implemented 5 metrics of similarity for comparing samples:

  - R2
  - R2 on log-transformed abundances
  - The coefficient of determination from a linear model fitting one
    sample to the other
  - The proportion of individuals allocated to species of differing
    abundances
  - The estimated Kullbak-Lieber (sp) divergence between the two samples

<div class="kable-table">

| sim1 | sim2 |        r2 |   r2\_log |        cd | prop\_off |       div | s0 | n0 | nparts |
| ---: | ---: | --------: | --------: | --------: | --------: | --------: | -: | -: | :----- |
|  591 | 3208 | 0.7874279 | 0.7336329 | 0.8397613 | 0.1971831 | 0.1027579 |  7 | 71 | 60289  |

</div>

We repeat this comparison process numerous times to get numerous values
for the self-similarity metrics.

    ## [1] 100

![](self_similarity_files/figure-gfm/rep%20sampler-1.png)<!-- -->![](self_similarity_files/figure-gfm/rep%20sampler-2.png)<!-- -->![](self_similarity_files/figure-gfm/rep%20sampler-3.png)<!-- -->![](self_similarity_files/figure-gfm/rep%20sampler-4.png)<!-- -->![](self_similarity_files/figure-gfm/rep%20sampler-5.png)<!-- -->

We repeat this process for feasible sets with varying S and N, and
compare the distribution of the self-similarity metrics across the
variation in S and N.
