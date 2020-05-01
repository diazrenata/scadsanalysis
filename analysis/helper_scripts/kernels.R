get_standardized_kernel <- function(di_df, metric = "skew", nsims = 100, npoints = 512) {

  di_df <- dplyr::filter(di_df, source != "observed", !is.na(skew), !is.na(simpson))

  twotailed_95 = quantile(di_df[, metric][[1]], probs = c(0.025, 0.975))
  twotailed_95 = twotailed_95[2] - twotailed_95[1]
  twotailed_95 = twotailed_95 /( max(di_df[, metric][[1]]) - min(di_df[, metric][[1]]))


  if(metric == "skew") {
    onetailed_95 = (quantile(di_df[, metric][[1]], probs = .95) - min(di_df[, metric][[1]])) / ( max(di_df[, metric][[1]]) - min(di_df[, metric][[1]]))
  }

  if(metric == "simpson") {
    onetailed_95 = (max(di_df[, metric][[1]]) - quantile(di_df[, metric][[1]], probs = .05)) / ( max(di_df[, metric][[1]]) - min(di_df[, metric][[1]]))
  }

  if(nsims < nrow(di_df)) {
    di_df <- di_df[sample.int(nrow(di_df), size = nsims, replace = F), ]
  }

  if(nrow(di_df) < 2) {
    return()
  }

  kernel <- density(di_df[, metric][[1]], n = npoints)

  return(data.frame(
    dat = di_df$dat[1],
    site = di_df$site[1],
    singletons = di_df$singletons[1],
    nparts = di_df$nparts[1],
    val = kernel$x,
    density = kernel$y / sum(kernel$y),
    index = 1:length(kernel$x),
    onetailed_95 = onetailed_95,
    twotailed_95 = twotailed_95
  ))

}
