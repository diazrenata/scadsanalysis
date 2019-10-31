#' Download SAD data
#'
#' @param from_url defaults FALSE. If true, downloads White/Baldridge data directly from GitHub and figshare. Otherwise, loads data from storage internal to the package
#' @param storage_path where to put the data. Defaults to working-data/data.
#'
#' @return nothing
#' @export
#'
#' @importFrom here here
download_data <- function(from_url = FALSE, storage_path = here::here("working-data", "paper")) {

  inst_path = file.path(system.file(package= "scadsanalysis"), "data")

  if(!dir.exists(file.path(storage_path))) {
    dir.create(file.path(storage_path), recursive = T)
  }

  if(from_url) {

    download.file(url = "https://raw.githubusercontent.com/weecology/sad-comparison/master/sad-data/mcdb_spab.csv", destfile = file.path(storage_path, "mcdb_spab.csv"))

    download.file(url = "https://raw.githubusercontent.com/weecology/sad-comparison/master/sad-data/bbs_spab.csv", destfile = file.path(storage_path, "bbs_spab.csv"))

    download.file(url = "https://raw.githubusercontent.com/weecology/sad-comparison/master/sad-data/gentry_spab.csv", destfile = file.path(storage_path, "gentry_spab.csv"))

    download.file(url = "https://raw.githubusercontent.com/weecology/sad-comparison/master/sad-data/fia_spab.csv", destfile = file.path(storage_path, "fia_spab.csv"))

    download.file(url = "https://ndownloader.figshare.com/files/3097079", destfile = file.path(storage_path, "misc_abund_spab.csv"))

  } else {
    file.copy(inst_path, storage_path, recursive = T)
  }
}

#' Load a dataset
#'
#' @param dataset_name "bbs", "fia", "gentry", "mcdb", or "misc_abund"
#' @param storage_path where the data is living
#'
#' @return something
#' @export
#'
load_dataset <- function(dataset_name, storage_path = here::here("working-data", "paper")) {

  dataset_path = file.path(storage_path, paste0(dataset_name, "_spab.csv"))

  if(dataset_name != "misc_abund") {
    dataset <- read.csv(dataset_path, stringsAsFactors = F, header = F, skip = 2)

    colnames(dataset) <- c("site", "year", "species", "abund")
  } else {
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
    dplyr::arrange(abund) %>%
    dplyr::mutate(rank = dplyr::row_number()) %>%
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
list_sites <- function(dataset_name, storage_path = here::here("working-data", "paper")) {

  dataset_path = file.path(storage_path, paste0(dataset_name, "_spab.csv"))

  if(dataset_name != "misc_abund") {
    dataset <- read.csv(dataset_path, stringsAsFactors = F, header = F, skip = 2)

    colnames(dataset) <- c("site", "year", "species", "abund")
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
