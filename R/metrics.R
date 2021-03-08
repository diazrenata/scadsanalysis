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
#' @importFrom dplyr group_by_at summarize ungroup filter mutate left_join
#' @importFrom vegan diversity
add_dis <- function(fs_samples_df, sim_props_off = NULL, props_comparison = NULL) {

  if(is.null(fs_samples_df)) {
    return(NA)
  }

  if(fs_samples_df$dat[1] == "net") {
    fs_samples_df <- fs_samples_df %>%
      dplyr::filter(!is.na(sim))
  }

  groupvars <- colnames(fs_samples_df)[ which(!(colnames(fs_samples_df) %in% c("abund", "rank")))]
#
#   if("observed" %in% fs_samples_df$source) {
#
#     actual <- dplyr::filter(fs_samples_df, sim < 0)
#
#
#     sim_dis <- fs_samples_df %>%
#       dplyr::group_by_at(.vars = groupvars) %>%
#       dplyr::summarize(skew = e1071::skewness(abund),
#                        shannon = vegan::diversity(abund, index = "shannon", base = exp(1)),
#                        simpson = vegan::diversity(abund, index = "simpson"),
#                        nsingletons = sum(abund == 1),
#                        prop_off_actual = proportion_off(t(cbind(actual$abund, abund)))) %>%
#       dplyr::ungroup()
#
#   } else {
#
#     sim_dis <- fs_samples_df %>%
#       dplyr::group_by_at(.vars = groupvars) %>%
#       dplyr::summarize(skew = e1071::skewness(abund),
#                        shannon = vegan::diversity(abund, index = "shannon", base = exp(1)),
#                        simpson = vegan::diversity(abund, index = "simpson"),
#                        nsingletons = sum(abund == 1),
#                        prop_off_actual = proportion_off(t(cbind(actual$abund, abund)))) %>%
#       dplyr::ungroup()  }

  if(is.null(props_comparison)) {

    props_comparison <- lapply(unique(fs_samples_df$sim), FUN = compare_props_off, fs_df = fs_samples_df, ncomps = 1000) %>%
      dplyr::bind_rows()
  }



  sim_dis <- fs_samples_df %>%
    dplyr::group_by_at(.vars = groupvars) %>%
    dplyr::summarize(skew = e1071::skewness(abund),
                     shannon = vegan::diversity(abund, index = "shannon", base = exp(1)),
                     simpson = vegan::diversity(abund, index = "simpson"),
                     nsingletons = sum(abund == 1)) %>% #,
                    # prop_off_actual = proportion_off(t(cbind(actual$abund, abund)))) %>%
    dplyr::ungroup()

  sim_dis <- dplyr::left_join(sim_dis, props_comparison, by = c("sim" = "focal_sim"))


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
                  shannon_percentile_excl =  get_percentile(shannon, a_vector = sim_percentiles$shannon, incl = F),
                  nsingletons_percentile = get_percentile(nsingletons, a_vector = sim_percentiles$nsingletons),
                  nsingletons_percentile_excl = get_percentile(nsingletons,
                                                               a_vector = sim_percentiles$nsingletons, incl =F),
                  # nsingletons_mean = mean(sim_percentiles$nsingletons, na.rm = T),
                  # nsingletons_95 = quantile(sim_percentiles$nsingletons, probs = 0.95, na.rm =T),
                  # nsingletons_median = median(sim_percentiles$nsingletons),
                  # nsingletons_min = min(sim_percentiles$nsingletons, na.rm = T),
                  # nsingletons_max = max(sim_percentiles$nsingletons, na.rm = T),
                  # nsingletons_2p5 = quantile(sim_percentiles$nsingletons, probs = 0.025, na.rm = T),
                  # nsingletons_97p5 = quantile(sim_percentiles$nsingletons, probs = .975, na.rm = T),
                  # mean_prop_off_actual = mean(sim_percentiles$prop_off_actual),
                  # prop_off_actual_2p5 = quantile( sim_percentiles$prop_off_actual, probs = 0.025, na.rm = T),
                  # prop_off_actual_97p5 = quantile( sim_percentiles$prop_off_actual, probs = .975, na.rm = T),
                  # prop_off_actual_5 = quantile(sim_percentiles$prop_off_actual, probs = .05, na.rm = T),
                  # prop_off_actual_95 = quantile(sim_percentiles$prop_off_actual, probs = .95, na.rm = T),
                  mean_po_comparison_percentile = get_percentile(mean_po_comparison, a_vector = sim_percentiles$mean_po_comparison),
                  mean_po_comparison_percentile_excl = get_percentile(mean_po_comparison, a_vector = sim_percentiles$mean_po_comparison, incl = F),
                  mean_po_comparison_sims = mean(sim_percentiles$mean_po_comparison, na.rm = T)
    )
