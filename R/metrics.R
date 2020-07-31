#' Summarize sampled and observed SADs
#'
#' Given a dataframe of sampled and observed SAD vectors,
#' - summarizes each vector with skewness, Shannon diversity, and Simpson evenness
#' - calculates the percentile rank for each diversity metric for every sample. The observed percentile rank is calculated against the distribution of sampled values for each metric.
#'
#' @param fs_samples_df df of all samples - observed and sampled - with column for abundance, *for a single site*. Output of `sample_fs` or `sample_fs_wrapper`
#'
#' @return data frame with summary statistic values and percentile scores for each metric, for every sampled and observed SAD
#' @export
#'
#' @importFrom e1071 skewness
#' @importFrom dplyr group_by_at summarize ungroup filter mutate
#' @importFrom vegan diversity
add_dis <- function(fs_samples_df) {

  if(is.null(fs_samples_df)) {
    return(NA)
  }

  groupvars <- colnames(fs_samples_df)[ which(!(colnames(fs_samples_df) %in% c("abund", "rank")))]

  sim_dis <- fs_samples_df %>%
    dplyr::group_by_at(.vars = groupvars) %>%
    dplyr::summarize(skew = e1071::skewness(abund),
                     shannon = vegan::diversity(abund, index = "shannon", base = exp(1)),
                     simpson = vegan::diversity(abund, index = "simpson")) %>%
    dplyr::ungroup()

  sim_percentiles <- sim_dis %>%
    dplyr::filter(source == "sampled", sim > 0) %>%
    dplyr::mutate(skew_percentile = get_percentiles(skew),
                  shannon_percentile = get_percentiles(shannon),
                  simpson_percentile = get_percentiles(simpson))

  sampled_percentile <- sim_dis %>%
    dplyr::filter(source == "observed", sim < 0) %>%
    dplyr::mutate(skew_percentile = get_percentile(skew, a_vector = sim_percentiles$skew),
                  shannon_percentile = get_percentile(shannon, a_vector = sim_percentiles$shannon),
                  simpson_percentile = get_percentile(simpson, a_vector = sim_percentiles$simpson))


  sim_dis <- dplyr::bind_rows(sim_percentiles, sampled_percentile)

  return(sim_dis)
}

#' Get percentile values
#'
#' Calculate the percentile values (% of elements in the vector <= a value) for all values in a vector
#'
#' @param a_vector Vector of values
#'
#' @return Vector of percentile values for all values in the vector
#' @export
#'
get_percentiles <- function(a_vector) {

  nvals <- sum(!(is.na(a_vector)))

  percentile_vals <- vapply(as.matrix(a_vector), FUN = count_below, a_vector = a_vector, FUN.VALUE = 100)

  for(i in 1:length(a_vector)) {
    if(!(is.nan(a_vector[i]))) {
      percentile_vals[i] <- 100 * (percentile_vals[i] / nvals)
    } else {
      percentile_vals[i] <- NA
    }
  }
  return(percentile_vals)
}


#' Count values less than or equal to a value
#'
#' @param a_value Focal value
#' @param a_vector Vector for comparison
#'
#' @return Number of values in vector less than or equal to the focal value
#' @export
#'
count_below <- function(a_value, a_vector) {
  return(sum(a_vector <= a_value, na.rm = T))
}

#' Get one percentile value
#'
#' Calculate the percentile value for a focal value relative to a comparison vector, as the % of elements in the comparison vector less than or equal to the focal value.
#'
#' @param a_value Focal value
#' @param a_vector Comparison vector
#'
#' @return Percentile of focal value within comparison vector
#' @export
get_percentile <- function(a_value, a_vector) {

  count_below <- sum(a_vector <= a_value, na.rm = T)

  nvals <- length(a_vector)

  percentile_val <- 100 * (count_below / nvals)

  return(percentile_val)
}

#' Summarize observed vs. samples
#'
#' Extracts the percentile rank for the shape metric value for the observed SAD relative to the samples from its FS, as well as summary information about the distribution of shape metric values from the samples from the FS:
#'
#' - Number of unique samples found from the FS
#' - Range, mean, standard deviation, min, max, .25, .95, and .975 quantiles for the distributions of skewness and evenness from the samples
#' - Ratio of the width of two-tailed and one-tailed 95% intervals to the full range for both skewness and evenness. For skewness, the one-tailed interval is from 0-.95; for evenness, the one-tailed interval is from .05-1. The two-tailed intervals are from .025 to .975.
#'
#' @param di_df result of di_wrapper
#'
#' @return di_df for observed + n samples
#' @export
#'
#' @importFrom dplyr filter mutate group_by ungroup summarize left_join
pull_di <- function(di_df) {

  di_sampled <- dplyr::filter(di_df, source != "observed") %>%
    dplyr::group_by(s0, n0,dat, site) %>%
    dplyr::summarize(skew_range = max(skew, na.rm = T) - min(skew, na.rm = T),
                     simpson_range = max(simpson, na.rm = T) - min(simpson, na.rm = T),
                     nsamples = length(unique(sim)),
                     skew_sd = sd(skew, na.rm = T),
                     skew_mean = mean(skew, na.rm = T),
                     simpson_sd = sd(simpson, na.rm = T),
                     simpson_mean = mean(simpson, na.rm = T),
                     skew_2p5 = quantile(skew, probs = c(0.025), na.rm = T),
                     skew_97p5 = quantile(skew, probs = c(0.975), na.rm = T),
                     skew_95 = quantile(skew, probs = c(0.95), na.rm = T),
                     skew_min = min(skew, na.rm = T),
                     simpson_max = max(simpson, na.rm = T),
                     simpson_2p5 = quantile(simpson, probs = c(0.025), na.rm = T),
                     simpson_5 = quantile(simpson, probs = c(.05), na.rm = T),
                     simpson_97p5 = quantile(simpson, probs = c(0.975), na.rm = T)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(skew_95_ratio_2t = (skew_97p5 - skew_2p5)/skew_range,
                  simpson_95_ratio_2t = (simpson_97p5 - simpson_2p5)/simpson_range,
                  skew_95_ratio_1t = (skew_95 - skew_min)/skew_range,
                  simpson_95_ratio_1t = (simpson_max - simpson_5)/simpson_range
    )

  di_observed <- dplyr::filter(di_df, source == "observed") %>%
    dplyr::left_join(di_sampled)

  return(di_observed)

}
