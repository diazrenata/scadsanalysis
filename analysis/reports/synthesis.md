Synthesis report
================

Datasets in S and N space
=========================

Here is where our communities fall in S and N space:

![](synthesis_files/figure-markdown_github/datasets%20in%20s%20and%20n%20space-1.png)

Here is how that translates into the size of the feasible set:

![](synthesis_files/figure-markdown_github/size%20of%20fs-1.png)

Note that the color scale is log transformed, so the largest communities have e^331.5401042, or 9.683621310^{143}, elements in the feasible set!

Here is how the size of the feasible set maps on to N/S. It increases with n0/s0 and s0.

![](synthesis_files/figure-markdown_github/nparts%20vs%20avgn-1.png)

Number of samples
=================

Here is how many samples we are achieving:

![](synthesis_files/figure-markdown_github/nsamples-1.png)

Only in small communities do we get appreciably fewer than 4000 samples.

Here is how the number of samples we're getting compares to the size of the feasible set:

![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-1.png)![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-2.png)![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-3.png)![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-4.png)

For about 44.4840146% of sites, we found all the elements of the FS. The *vast majority* of this is FIA - here is what happens if we take out FIA:

![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-1.png)![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-2.png)![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-3.png)![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-4.png)

Without FIA, we find all the samples about 48.5057471% of the time.

Distribution of percentile values
=================================

Skewness
--------

Here is the overall distribution of skewness, and if we split based on whether we found all the samples: ![](synthesis_files/figure-markdown_github/skew%20percentiles-1.png)![](synthesis_files/figure-markdown_github/skew%20percentiles-2.png)

When we found all the samples, the percentiles are more evenly distributed. I do not read much into the spike at 0 for those communities, because skewness is bizarre for very small communities.

Here is how skewness maps with S and N: ![](synthesis_files/figure-markdown_github/skew%20v%20s%20and%20n-1.png)

The very low skewness values are down in the very small and very weird communities. There may be variation along S and N elsewhere, but it is hard to parse.

Simpson
-------

Here is the overall evenness distribution, and split by whether we found 'em all:

![](synthesis_files/figure-markdown_github/simpson%20percentiles-1.png)![](synthesis_files/figure-markdown_github/simpson%20percentiles-2.png)

Simpson is less evenly distributed than skewness. Again, where we found them all, we don't see the disproportionately common low percentile values.

Here is how Simpson behaves in S and N space:

![](synthesis_files/figure-markdown_github/even%20v%20s%20and%20n-1.png)

There is unusual behavior where S is large and N/S is relatively small (log N/S &lt;= 1.5), where evenness is unusually *high*.

For both skew and evenness, we do not see non-extreme percentile values in large communities:

![](synthesis_files/figure-markdown_github/non%20extremes-1.png)![](synthesis_files/figure-markdown_github/non%20extremes-2.png)

Singletons
----------

Here is how singletons change percentiles, broken out by whether or not we found all the samples:

![](synthesis_files/figure-markdown_github/singletons%20overall-1.png)![](synthesis_files/figure-markdown_github/singletons%20overall-2.png)

The rarefaction-inflated datasets are strongly // the raw vectors. They have more extreme skewness and evenness values, relative to their feasible sets, than the raw vectors. This is almost always true for evenness, with a little more noise in the skewness signal. But either way, very strong.