#
#
#   if(!(is.null(sim_props_off))) {
#
#     sampled_percentile <- sampled_percentile %>%
#       dplyr::mutate(prop_off_sim_95 = quantile(sim_props_off$prop_off, probs = .95, na.rm = T),
#                     mean_prop_off_sim = mean(sim_props_off$prop_off, na.rm = T),
#                     prop_off_sim_95_1t = (quantile(sim_props_off$prop_off, probs = .95, na.rm = T) - min(sim_props_off$prop_off))/(max(sim_props_off$prop_off) - min(sim_props_off$prop_off)))
#   }

  sim_dis <- dplyr::bind_rows(sim_percentiles, sampled_percentile)

  # if(!("observed" %in% fs_samples_df$source)) {
  #
  #   prop_off_cols <- colnames(sim_dis)[ which(grepl("prop_off", colnames(sim_dis)))]
  #
  #   sim_dis[ , prop_off_cols] <- NA
  # }


  return(sim_dis)
}

#' Compare PO over whole dataset
#'
#' @param fs_samples_df fs draws
#' @param ncomps comparisons per focal
#'
#' @return comparisons for all draws
#' @export
#'
#' @importFrom dplyr bind_rows
compare_props_fs <- function(fs_samples_df, ncomps = 500) {

  props_comparison <- lapply(unique(fs_samples_df$sim), FUN = compare_props_off, fs_df = fs_samples_df, ncomps = ncomps) %>%
    dplyr::bind_rows()

  return(props_comparison)
}

#' Compare proportion off of two sims
#'
#' @param focal_sim index of sim
#' @param fs_df samples from FS
#' @param ncomps how many comparisons
#'
#' @return mean proportion off of focal sim vs ncomparisons sims from fs_df
#' @export
#'
#' @importFrom dplyr filter group_by summarize
compare_props_off <- function(focal_sim, fs_df, ncomps = 100) {

  fs_df$sim_char = as.character(fs_df$sim)

  if(focal_sim != -99) {
    fs_df <- dplyr::filter(fs_df, sim > 0)
  }

  nsims <- unique(fs_df$sim_char)[ which(unique(fs_df$sim_char) != as.character(focal_sim))]

  if(length(nsims) == 0) {
    return(data.frame(focal_sim = focal_sim, mean_po_comparison = NA, n_po_comparisons = 0))
  }

  focal_sad <- dplyr::filter(fs_df, sim == focal_sim)

  compare_sims <- sample(nsims, size = min(length(nsims), ncomps), replace =F)

  compare_sads <- dplyr::filter(fs_df, sim_char %in% compare_sims)

  compare_props <- compare_sads %>%
    dplyr::group_by(sim) %>%
    dplyr::summarize(prop_off = proportion_off(t(data.frame(abund, focal_sad$abund)))) %>%
    dplyr::ungroup()

  return(data.frame(focal_sim = focal_sim, mean_po_comparison = mean(compare_props$prop_off, na.rm = T), n_po_comparisons = nrow(compare_props)))
}

