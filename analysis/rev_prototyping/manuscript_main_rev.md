Figures and results for main manuscript
================
Renata Diaz
2021-03-16

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

<!-- # Breadth index by dataset (Figure 3) -->

<!-- ```{r, fig.dim = c(7,7)} -->

<!-- fig_3 <- gridExtra::grid.arrange(grobs = list( -->

<!--   ggplot(filter(all_di, s0 > 2, nparts > 20), aes(x= skew_95_ratio_1t)) + -->

<!--     geom_histogram() + -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y", ncol = 1) + -->

<!--     xlab("") + -->

<!--     ylab("") + -->

<!--     ggtitle("Skewness") + -->

<!--     xlim(0, 1), -->

<!--   ggplot(filter(all_di, nparts > 20), aes(x = simpson_95_ratio_1t)) + -->

<!--     geom_histogram() + -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y", ncol = 1) + -->

<!--     xlab("") + -->

<!--     ylab("") + -->

<!--     ggtitle("Evenness") + -->

<!--     xlim(0, 1) -->

<!-- ), ncol = 2, -->

<!-- top = textGrob("Figure 3", gp = gpar(fill = "white")), -->

<!-- left = "Number of communities",  -->

<!-- bottom = "Breadth index (ranges 0-1, with 1 being very broad)") -->

<!-- plot(fig_3) -->

<!-- ``` -->

<!-- # Comparison of FIA and comparably sized communities (Figure 4) -->

