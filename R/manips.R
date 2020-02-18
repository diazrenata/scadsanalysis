#' Assign ctrl/treatment designation to MACD sites
#'
#' @param all_di diversity indicies df
#' @param storage_path where the MACD is
#'
#' @return all_di with study and ctrl/treatment
#' @export
#'
#' @importFrom here here
#' @importFrom dplyr mutate left_join filter select rename
#' @importFrom tidyr gather
assign_macdb_manips <- function(all_di, storage_path = here::here("working-data", "macdb_data")) {

  comparisons <- read.csv(file.path(storage_path, "orderedcomparisons.csv"), stringsAsFactors = F, header = F)

  colnames(comparisons) <- c("studyID", "control", "comparison")

  siteID_treatment <- comparisons %>%
    tidyr::gather(-studyID, key = "treatment", value = "site") %>%
    dplyr::mutate(site = as.character(site))

  all_di <- dplyr::left_join(all_di, siteID_treatment, by = "site") %>%
    dplyr::filter(!is.na(source), !is.na(studyID))

  comparisons <- comparisons %>%
    dplyr::rename(site = comparison) %>%
    dplyr::mutate(site = as.character(site),
                  control = as.character(control))

  comparison_di <- all_di %>%
    dplyr::filter(singletons == FALSE, treatment == "comparison") %>%
    dplyr::left_join(comparisons, by = c("studyID", "site")) %>%
    dplyr::select(dat, site, skew_percentile, simpson_percentile, studyID, control) %>%
    dplyr::rename(comparison = site) %>%
    dplyr::mutate(ctrl_skew_percentile = NA,
                  ctrl_simpson_percentile = NA)
  for(i in 1:nrow(comparison_di)) {

    control_row <- dplyr::filter(all_di, site == comparison_di$control[i], singletons == F) %>%
      unique()
    if(nrow(control_row) >0 ) {
      comparison_di$ctrl_simpson_percentile[i] <- control_row$simpson_percentile
      comparison_di$ctrl_skew_percentile[i] <- control_row$skew_percentile
    }
  }
  comparison_di <- comparison_di %>%
    dplyr::mutate(simpson_change = simpson_percentile - ctrl_simpson_percentile,
                  skew_change = skew_percentile - ctrl_skew_percentile)

  return(comparison_di)

}


#' Parse portal site names for manips
#'
#' @param all_di all di
#'
#' @return all di with cols for year, plot, season, trtmt
#' @export
#'
#' @importFrom purrr map_int
assign_portal_manips <- function(all_di) {

  all_di$year <- purrr::map_int(all_di$site,.f = function(sitename) return(as.integer(strsplit(sitename, split = "_")[[1]][1])))
  all_di$plot <- purrr::map_int(all_di$site,.f = function(sitename) return(as.integer(strsplit(sitename, split = "_")[[1]][2])))
  all_di$treatment <- purrr::map_chr(all_di$site,.f = function(sitename) return(strsplit(sitename, split = "_")[[1]][3]))
  all_di$season <- purrr::map_chr(all_di$site,.f = function(sitename) return(strsplit(sitename, split = "_")[[1]][4]))

  return(all_di)

}
