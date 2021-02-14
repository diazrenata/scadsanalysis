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
add_dis <- function(fs_samples_df, sim_props_off = NULL) {

  if(is.null(fs_samples_df)) {
    return(NA)
  }

  groupvars <- colnames(fs_samples_df)[ which(!(colnames(fs_samples_df) %in% c("abund", "rank")))]

  if("observed" %in% fs_samples_df$source) {

  actual <- dplyr::filter(fs_samples_df, sim < 0)

  } else {
    actual <- dplyr::filter(fs_samples_df, sim == min(fs_samples_df$sim, na.rm  = T))
  }

  sim_dis <- fs_samples_df %>%
    dplyr::group_by_at(.vars = groupvars) %>%
    dplyr::summarize(skew = e1071::skewness(abund),
                     shannon = vegan::diversity(abund, index = "shannon", base = exp(1)),
                     simpson = vegan::diversity(abund, index = "simpson"),
                     nsingletons = sum(abund == 1),
                    prop_off_actual = proportion_off(t(cbind(actual$abund, abund)))) %>%
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
                  simpson_percentile = get_percentile(simpson, a_vector = sim_percentiles$simpson),
                  skew_percentile_excl = get_percentile(skew, a_vector = sim_percentiles$skew, incl =F),
                  simpson_percentile_excl = get_percentile(simpson, a_vector = sim_percentiles$simpson, incl = F),
                  nsingletons_percentile = get_percentile(nsingletons, a_vector = sim_percentiles$nsingletons),
                  nsingletons_percentile_excl = get_percentile(nsingletons,
                                                               a_vector = sim_percentiles$nsingletons, incl =F),
                  nsingletons_mean = mean(sim_percentiles$nsingletons, na.rm = T),
                  nsingletons_95 = quantile(sim_percentiles$nsingletons, probs = 0.95, na.rm =T),
                  mean_prop_off_actual = mean(sim_percentiles$prop_off_actual),
                  prop_off_actual_2p5 = quantile( sim_percentiles$prop_off_actual, probs = 0.025, na.rm = T),
                  prop_off_actual_97p5 = quantile( sim_percentiles$prop_off_actual, probs = .975, na.rm = T),
                  prop_off_actual_5 = quantile(sim_percentiles$prop_off_actual, probs = .05, na.rm = T),
                  prop_off_actual_95 = quantile(sim_percentiles$prop_off_actual, probs = .95, na.rm = T)
                  )


  if(!(is.null(sim_props_off))) {

    sampled_percentile <- sampled_percentile %>%
      dplyr::mutate(prop_off_sim_95 = quantile(sim_props_off$prop_off, probs = .95, na.rm = T),
                    mean_prop_off_sim = mean(sim_props_off$prop_off, na.rm = T),
                    prop_off_sim_95_1t = (quantile(sim_props_off$prop_off, probs = .95, na.rm = T) - min(sim_props_off$prop_off))/(max(sim_props_off$prop_off) - min(sim_props_off$prop_off)))
}

  sim_dis <- dplyr::bind_rows(sim_percentiles, sampled_percentile)

  if(!("observed" %in% fs_samples_df$source)) {

    prop_off_cols <- colnames(sim_dis)[ which(grepl("prop_off", colnames(sim_dis)))]

    sim_dis[ , prop_off_cols] <- NA
  }
  return(sim_dis)
}

#' Get FS diff metrics
#'
#' @param fs_df samples
#'
#' @return diffs
#' @export
#' @importFrom dplyr filter select
get_fs_diffs <- function(fs_df) {

  fs_df <- fs_df %>%
    dplyr::filter(source != "observed")

  sim_props_off <- rep_diff_sampler(fs_df, ndraws = length(unique(fs_df$sim))) %>%
    dplyr::select(-nparts, -s0, n0)

  return(sim_props_off)


}