#' Compare proportion off of two sims
#'
#' @param focal_sim index of sim
#' @param fs_df samples from FS
#' @param ncomps how many comparisons
#'
#' @return mean proportion off of focal sim vs ncomparisons sims from fs_df
#' @export
#'
#' @importFrom dplyr filter group_by summarize
compare_props_off_full <- function(focal_sim, fs_df, ncomps = 100) {

  fs_df$sim_char = as.character(fs_df$sim)

  if(focal_sim != -99) {
    fs_df <- dplyr::filter(fs_df, sim > 0)
  }

  nsims <- unique(fs_df$sim_char)[ which(unique(fs_df$sim_char) != as.character(focal_sim))]

  if(length(nsims) == 0) {
    return(data.frame(sim = focal_sim, prop_off = NA))
  }

  focal_sad <- dplyr::filter(fs_df, sim == focal_sim)

  compare_sims <- sample(nsims, size = min(length(nsims), ncomps), replace =F)

  compare_sads <- dplyr::filter(fs_df, sim_char %in% compare_sims)

  compare_props <- compare_sads %>%
    dplyr::group_by(sim) %>%
    dplyr::summarize(prop_off = proportion_off(t(data.frame(abund, focal_sad$abund)))) %>%
    dplyr::ungroup()

  return(compare_props)
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
                     simpson_97p5 = quantile(simpson, probs = c(0.975), na.rm = T),
                     mean_po_comparison_95 = quantile(mean_po_comparison, probs = .95, na.rm = T),
                     mean_po_comparison_min = min(mean_po_comparison, na.rm = T),
                     mean_po_comparison_max = max(mean_po_comparison, na.rm = T),
                     nsingletons_mean = mean(nsingletons, na.rm = T),
                     nsingletons_95 = quantile(nsingletons, probs = 0.95, na.rm =T),
                     nsingletons_median = median(nsingletons),
                     nsingletons_min = min(nsingletons, na.rm = T),
                     nsingletons_max = max(nsingletons, na.rm = T),
                     nsingletons_2p5 = quantile(nsingletons, probs = 0.025, na.rm = T),
                     nsingletons_97p5 = quantile(nsingletons, probs = .975, na.rm = T)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(skew_95_ratio_2t = (skew_97p5 - skew_2p5)/skew_range,
                  simpson_95_ratio_2t = (simpson_97p5 - simpson_2p5)/simpson_range,
                  skew_95_ratio_1t = (skew_95 - skew_min)/skew_range,
                  simpson_95_ratio_1t = (simpson_max - simpson_5)/simpson_range,
                  shannon_95_ratio_2t = (shannon_97p5 - shannon_2p5) / shannon_range,
                  shannon_95_ratio_1t = (shannon_max - shannon_5) / shannon_range,
                  mean_po_comparison_95_ratio_1t = (mean_po_comparison_95 - mean_po_comparison_min) / (mean_po_comparison_max - mean_po_comparison_min),
                  nsingletons_95_ratio_1t = (nsingletons_95 - nsingletons_min) / (nsingletons_max - nsingletons_min),
                  nsingletons_95_ratio_2t = (nsingletons_97p5 - nsingletons_2p5) / (nsingletons_max - nsingletons_min)
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
                     simpson_97p5 = quantile(simpson, probs = c(0.975), na.rm = T),
                     mean_po_comparison_95 = quantile(mean_po_comparison, probs = .95, na.rm = T),
                     mean_po_comparison_min = min(mean_po_comparison, na.rm = T),
                     mean_po_comparison_max = max(mean_po_comparison, na.rm = T),
                     nsingletons_mean = mean(nsingletons, na.rm = T),
                     nsingletons_95 = quantile(nsingletons, probs = 0.95, na.rm =T),
                     nsingletons_median = median(nsingletons),
                     nsingletons_min = min(nsingletons, na.rm = T),
                     nsingletons_max = max(nsingletons, na.rm = T),
                     nsingletons_2p5 = quantile(nsingletons, probs = 0.025, na.rm = T),
                     nsingletons_97p5 = quantile(nsingletons, probs = .975, na.rm = T)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(skew_95_ratio_2t = (skew_97p5 - skew_2p5)/skew_range,
                  simpson_95_ratio_2t = (simpson_97p5 - simpson_2p5)/simpson_range,
                  skew_95_ratio_1t = (skew_95 - skew_min)/skew_range,
                  simpson_95_ratio_1t = (simpson_max - simpson_5)/simpson_range,
                  shannon_95_ratio_2t = (shannon_97p5 - shannon_2p5) / shannon_range,
                  shannon_95_ratio_1t = (shannon_max - shannon_5) / shannon_range,
                  mean_po_comparison_95_ratio_1t = (mean_po_comparison_95 - mean_po_comparison_min) / (mean_po_comparison_max - mean_po_comparison_min),
                  nsingletons_95_ratio_1t = (nsingletons_95 - nsingletons_min) / (nsingletons_max - nsingletons_min),
                  nsingletons_95_ratio_2t = (nsingletons_97p5 - nsingletons_2p5) / (nsingletons_max - nsingletons_min)
    )

  return(di_sampled)

}


#' PO CT
#'
#' @param fs_df fs
#' @param fs_po_df pcs
#'
#' @return df
#' @export
#'
#' @importFrom dplyr filter select distinct mutate
po_central_tendency <- function(fs_df, fs_po_df) {

  ct_sim <- dplyr::filter(fs_po_df, mean_po_comparison == min(fs_po_df$mean_po_comparison))$focal_sim[1]

  ct_pos <- compare_props_off_full(ct_sim, fs_df, ncomps = length(unique(fs_df$sim)) - 2) %>%
    dplyr::distinct()

  real_po <- proportion_off(t(data.frame(dplyr::filter(fs_df, source == "observed")$abund, dplyr::filter(fs_df, sim == ct_sim)$abund)))

  out <- fs_df %>%
    dplyr::filter(source == "observed") %>%
    dplyr::select(source, dat, site, singletons, s0, n0, sim, nparts) %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      real_po = real_po,
      best_po_sim = ct_sim,
      sim_devs_from_best = mean(ct_pos$prop_off),
      ncomparisons = nrow(ct_pos),
      real_po_percentile = get_percentile(real_po, ct_pos$prop_off),
      real_po_percentile_excl = get_percentile(real_po, ct_pos$prop_off, incl = F)
    )

  return(out)

}