<!-- # Manipulations -->
<!-- # MACD -->
<!-- ```{r load macd, include =F} -->
<!-- cache_loc = "macdb" -->
<!-- ## Set up the cache and config -->
<!-- db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", paste0("drake-cache-", cache_loc, ".sqlite"))) -->
<!-- cache <- storr::storr_dbi("datatable", "keystable", db) -->
<!-- all_di_macd <- readd(all_di_obs, cache = cache)  -->
<!-- all_di_macd_manip <- readd(all_di_manip, cache = cache) -->
<!-- macd_dat <- readd(dat_s_dat_macdb, cache = cache) -->
<!-- DBI::dbDisconnect(db) -->
<!-- rm(cache) -->
<!-- all_di_macd <- all_di_macd %>% -->
<!--   mutate(log_nparts = log(gmp:::as.double.bigz(nparts)), -->
<!--          log_nsamples = log(nsamples)) %>% -->
<!--   mutate(prop_found = exp(log_nsamples - log_nparts)) %>% -->
<!--   mutate(found_all = prop_found==1) -->
<!-- #  -->
<!-- # all_di_macd_manip <- all_di_macd_manip %>% -->
<!-- #   mutate(log_nparts = log(gmp:::as.double.bigz(nparts)), -->
<!-- #          log_nsamples = log(nsamples)) %>% -->
<!-- #   mutate(prop_found = exp(log_nsamples - log_nparts)) %>% -->
<!-- #   mutate(found_all = prop_found==1) -->
<!-- ggplot(data = all_di, aes(x = log(s0), y = log(n0))) + geom_point(alpha = .1) + geom_point(data = all_di_macd, aes(x = log(s0), y = log(n0)), color = "blue", alpha = .9) + theme_bw() -->
<!-- ggplot(data = filter(all_di, !singletons), aes(x = log(s0), y = log(n0))) + geom_point(alpha = .1) + geom_point(data = filter(all_di_macd, !singletons), aes(x = log(s0), y = log(n0)), color = "blue", alpha = .9) + theme_bw() -->
<!-- ``` -->
<!-- Here are the distributions of skew and evenness, overall. -->
<!-- ```{r macd overall, include =F} -->
<!-- ggplot(data = all_di_macd, aes(x = skew_percentile)) + -->
<!--   geom_histogram(bins = 100) + -->
<!--   theme_bw() + -->
<!--   facet_wrap(vars(found_all), scales = "free_y") -->
<!-- ggplot(data = all_di_macd, aes(x = simpson_percentile)) + -->
<!--   geom_histogram(bins = 100) + -->
<!--   theme_bw() + -->
<!--   facet_wrap(vars(found_all), scales = "free_y") -->
<!-- ``` -->
<!-- Here is how manipulation affects things: -->
<!-- ```{r macd ctrlcomp, fig.dim = c(4,4), include =F} -->
<!-- ggplot(data = all_di_macd_manip, aes(x = skew_percentile, y = ctrl_skew_percentile)) + -->
<!--   geom_point(alpha = .5) + -->
<!--   #  xlim(0, 100) + -->
<!--   # ylim(0, 100) + -->
<!--   theme_bw() + -->
<!--   geom_abline(intercept = 0, slope = 1, color = "green") -->
<!-- ggplot(data = all_di_macd_manip, aes(x = simpson_percentile, y = ctrl_skew_percentile)) + -->
<!--   geom_point(alpha = .5) + -->
<!--   xlim(0, 100) + -->
<!--   ylim(0, 100) + -->
<!--   theme_bw() + -->
<!--   geom_abline(intercept = 0, slope = 1, color = "green") -->
<!-- ggplot(data = all_di_macd_manip, aes(x = simpson_change)) + -->
<!--   geom_histogram() + -->
<!--   theme_bw() -->
<!-- ggplot(data = all_di_macd_manip, aes(x = skew_change)) + -->
<!--   geom_histogram() + -->
<!--   theme_bw() -->
<!-- ggplot(data = all_di_macd_manip, aes(x = ctrl_simpson_percentile, y = simpson_change)) + -->
<!--   geom_point(alpha = .3) + -->
<!--   geom_hline(yintercept = 0) + -->
<!--   theme_bw() -->
<!-- ggplot(data = all_di_macd_manip, aes(x = ctrl_skew_percentile, y = skew_change)) + -->
<!--   geom_point(alpha = .3) + -->
<!--   geom_hline(yintercept = 0) + -->
<!--   theme_bw() -->
<!-- print(t.test(all_di_macd_manip$skew_percentile, all_di_macd_manip$ctrl_skew_percentile, paired = T) -->
<!-- ) -->
<!-- print(t.test(all_di_macd_manip$simpson_percentile, all_di_macd_manip$ctrl_simpson_percentile, paired = T) -->
<!-- ) -->
<!-- print(wilcox.test(all_di_macd_manip$skew_percentile, all_di_macd_manip$ctrl_skew_percentile, paired = T)) -->
<!-- print(wilcox.test(all_di_macd_manip$simpson_percentile, all_di_macd_manip$ctrl_simpson_percentile, paired = T)) -->
<!-- ``` -->
<!-- Change is going to be bounded at 100 and 0: you can't go up or down from there. (Another argument for increasing the number of samples?) -->
<!-- # Portal plant manips -->
<!-- ```{r load pp, include = F} -->
<!-- cache_loc = "portal_plants_manip" -->
<!-- ## Set up the cache and config -->
<!-- db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", paste0("drake-cache-", cache_loc, ".sqlite"))) -->
<!-- cache <- storr::storr_dbi("datatable", "keystable", db) -->
<!-- all_di_p<- readd(all_di_manip, cache = cache)  -->
<!-- all_di_p <- all_di_p %>% -->
<!--   mutate(log_nparts = log(gmp:::as.double.bigz(nparts)), -->
<!--          log_nsamples = log(nsamples)) %>% -->
<!--   mutate(prop_found = exp(log_nsamples - log_nparts)) %>% -->
<!--   mutate(found_all = prop_found==1) -->
<!-- DBI::dbDisconnect(db) -->
<!-- rm(cache) -->
<!-- ``` -->
<!-- Nsamples, singletons -->
<!-- ```{r pp overall, include = F} -->
<!-- #  -->
<!-- # ggplot(data = all_di_p, aes(x = nsamples)) + -->
<!-- #   geom_histogram(bins = 100) + -->
<!-- #   theme_bw() + -->
<!-- #   geom_vline(xintercept = 2000) -->
<!-- #  -->
<!-- # all_di_p <- filter(all_di_p, nsamples >= 2000) -->
<!-- ggplot(data = all_di_p, aes(x = skew_percentile)) + -->
<!--   geom_histogram(bins = 100) + -->
<!--   theme_bw() + -->
<!--   facet_wrap(vars(found_all), scales = "free_y") -->
<!-- ggplot(data = all_di_p, aes(x = simpson_percentile)) + -->
<!--   geom_histogram(bins = 100) + -->
<!--   theme_bw() + -->
<!--   facet_wrap(vars(found_all), scales = "free_y") -->
<!-- #  -->
<!-- # pp_singletons_effect <- all_di_p %>% -->
<!-- #   select(singletons, skew_percentile, simpson_percentile, year, plot, treatment, season) %>% -->
<!-- #   tidyr::pivot_wider(names_from = singletons, values_from = c("skew_percentile", "simpson_percentile")) -->
<!-- #  -->
<!-- # ggplot(data = pp_singletons_effect, aes(x = skew_percentile_FALSE, y  = skew_percentile_TRUE)) + -->
<!-- #   geom_point(alpha = .1) + -->
<!-- #   geom_abline(intercept = 0, slope = 1, color = "green") + -->
<!-- #   theme_bw() -->
<!-- #  -->
<!-- #  -->
<!-- # ggplot(data = pp_singletons_effect, aes(x = simpson_percentile_FALSE, y  = simpson_percentile_TRUE)) + -->
<!-- #   geom_point(alpha = .1) + -->
<!-- #   geom_abline(intercept = 0, slope = 1, color = "green") + -->
<!-- #   theme_bw() -->
<!-- ``` -->
<!-- By treatment, season -->
<!-- ```{r portal trtmt, include =F} -->
<!-- ggplot(data = filter(all_di_p, singletons == F), aes(x = skew_percentile)) + -->
<!--   geom_histogram(bins = 100) + -->
<!--   theme_bw() + -->
<!--   facet_wrap(vars(season, treatment), scales = "free_y") -->
<!-- ggplot(data = filter(all_di_p, singletons == F), aes(x = treatment, y = skew_percentile)) + -->
<!--   geom_boxplot() + -->
<!--   theme_bw() + -->
<!--   facet_wrap(vars(season)) -->
<!-- ggplot(data = filter(all_di_p, singletons == F), aes(x = simpson_percentile)) + -->
<!--   geom_histogram(bins = 100) + -->
<!--   theme_bw() + -->
<!--   facet_wrap(vars(season, treatment), scales = "free_y") -->
<!-- ggplot(data = filter(all_di_p, singletons == F), aes(x = treatment, y = simpson_percentile)) + -->
<!--   geom_boxplot() + -->
<!--   theme_bw() + -->
<!--   facet_wrap(vars(season)) -->
<!-- ``` -->
<!-- <!-- By year -->
--&gt;