#' Get percentile values
#'
#' Calculate the percentile values (% of elements in the vector <= a value) for all values in a vector
#'
#' @param a_vector Vector of values
#' @param incl tf lessthan or equal to or just less than
#'
#' @return Vector of percentile values for all values in the vector
#' @export
#'
get_percentiles <- function(a_vector, incl = T) {

  nvals <- sum(!(is.na(a_vector)))

  percentile_vals <- vapply(as.matrix(a_vector), FUN = count_below, a_vector = a_vector, incl = incl, FUN.VALUE = 100)

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
#' @param incl include end or not? if true, <=, if false, <
#'
#' @return Number of values in vector less than or equal to the focal value
#' @export
#'
count_below <- function(a_value, a_vector, incl = T) {
  if(incl) {
  return(sum(a_vector <= a_value, na.rm = T))
  } else {
    return(sum(a_vector < a_value, na.rm = T))
  }
}

#' Get one percentile value
#'
#' Calculate the percentile value for a focal value relative to a comparison vector, as the % of elements in the comparison vector less than or equal to the focal value.
#'
#' @param a_value Focal value
#' @param a_vector Comparison vector
#' @param incl include end or not? if true, <=, if false, <
#'
#' @return Percentile of focal value within comparison vector
#' @export
get_percentile <- function(a_value, a_vector, incl= T) {

  if(incl) {
  count_below <- sum(a_vector <= a_value, na.rm = T)
  } else {
    count_below <- sum(a_vector < a_value, na.rm = T)

}
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
                     skew_unique = length(unique(skew, na.rm = T)),
                     simpson_unique = length(unique(simpson, na.rm = T)),
                     shannon_unique = length(unique(shannon, na.rm = T)),
                     skew_2p5 = quantile(skew, probs = c(0.025), na.rm = T),
                     skew_97p5 = quantile(skew, probs = c(0.975), na.rm = T),
                     skew_95 = quantile(skew, probs = c(0.95), na.rm = T),
                     skew_min = min(skew, na.rm = T),
                     simpson_max = max(simpson, na.rm = T),
                     shannon_min = min(shannon, na.rm = T),
                     shannon_2p5 = quantile(shannon, probs = c(0.025), na.rm = T),
                     shannon_97p5 = quantile(shannon, probs = c(0.975), na.rm = T),
                     shannon_max = max(shannon, na.rm = T),
                     shannon_5 = quantile(shannon, probs = c(.05), na.rm = T),
                     shannon_range = max(shannon, na.rm = T) - min(shannon, na.rm = T),
                     simpson_2p5 = quantile(simpson, probs = c(0.025), na.rm = T),
                     simpson_5 = quantile(simpson, probs = c(.05), na.rm = T),
                     simpson_97p5 = quantile(simpson, probs = c(0.975), na.rm = T)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(skew_95_ratio_2t = (skew_97p5 - skew_2p5)/skew_range,
                  simpson_95_ratio_2t = (simpson_97p5 - simpson_2p5)/simpson_range,
                  skew_95_ratio_1t = (skew_95 - skew_min)/skew_range,
                  simpson_95_ratio_1t = (simpson_max - simpson_5)/simpson_range,
                  shannon_95_ratio_2t = (shannon_97p5 - shannon_2p5) / shannon_range,
                  shannon_95_ratio_1t = (shannon_max - shannon_5) / shannon_range
    )

  di_observed <- dplyr::filter(di_df, source == "observed") %>%
    dplyr::left_join(di_sampled)

  return(di_observed)

}

#' Summarize just samples
#'
#' Extracts summary information about the distribution of shape metric values from the samples from the FS:
#'
#' - Number of unique samples found from the FS
#' - Range, mean, standard deviation, min, max, .25, .95, and .975 quantiles for the distributions of skewness and evenness from the samples
#' - Ratio of the width of two-tailed and one-tailed 95% intervals to the full range for both skewness and evenness. For skewness, the one-tailed interval is from 0-.95; for evenness, the one-tailed interval is from .05-1. The two-tailed intervals are from .025 to .975.
#'
#' @param di_df result of di_wrapper
#'
#' @return di_df for ONLY samples
#' @export
#'
#' @importFrom dplyr filter mutate group_by ungroup summarize left_join
pull_di_net <- function(di_df) {

  di_sampled <- di_df %>%
    dplyr::group_by(s0, n0,dat, site, nparts) %>%
    dplyr::summarize(skew_range = max(skew, na.rm = T) - min(skew, na.rm = T),
                     simpson_range = max(simpson, na.rm = T) - min(simpson, na.rm = T),
                     nsamples = length(unique(sim)),
                     skew_unique = length(unique(skew, na.rm = T)),
                     simpson_unique = length(unique(simpson, na.rm = T)),
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

  return(di_sampled)

}
