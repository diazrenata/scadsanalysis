#' Filter misc abund data
#'
#' Misc abund dataset has some very large communities, which I am removing for now to keep the p table tractable. This function is to make that filtering documented.
#'
#' @param max_s currently 200
#' @param max_n currently 40720
#' @param storage_path where to put it
#' @param save save it?
#'
#' @return nothing
#' @export
#'
#' @importFrom dplyr filter mutate
filter_miscabund <- function(max_s = 200, max_n = 40720, storage_path = here::here("working-data", "abund_data"), save = TRUE) {

  misc_abund <- load_dataset("misc_abund")

  misc_abund_sv <- get_statevars(misc_abund) %>%
    dplyr::filter(s0 <= max_s, n0 <= max_n)

  misc_abund <- misc_abund %>%
    dplyr::filter(site %in% misc_abund_sv$site) %>%
    dplyr::mutate(dat = "misc_abund_short")

  if(save) {

    write.csv(misc_abund, file.path(storage_path, "misc_abund_short_spab.csv"), row.names = F)

  }
}

#' Filter FIA data
#'
#' Following White et al 2012, filtering FIA data to sites with > 10 species. This brings it from 103343 sites to 10355.
#'
#' @param storage_path where to put it
#' @param save save it?
#'
#' @return nothing
#' @export
#'
#' @importFrom dplyr filter mutate
filter_fia <- function(storage_path = here::here("working-data", "abund_data"), save = TRUE) {

  fia <- load_dataset("fia", storage_path = storage_path)

  fia_sv <- get_statevars(fia) %>%
    dplyr::filter(s0 >= 10)

  fia <- fia %>%
    dplyr::filter(site %in% fia_sv$site) %>%
    dplyr::mutate(dat = "fia_short")

  if(save) {

    write.csv(fia, file.path(storage_path, "fia_short_spab.csv"), row.names = F)

  }
}

#' Load a dataset
#'
#' @param dataset_name "bbs", "fia", "gentry", "mcdb", "portal_plants", "misc_abund_short", or "misc_abund"
#' @param storage_path where the data is living
#'
#' @return something
#' @export
#'
load_dataset <- function(dataset_name, storage_path = here::here("working-data", "abund_data")) {

  dataset_path = file.path(storage_path, paste0(dataset_name, "_spab.csv"))

  if(dataset_name != "misc_abund") {
    if(dataset_name  %in% c("misc_abund_short", "fia_short")) {

      dataset <- read.csv(dataset_path, stringsAsFactors = F)

      dataset <- dataset %>%
        dplyr::mutate(site = as.character(site))

      return(dataset)

    } else if (dataset_name %in% c("portal_plants", "macdb", "portal_plants_manip")) {

      dataset <- read.csv(dataset_path, stringsAsFactors = F, header = T)

    }
    else {
      dataset <- read.csv(dataset_path, stringsAsFactors = F, header = F, skip = 2)

      colnames(dataset) <- c("site", "year", "species", "abund")
    }
  } else  {
    dataset <- read.csv(dataset_path, stringsAsFactors = F)

    dataset <- dataset %>%
      dplyr::rename(site = Site_ID,
                    abund = Abundance)
  }

  dataset <- dataset %>%
    dplyr::mutate(site = as.character(site),
                  dat = dataset_name) %>%
    dplyr::select(site, abund, dat) %>%
    dplyr::filter(abund > 0) %>%
    dplyr::group_by(site) %>%
    dplyr::arrange(abund) %>%
    dplyr::mutate(rank = dplyr::row_number()) %>%
    dplyr::ungroup() %>%
    dplyr::select(rank, abund, site, dat) %>%
    dplyr::mutate(singletons = FALSE,
                  sim = -99,
                  source = "observed")

  return(dataset)

}