<!-- <!-- ```{r plants year, fig.height = 25, fig.width = 5} -->
--&gt;

<!-- <!-- ggplot(data = filter(all_di_p, singletons == F), aes(x = treatment, y = skew_percentile)) + -->
--&gt; <!-- <!--   geom_boxplot() + --> --&gt; <!-- <!--   theme_bw() + --> --&gt; <!-- <!--   facet_grid(rows = vars(year), cols = vars(season), scales = "free_y") --> --&gt; <!-- <!-- ggplot(data = filter(all_di_p, singletons == F), aes(x = treatment, y = simpson_percentile)) + --> --&gt; <!-- <!--   geom_boxplot() + --> --&gt; <!-- <!--   theme_bw() + --> --&gt; <!-- <!--   facet_grid(rows = vars(year), cols = vars(season), scales = "free_y") --> --&gt; <!-- <!-- ``` --> --&gt;

<!-- Median -->
<!-- ```{r pp median, fig.width = 12, fig.height = 12, include =F} -->
<!-- pp_median <- all_di_p %>% -->
<!--   filter(singletons == F) %>% -->
<!--   group_by(season, year, treatment) %>% -->
<!--   summarize(skew_percentile = median(skew_percentile), -->
<!--             simpson_percentile = median(simpson_percentile)) %>% -->
<!--   ungroup() %>% -->
<!--   tidyr::pivot_wider(names_from = treatment, values_from = c(skew_percentile, simpson_percentile)) -->
<!-- sk_x <- ggplot(data = pp_median, aes(x = skew_percentile_control, y = skew_percentile_exclosure)) + -->
<!--   geom_point(alpha = .5) + -->
<!--   facet_wrap(vars(season)) + -->
<!--   theme_bw() + -->
<!--   ggtitle("Skew Ctrl v Exclosure") + -->
<!--   geom_abline(intercept = 0, slope = 1, color = "green") + -->
<!--   xlim(40, 100) + -->
<!--   ylim(40, 100) -->
<!-- sk_r <- ggplot(data = pp_median, aes(x = skew_percentile_control, y = skew_percentile_removal)) + -->
<!--   geom_point(alpha = .5) + -->
<!--   facet_wrap(vars(season)) + -->
<!--   theme_bw() + -->
<!--   ggtitle("Skew Ctrl v Removal") + -->
<!--   geom_abline(intercept = 0, slope = 1, color = "green") + -->
<!--   xlim(40, 100) + -->
<!--   ylim(40, 100) -->
<!-- gridExtra::grid.arrange(grobs = list(sk_x, sk_r), nrow = 2) -->
<!-- sp_x <- ggplot(data = pp_median, aes(x = simpson_percentile_control, y = simpson_percentile_exclosure)) + -->
<!--   geom_point(alpha = .5) + -->
<!--   facet_wrap(vars(season)) + -->
<!--   theme_bw() + -->
<!--   ggtitle("Simpson Ctrl v Exclosure") + -->
<!--   geom_abline(intercept = 0, slope = 1, color = "green") + -->
<!--   xlim(0, 40) + -->
<!--   ylim(0, 40) -->
<!-- sp_r <- ggplot(data = pp_median, aes(x = simpson_percentile_control, y = simpson_percentile_removal)) + -->
<!--   geom_point(alpha = .5) + -->
<!--   facet_wrap(vars(season)) + -->
<!--   theme_bw() + -->
<!--   ggtitle("Simpson Ctrl v Removal") + -->
<!--   geom_abline(intercept = 0, slope = 1, color = "green") + -->
<!--   xlim(0, 40) + -->
<!--   ylim(0, 40) -->
<!-- gridExtra::grid.arrange(grobs = list(sp_x, sp_r), nrow = 2) -->
<!-- ``` -->