<!-- ```{r, fig.dim = c(7,7)} -->

<!-- fia_max_s = max(filter(all_di, dat == "fia")$s0) -->

<!-- fia_max_n = max(filter(all_di, dat == "fia")$n0) -->

<!-- fia = filter(all_di, dat == "fia") -->

<!-- small_di <- all_di %>% -->

<!--   filter(s0 <= fia_max_s, -->

<!--          n0 <= fia_max_n) %>% -->

<!--   mutate(fia_yn = ifelse(dat == "fia", "fia", "other datasets"), -->

<!--          right_corner = FALSE) -->

<!-- for(i in 1:nrow(small_di)) { -->

<!--   if(small_di$dat[i] != "fia") { -->

<!--     fia_match_s0 = filter(fia, s0 >= small_di$s0[i]) -->

<!--     max_n0_for_this_s0 = max(fia_match_s0$n0) -->

<!--     small_di$right_corner[i] = small_di$n0[i] > max_n0_for_this_s0 -->

<!--   } -->

<!-- } -->

<!-- small_di <- small_di %>% -->

<!--   filter(!right_corner) -->

<!-- not_fia <- filter(small_di, fia_yn != "fia") -->

<!-- fia = filter(small_di, dat == "fia") -->

<!-- small_di_s_n <- small_di %>% -->

<!--   select(s0, n0) %>% -->

<!--   distinct() %>% -->

<!--   mutate(in_fia = FALSE, -->

<!--          in_not_fia = FALSE) -->

<!-- for(i in 1:nrow(small_di_s_n)) { -->

<!--   this_s0 = small_di_s_n$s0[i] -->

<!--   this_n0 = small_di_s_n$n0[i] -->

<!--   fia_matches = filter(fia, s0 == this_s0, n0 == this_n0) -->

<!--   not_fia_matches = filter(not_fia, s0 == this_s0, n0 == this_n0) -->

<!--   small_di_s_n$in_fia[i] = nrow(fia_matches) > 0  -->

<!--   small_di_s_n$in_not_fia[i] = nrow(not_fia_matches) > 0  -->

<!-- } -->

<!-- small_di_s_n <- filter(small_di_s_n, in_fia, in_not_fia) -->

<!-- set.seed(1977) -->

<!-- subsamples <- list() -->

<!-- for(i in 1:nrow(small_di_s_n)) { -->

<!--   this_s0 = small_di_s_n$s0[i] -->

<!--   this_n0 = small_di_s_n$n0[i] -->

<!--   fia_matches = filter(fia, s0 == this_s0, n0 == this_n0) -->

<!--   not_fia_matches = filter(not_fia, s0 == this_s0, n0 == this_n0) -->

<!--   n_to_draw = min(nrow(fia_matches), nrow(not_fia_matches)) -->

<!--   fia_draw = sample.int(n = nrow(fia_matches), size = n_to_draw, replace = F) -->

<!--   not_fia_draw = sample.int(n = nrow(not_fia_matches), size = n_to_draw, replace = F) -->

<!--   subsamples[[i]] <- (bind_rows(fia_matches[fia_draw,], not_fia_matches[not_fia_draw, ])) -->

<!-- } -->

<!-- sub_di <- bind_rows(subsamples) %>% -->

<!--   mutate(Dataset = ifelse(fia_yn == "fia", "FIA", "Other datasets")) -->

<!-- simpson_ks <- filter(sub_di, nparts > 40) %>% -->

<!--   select(simpson_95_ratio_1t, Dataset, simpson_percentile, s0, n0) %>%  -->

<!--   group_by(Dataset, s0, n0) %>% -->

<!--   mutate(pairing = dplyr::row_number()) %>% -->

<!--   ungroup() %>% -->

<!--   tidyr::pivot_wider(id_cols = c(s0, n0, pairing), names_from = Dataset, values_from = c(simpson_95_ratio_1t, simpson_percentile)) -->

<!-- simpson_breadth <- ks.test(simpson_ks$simpson_95_ratio_1t_FIA, simpson_ks$`simpson_95_ratio_1t_Other datasets`) -->

<!-- simpson_percent <- ks.test(simpson_ks$simpson_percentile_FIA, simpson_ks$`simpson_percentile_Other datasets`) -->

<!-- simpson_breadth -->

<!-- simpson_percent -->

<!-- skewness_ks <- filter(sub_di, nparts > 40) %>% -->

<!--   select(skew_95_ratio_1t, Dataset, skew_percentile, s0, n0) %>%  -->

<!--   group_by(Dataset, s0, n0) %>% -->

<!--   mutate(pairing = dplyr::row_number()) %>% -->

<!--   ungroup() %>% -->

<!--   tidyr::pivot_wider(id_cols = c(s0, n0, pairing), names_from = Dataset, values_from = c(skew_95_ratio_1t, skew_percentile)) -->

<!-- skewness_breadth <- ks.test(skewness_ks$skew_95_ratio_1t_FIA, skewness_ks$`skew_95_ratio_1t_Other datasets`) -->

<!-- skewness_percent <- ks.test(skewness_ks$skew_percentile_FIA, skewness_ks$`skew_percentile_Other datasets`) -->

<!-- skewness_breadth -->

<!-- skewness_percent -->

<!-- fig_4 <- gridExtra::grid.arrange(grobs = list( -->

<!--   ggplot(filter(sub_di, nparts > 20), aes(skew_95_ratio_1t)) + -->

<!--     geom_histogram()+ -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y")  + -->

<!--     xlab("Breadth index") + -->

<!--     ylab("Number of communities") + -->

<!--     ggtitle("Breadth index", subtitle = "Skewness"), -->

<!--   ggplot(filter(sub_di, nparts > 20), aes(simpson_95_ratio_1t)) + -->

<!--     geom_histogram()+ -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y")  + -->

<!--     xlab("Breadth index") + -->

<!--     ylab("") + -->

<!--     ggtitle("", subtitle = "Evenness"), -->

<!--   ggplot(filter(sub_di, nparts > 20), aes(skew_percentile_excl)) + -->

<!--     geom_histogram()+ -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y")  + -->

<!--     xlab("Percentile rank") + -->

<!--     ylab("Number of communities") + -->

<!--     ggtitle("Percentile rank", subtitle = "Skewness"), -->

<!--   ggplot(filter(sub_di, nparts > 20), aes(simpson_percentile)) + -->

<!--     geom_histogram()+ -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y")  + -->

<!--     xlab("Percentile rank") + -->

<!--     ylab("")+ -->

<!--     ggtitle("", subtitle = "Evenness")), ncol = 2, top = textGrob("Figure 4", gp = gpar(fill = "white"))) -->

<!-- plot(fig_4) -->

<!-- ``` -->

