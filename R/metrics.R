#' Add dis wrapper
#'
#' @param fs_df full fs df
#'
#' @return full dis
#' @export
#'
#' @importFrom dplyr filter bind_rows
dis_wrapper <- function(fs_df) {

  fs_sites <- as.list(unique(fs_df$site))

  fs_singletons <- lapply(fs_sites, FUN = function(fs_site_name, dataset)
    return(dplyr::filter(dataset, site == fs_site_name, singletons == T)), dataset = fs_df)
  fs_singletons_f <- lapply(fs_sites, FUN = function(fs_site_name, dataset)
    return(dplyr::filter(dataset, site == fs_site_name, singletons == F)), dataset = fs_df)

  if(any(fs_df$singletons)) {

  all_fs_sites <- c(fs_singletons, fs_singletons_f)

  } else {
    all_fs_sites <- fs_singletons_f
  }
  all_dis <- lapply(all_fs_sites, FUN = add_dis)

  all_dis <- dplyr::bind_rows(all_dis)

  return(all_dis)

}

#' Skewness
#'
#' @param fs_samples_df df of all samples, with column for abundance
#'
#' @return summary of skewness per sample
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


#' Count values below a value
#'
#' @param a_value Focal value
#' @param a_vector Vector for comparison
#'
#' @return Number of values in vector below value
#' @export
#'
count_below <- function(a_value, a_vector) {
  return(sum(a_vector < a_value, na.rm = T))
}

#' Get one percentile value
#'
#' @param a_value Focal value
#' @param a_vector Comparison vector
#'
#' @return Percentile of focal value within comparison vector
#' @export
get_percentile <- function(a_value, a_vector) {

  count_below <- sum(a_vector < a_value, na.rm = T)

  nvals <- length(a_vector)

  percentile_val <- 100 * (count_below / nvals)

  return(percentile_val)
}

#' Pull observed diversity indices and nb samples achieved
#'
#' @param di_df result of di_wrapper
#'
#' @return di_df for observed + n samples
#' @export
#'
#' @importFrom dplyr filter mutate group_by ungroup
pull_di <- function(di_df) {

  di_df <- di_df  %>%
    dplyr::group_by(source) %>%
    dplyr::mutate(skew_range = max(skew, na.rm = T) - min(skew, na.rm = T),
                  simpson_range = max(simpson, na.rm = T) - min(simpson, na.rm = T),
                  nsamples = length(unique(sim))) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(skew_range = max(skew_range, na.rm = T),
                  simpson_range = max(simpson_range, na.rm = T),
                  nsamples = max(nsamples, na.rm = T)) %>%
    dplyr::filter(source == "observed")

  return(di_df)

}
