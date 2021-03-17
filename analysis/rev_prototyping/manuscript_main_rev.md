Figures and results for main manuscript
================
Renata Diaz
2021-03-17

  - [Datasets by S and N (Figure 1)](#datasets-by-s-and-n-figure-1)
  - [Illustrations of 95% interval (Figure
    2)](#illustrations-of-95-interval-figure-2)
  - [Dissimilarity (Supplement)](#dissimilarity-supplement)
  - [Metric histograms by dataset (Figure
    4)](#metric-histograms-by-dataset-figure-4)
  - [Results table](#results-table)
  - [Narrowness](#narrowness)
  - [Gentry](#gentry)
  - [Comparison of FIA and comparably sized communities (Figure
    4)](#comparison-of-fia-and-comparably-sized-communities-figure-4)

# Datasets by S and N (Figure 1)

![](manuscript_main_rev_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

# Illustrations of 95% interval (Figure 2)

To show the 95% interval, we need to load the distribution of shape
metric values from the samples from the feasible set for a few
communities. See rov\_metric.md.

<!-- ```{r, fig.dim = c(7,7)} -->

<!-- library(drake) -->

<!-- db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-net.sqlite")) -->

<!-- cache <- storr::storr_dbi("datatable", "keystable", db) -->

<!-- cache$del(key = "lock", namespace = "session") -->

<!-- net_summary <- readd(all_di_summary, cache = cache) -->

<!-- net_summary <- net_summary %>% -->

<!--   mutate(log_nparts = log(gmp:::as.double.bigz(nparts))) -->

<!-- example_fs <- readd(fs_s_44_n_13360, cache = cache) -->

<!-- example_di <- readd(di_fs_s_44_n_13360, cache =cache) -->

<!-- example_fs <- example_fs %>% -->

<!--   left_join(example_di) %>% -->

<!--   left_join(net_summary) -->

<!-- example_fs2 <- readd(fs_s_13_n_315, cache = cache) -->

<!-- example_di2 <- readd(di_fs_s_13_n_315, cache =cache) -->

<!-- example_fs2 <- example_fs2 %>% -->

<!--   left_join(example_di2) %>% -->

<!--   left_join(net_summary) -->

<!-- example_fs3 <- readd(fs_s_4_n_34, cache = cache) -->

<!-- example_di3 <- readd(di_fs_s_4_n_34, cache =cache) -->

<!-- example_fs3 <- example_fs3 %>% -->

<!--   left_join(example_di3) %>% -->

<!--   left_join(net_summary) -->

<!-- breadth_plots <- list( -->

<!--   ggplot(example_fs3, aes(rank, abund, group = sim, color = skew)) + -->

<!--     geom_line(alpha = .25) + -->

<!--     theme_bw() + -->

<!--     scale_color_viridis_c(option = "plasma", end = .8) + -->

<!--     ggtitle("Small community", subtitle = paste0("S = ", (example_fs3$s0), "; N = ", (example_fs3$n0[1]))) + -->

<!--     theme(legend.position = "right") + -->

<!--     xlab("Rank") + -->

<!--     ylab("Abundance"), -->

<!--   ggplot(example_fs3, aes(skew)) + -->

<!--   #  geom_density() + -->

<!--     geom_histogram(bins = 50) + -->

<!--     theme_bw() + -->

<!--     geom_vline(xintercept = c(example_fs3$skew_97p5[1], example_fs3$skew_2p5[1]), color = "red") + -->

<!--     ggtitle("", subtitle = paste0("Breadth index: ", round((example_fs3$skew_95_ratio_2t[1]), 2))) + -->

<!--     xlab("Skewness") + -->

<!--     ylab("Count"), -->

<!--   ggplot(example_fs2, aes(rank, abund, group = sim, color = skew)) + -->

<!--     geom_line(alpha = .1) + -->

<!--     theme_bw() + -->

<!--     scale_color_viridis_c(option = "plasma", end = .8) + -->

<!--     ggtitle("Medium community", subtitle = paste0("S = ", (example_fs2$s0), "; N = ", (example_fs2$n0[1]))) + -->

<!--     theme(legend.position = "right")+ -->

<!--     xlab("Rank") + -->

<!--     ylab("Abundance") + -->

<!--     ylim(0, 200), # Remove 3 sads that make the axes too big to be interpretable -->

<!--   ggplot(example_fs2, aes(skew)) + -->

<!--   #  geom_density() + -->

<!--     geom_histogram(bins = 50) + -->

<!--     theme_bw() + -->

<!--     geom_vline(xintercept = c(example_fs2$skew_97p5[1], example_fs2$skew_2p5[1]), color = "red") + -->

<!--     ggtitle("", subtitle =  paste0("Breadth index: ", round((example_fs2$skew_95_ratio_1t[1]), 2)))+ -->

<!--     xlab("Skewness") + -->

<!--     ylab("Count"), -->

<!--   ggplot(example_fs, aes(rank, abund, group = sim, color = skew)) + -->

<!--     geom_line(alpha = .1) + -->

<!--     theme_bw() + -->

<!--     scale_color_viridis_c(option = "plasma", end = .8) + -->

<!--     ggtitle("Large community", subtitle = paste0("S = ", (example_fs$s0), "; N = ", (example_fs$n0[1]))) + -->

<!--     theme(legend.position = "right") + -->

<!--     ylim(0, 4000) + # Remove a very few very very uneven SADs that make the scale too big to be interpretable -->

<!--     theme(axis.text.y = element_text(size = 6, angle = 60))+ -->

<!--     xlab("Rank") + -->

<!--     ylab("Abundance"), -->

<!--   ggplot(example_fs, aes(skew)) + -->

<!--    # geom_density() + -->

<!--     geom_histogram(bins = 50) + -->

<!--     theme_bw() + -->

<!--     geom_vline(xintercept = c(example_fs$skew_97p5[1], example_fs$skew_2p5[1]), color = "red") + -->

<!--     ggtitle("", subtitle =  paste0("Breadth index: ", round((example_fs$skew_95_ratio_1t[1]), 2)))+ -->

<!--     xlab("Skewness") + -->

<!--     ylab("Count") -->

<!-- ) -->

<!-- fig_1 <- gridExtra::grid.arrange(grobs = breadth_plots, ncol = 2, top = textGrob("Figure 1", gp = gpar(fill = "white"))) -->

<!-- plot(fig_1) -->

<!-- DBI::dbDisconnect(db) -->

<!-- rm(cache) -->

<!-- rm(db) -->

<!-- ``` -->

# Dissimilarity (Supplement)

![](manuscript_main_rev_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

# Metric histograms by dataset (Figure 4)

![](manuscript_main_rev_files/figure-gfm/first%20hists-1.png)<!-- -->

# Results table

    ## Joining, by = "Dataset"
    ## Joining, by = "Dataset"

    ## Note: Using an external vector in selections is ambiguous.
    ## ℹ Use `all_of(cols1)` instead of `cols1` to silence this message.
    ## ℹ See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
    ## This message is displayed once per session.

<div class="kable-table">

| Dataset              | High dissimilarity | High proportion of rare species | High skew       | Low Simpson     | Low Shannon     |
| :------------------- | :----------------- | :------------------------------ | :-------------- | :-------------- | :-------------- |
| Breeding Bird Survey | 23%; n = 2773      | 4.5%; n = 2773                  | 9%; n = 2773    | 21%; n = 2773   | 23%; n = 2773   |
| FIA                  | 7.2%; n = 18447    | 1.4%; n = 17410                 | 2.8%; n = 17410 | 5.8%; n = 17410 | 5.5%; n = 17410 |
| Gentry               | 34%; n = 224       | 0.9%; n = 223                   | 11%; n = 223    | 9.9%; n = 223   | 7.6%; n = 223   |
| Mammal Communities   | 32%; n = 552       | 13%; n = 511                    | 12%; n = 505    | 28%; n = 511    | 30%; n = 511    |
| Misc. Abundance      | 59%; n = 494       | 27%; n = 486                    | 27%; n = 484    | 53%; n = 486    | 56%; n = 486    |

</div>

    ## Note: Using an external vector in selections is ambiguous.
    ## ℹ Use `all_of(cols2)` instead of `cols2` to silence this message.
    ## ℹ See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
    ## This message is displayed once per session.

<div class="kable-table">

| Dataset              | Low proportion of rare species | Low skew         | High Simpson      | High Shannon      |
| :------------------- | :----------------------------- | :--------------- | :---------------- | :---------------- |
| Breeding Bird Survey | 0%; n = 2773                   | 1.1%; n = 2773   | 0.61%; n = 2773   | 0.36%; n = 2773   |
| FIA                  | 0%; n = 17410                  | 0.28%; n = 17410 | 0.063%; n = 17410 | 0.086%; n = 17410 |
| Gentry               | 20%; n = 223                   | 8.5%; n = 223    | 22%; n = 223      | 25%; n = 223      |
| Mammal Communities   | 0%; n = 511                    | 0.79%; n = 505   | 0.59%; n = 511    | 0.39%; n = 511    |
| Misc. Abundance      | 0%; n = 486                    | 0.21%; n = 484   | 0.21%; n = 486    | 0.21%; n = 486    |

</div>

# Narrowness

    ## Warning: Removed 8 rows containing missing values (geom_point).

![](manuscript_main_rev_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

![](manuscript_main_rev_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

# Gentry

![](manuscript_main_rev_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

# Comparison of FIA and comparably sized communities (Figure 4)

    ## Warning in ks.test(fia_df[[compare_var]], other_df[[compare_var]]): p-value will
    ## be approximate in the presence of ties
    
    ## Warning in ks.test(fia_df[[compare_var]], other_df[[compare_var]]): p-value will
    ## be approximate in the presence of ties
    
    ## Warning in ks.test(fia_df[[compare_var]], other_df[[compare_var]]): p-value will
    ## be approximate in the presence of ties
    
    ## Warning in ks.test(fia_df[[compare_var]], other_df[[compare_var]]): p-value will
    ## be approximate in the presence of ties
    
    ## Warning in ks.test(fia_df[[compare_var]], other_df[[compare_var]]): p-value will
    ## be approximate in the presence of ties

<div class="kable-table">

|     | var                        |         d |         p |
| :-- | :------------------------- | --------: | --------: |
| D…1 | simpson\_95\_ratio\_2t     | 0.0393939 | 0.9599607 |
| D…2 | skew\_95\_ratio\_2t        | 0.0000000 | 1.0000000 |
| D…3 | shannon\_95\_ratio\_2t     | 0.0424242 | 0.9277987 |
| D…4 | nsingletons\_95\_ratio\_2t | 0.0333333 | 0.9930019 |
| D…5 | sim\_pos\_from\_best       | 0.0268097 | 0.9993106 |

</div>

    ## Warning in ks.test(fia_df[[compare_var]], other_df[[compare_var]]): p-value will
    ## be approximate in the presence of ties
    
    ## Warning in ks.test(fia_df[[compare_var]], other_df[[compare_var]]): p-value will
    ## be approximate in the presence of ties
    
    ## Warning in ks.test(fia_df[[compare_var]], other_df[[compare_var]]): p-value will
    ## be approximate in the presence of ties
    
    ## Warning in ks.test(fia_df[[compare_var]], other_df[[compare_var]]): p-value will
    ## be approximate in the presence of ties
    
    ## Warning in ks.test(fia_df[[compare_var]], other_df[[compare_var]]): p-value will
    ## be approximate in the presence of ties

<div class="kable-table">

|     | var                           |         d |         p |
| :-- | :---------------------------- | --------: | --------: |
| D…1 | simpson\_percentile           | 0.0575758 | 0.6447379 |
| D…2 | skew\_percentile\_excl        | 0.0000000 | 1.0000000 |
| D…3 | shannon\_percentile           | 0.0606061 | 0.5794869 |
| D…4 | nsingletons\_percentile\_excl | 0.0363636 | 0.9812077 |
| D…5 | real\_po\_percentile\_excl    | 0.0424242 | 0.9277987 |

</div>

![](manuscript_main_rev_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->![](manuscript_main_rev_files/figure-gfm/unnamed-chunk-10-2.png)<!-- -->

    ## Joining, by = "Dataset"
    ## Joining, by = "Dataset"

<div class="kable-table">

| Dataset        | High dissimilarity | High proportion of rare species | High skew     | Low Simpson  | Low Shannon  |
| :------------- | :----------------- | :------------------------------ | :------------ | :----------- | :----------- |
| FIA            | 17%; n = 373       | 4.8%; n = 330                   | 7%; n = 330   | 15%; n = 330 | 16%; n = 330 |
| Other datasets | 17%; n = 373       | 6.1%; n = 330                   | 6.4%; n = 330 | 15%; n = 330 | 15%; n = 330 |

</div>