#' List sites in a dataset
#'
#' @param dataset_name "bbs", "fia", "gentry", "mcdb", or "misc_abund"
#' @param storage_path where the data is living
#'
#' @return dataframe of site names
#' @export
#' @importFrom dplyr select filter group_by summarize ungroup rename distinct mutate
list_sites <- function(dataset_name, storage_path = here::here("working-data", "abund_data")) {

  dataset_path = file.path(storage_path, paste0(dataset_name, "_spab.csv"))

  if(dataset_name != "misc_abund") {

    if(dataset_name %in% c("misc_abund_short", "fia_short")) {

      dataset <- read.csv(dataset_path, stringsAsFactors = F)

    } else if (dataset_name == "portal_plants") {

      dataset <- read.csv(dataset_path, stringsAsFactors = F, header = T)

    } else {

      dataset <- read.csv(dataset_path, stringsAsFactors = F, header = F, skip = 2)

      colnames(dataset) <- c("site", "year", "species", "abund")
    }
  } else {
    dataset <- read.csv(dataset_path, stringsAsFactors = F)

    dataset <- dataset %>%
      dplyr::select(Abundance, Site_ID) %>%
      dplyr::filter(!is.na(Abundance)) %>%
      dplyr::group_by(Site_ID) %>%
      dplyr::summarize(Abundance = sum(Abundance)) %>%
      dplyr::ungroup() %>%
      dplyr::filter(Abundance > 0) %>%
      dplyr::rename(site = Site_ID,
                    abund = Abundance)
  }

  dataset <- dataset %>%
    dplyr::select(site) %>%
    dplyr::distinct() %>%
    dplyr::mutate(dat = dataset_name,
                  site = as.character(site))

  return(dataset)
}

#' Add singletons to a dataset
#'
#' @param dataset the dataset
#' @param use_max use max?
#'
#' @return dataset plus singletons
#' @export
#'
#' @importFrom dplyr filter bind_rows
add_singletons_dataset <- function(dataset, use_max = TRUE) {

  sites <- as.list(unique(dataset$site))

  site_dats <- lapply(sites, FUN = function(site_name, dataset) return(dplyr::filter(dataset, site == site_name)), dataset = dataset)

  site_singletons <- lapply(site_dats, FUN = add_singletons, use_max = use_max)

  site_singletons <- dplyr::bind_rows(site_singletons)

  dataset <- dplyr::bind_rows(dataset, site_singletons)

  return(dataset)

}

#' Retrieve statevars
#'
#' @param a_dataset with columns site, dat, singletons, sim, source, abund
#'
#' @return summarzied to s0 and n0
#' @export
#'
#' @importFrom dplyr group_by summarize ungroup n
get_statevars <- function(a_dataset) {
  a_dataset <- a_dataset %>%
    dplyr::group_by(site, dat, singletons, sim, source) %>%
    dplyr::summarize(s0 = n(),
                     n0 = sum(abund)) %>%
    dplyr::ungroup()
}

#' Prepare MACDB for pipeline
#'
#' @param storage_path where to get the data
#' @param save defaults TRUE
#'
#' @return nothing
#' @export
#'
#' @importFrom here here
#' @importFrom dplyr select left_join filter mutate group_by ungroup row_number rename
prep_macdb <- function(storage_path = here::here("working-data", "macdb_data"), save = TRUE) {

  communities <- read.csv(file.path(storage_path, "community_analysis_data.csv"), stringsAsFactors = F)
  experiments <- read.csv(file.path(storage_path, "experiments_analysis_data.csv"), stringsAsFactors = F)

  communities <- dplyr::select(communities, -referenceID) %>%
    dplyr::left_join(experiments, by = "siteID")

  communities <- communities %>%
    dplyr::filter(raw_abundance == 1) %>%
    dplyr::select(siteID, abundance) %>%
    dplyr::group_by(siteID) %>%
    dplyr::mutate(species = dplyr::row_number()) %>%
    dplyr::ungroup() %>%
    dplyr::rename(site = siteID, abund = abundance) %>%
    dplyr::mutate(year = NA) %>%
    dplyr::select(site, year, species, abund)

  write.csv(communities, here::here("working-data", "abund_data", "macdb_spab.csv"), row.names = F)

}
