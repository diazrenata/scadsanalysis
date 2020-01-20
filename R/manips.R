#' Assign ctrl/treatment designation to MACD sites
#'
#' @param all_di diversity indicies df
#' @param storage_path where the MACD is
#'
#' @return all_di with study and ctrl/treatment
#' @export
#'
#' @importFrom tidyr gather
#' @importFrom here here
#' @importFrom dplyr mutate left_join filter
assign_macdb_manips <- function(all_di, storage_path = here::here("working-data", "macdb_data")) {

  comparisons <- read.csv(file.path(storage_path, "orderedcomparisons.csv"), stringsAsFactors = F, header = F)

  colnames(comparisons) <- c("studyID", "control", "comparison")

  comparisons <- comparisons %>%
    tidyr::gather(-studyID, key = "treatment", value = "site") %>%
    dplyr::mutate(site = as.character(site))

  comparisons_di <- dplyr::left_join(all_di, comparisons, by = "site") %>%
    dplyr::filter(!is.na(source), !is.na(studyID))

return(comparisons_di)

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
