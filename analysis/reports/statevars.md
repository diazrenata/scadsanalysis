Max N and S
================

``` r
statevars_plot <- ggplot(data = statevars, aes(x = s0, y = n0, color = singletons)) +
  geom_point() +
  theme_bw() +
  scale_color_viridis_d(end = .5)

statevars_plot
```

![](statevars_files/figure-markdown_github/s%20and%20n%20plot-1.png)

``` r
statevars_plot_facetted <- statevars_plot +
  facet_wrap(vars(dat))

statevars_plot_facetted
```

![](statevars_files/figure-markdown_github/s%20and%20n%20plot%20facetted-1.png)