<!-- ```{r} -->

<!-- pdf("figure_1.pdf", title = "Figure 1", bg = "white", paper = "letter", width = 6.5, height = 6.5) -->

<!-- gridExtra::grid.arrange(grobs = breadth_plots, ncol = 2, top = textGrob("Figure 1", gp = gpar(fill = "white"))) -->

<!-- dev.off() -->

<!-- pdf("figure_2.pdf", title = "Figure 2", bg = "white", paper = "letter", width = 6.5, height = 6.5) -->

<!--  gridExtra::grid.arrange(grobs = list( -->

<!--   ggplot(filter(all_di, s0 > 2, nparts > 20), aes(skew_percentile_excl)) + -->

<!--     geom_histogram(bins = 100) + -->

<!--     geom_vline(xintercept = 95, color = "red") + -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y", ncol = 1) + ggtitle("Skewness") + -->

<!--     xlab("") + -->

<!--     ylab(""),# + -->

<!--   #  xlab("Percentile rank of observed value relative to feasible set") + -->

<!--     #ylab("Number of communities") , -->

<!--   ggplot(filter(all_di, nparts > 20), aes(simpson_percentile)) +  -->

<!--     geom_histogram(bins = 100) + -->

<!--     geom_vline(xintercept = 5, color = "red") + -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y", ncol = 1) + ggtitle("Evenness") +  -->

<!--     xlab("") + -->

<!--     ylab("")#+ -->

<!--     #xlab("Percentile rank of observed value relative to feasible set") + -->

<!--   #  ylab("Number of communities") -->

<!-- ), ncol = 2, -->

<!-- top = textGrob("Figure 2", gp = gpar(fill = "white")), left = textGrob("Number of communities", rot = 90, gp = gpar(fill = "black")), -->

<!-- bottom = textGrob("Percentile rank of observed value relative to feasible set"), gp = gpar(fill = "white")) -->

<!--  dev.off() -->

<!-- pdf("figure_3.pdf", title = "Figure 3", bg = "white", paper = "letter", width = 6.5, height = 6.5) -->

<!-- gridExtra::grid.arrange(grobs = list( -->

<!--   ggplot(filter(all_di, s0 > 2, nparts > 20), aes(x= skew_95_ratio_1t)) + -->

<!--     geom_histogram() + -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y", ncol = 1) + -->

<!--     xlab("") + -->

<!--     ylab("") + -->

<!--     ggtitle("Skewness") + -->

<!--     xlim(0, 1), -->

<!--   ggplot(filter(all_di, nparts > 20), aes(x = simpson_95_ratio_1t)) + -->

<!--     geom_histogram() + -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y", ncol = 1) + -->

<!--     xlab("") + -->

<!--     ylab("") + -->

<!--     ggtitle("Evenness") + -->

<!--     xlim(0, 1) -->

<!-- ), ncol = 2, -->

<!-- top = textGrob("Figure 3", gp = gpar(fill = "white")), -->

<!-- left = "Number of communities",  -->

<!-- bottom = "Breadth index (ranges 0-1, with 1 being very broad)") -->

<!-- dev.off() -->

<!-- pdf("figure_4.pdf", title = "Figure 4", bg = "white", paper = "letter", width = 6.5, height = 6.5) -->

<!--  gridExtra::grid.arrange(grobs = list( -->

<!--   ggplot(filter(sub_di, nparts > 20), aes(skew_95_ratio_1t)) + -->

<!--     geom_histogram()+ -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y")  + -->

<!--     xlab("Breadth index") + -->

<!--     ylab("Number of communities") + -->

<!--     ggtitle("Breadth index", subtitle = "Skewness"), -->

<!--   ggplot(filter(sub_di, nparts > 20), aes(simpson_95_ratio_1t)) + -->

<!--     geom_histogram()+ -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y")  + -->

<!--     xlab("Breadth index") + -->

<!--     ylab("") + -->

<!--     ggtitle("", subtitle = "Evenness"), -->

<!--   ggplot(filter(sub_di, nparts > 20), aes(skew_percentile_excl)) + -->

<!--     geom_histogram()+ -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y")  + -->

<!--     xlab("Percentile rank") + -->

<!--     ylab("Number of communities") + -->

<!--     ggtitle("Percentile rank", subtitle = "Skewness"), -->

<!--   ggplot(filter(sub_di, nparts > 20), aes(simpson_percentile)) + -->

<!--     geom_histogram()+ -->

<!--     theme_bw() + -->

<!--     facet_wrap(vars(Dataset), scales = "free_y")  + -->

<!--     xlab("Percentile rank") + -->

<!--     ylab("")+ -->

<!--     ggtitle("", subtitle = "Evenness")), ncol = 2, top = textGrob("Figure 4", gp = gpar(fill = "white"))) -->

<!-- dev.off() -->

<!-- ``` -->
