#' Download SAD data
#'
#' @param from_url defaults FALSE. If true, downloads White/Baldridge data directly from GitHub and figshare. Otherwise, loads data from storage internal to the package
#' @param storage_path where to put the data. Defaults to working-data/data.
#'
#' @return nothing
#' @export
#'
#' @importFrom here here
download_data <- function(from_url = FALSE, storage_path = here::here("working-data")) {

  inst_path = file.path(system.file(package= "scadsanalysis"), "abund_data")

  if(!dir.exists(file.path(storage_path))) {
    dir.create(file.path(storage_path), recursive = T)
  }

  if(from_url) {

    if(!dir.exists(file.path(storage_path, "abund_data"))) {
      dir.create(file.path(storage_path, "abund_data"))
    }

    download.file(url = "https://raw.githubusercontent.com/weecology/sad-comparison/master/sad-data/mcdb_spab.csv", destfile = file.path(storage_path,"abund_data", "mcdb_spab.csv"))

    download.file(url = "https://raw.githubusercontent.com/weecology/sad-comparison/master/sad-data/bbs_spab.csv", destfile = file.path(storage_path, "abund_data","bbs_spab.csv"))

    download.file(url = "https://raw.githubusercontent.com/weecology/sad-comparison/master/sad-data/gentry_spab.csv", destfile = file.path(storage_path, "abund_data","gentry_spab.csv"))

    download.file(url = "https://raw.githubusercontent.com/weecology/sad-comparison/master/sad-data/fia_spab.csv", destfile = file.path(storage_path, "abund_data","fia_spab.csv"))

    download.file(url = "https://ndownloader.figshare.com/files/3097079", destfile = file.path(storage_path,"abund_data", "misc_abund_spab.csv"))

    download_portal_plants(storage_path = file.path(storage_path, "abund_data"))

    filter_miscabund(storage_path = file.path(storage_path, "abund_data"))
    filter_fia(storage_path = file.path(storage_path, "abund_data"))

  } else {
    file.copy(inst_path, storage_path, recursive = T)

    filter_miscabund(storage_path = file.path(storage_path, "abund_data"))
    filter_fia(storage_path = file.path(storage_path, "abund_data"))
  }
}



#' Download Portal plants
#'
#' @param storage_path where it goes
#'
#' @return nothing
#' @export
#'
#' @importFrom portalr plant_abundance
#' @importFrom dplyr filter select mutate rename bind_rows
download_portal_plants <- function(storage_path = here::here("working-data", "abund_data")) {

  portal_plants_summer <- portalr::plant_abundance(level = "Treatment", type = "Summer Annuals", plots = "All", unknowns = F, correct_sp = T, shape = "flat", min_quads = 16) %>%
    dplyr::filter(treatment == "control") %>%
    dplyr::select(year, species, abundance) %>%
    dplyr::mutate(site = paste0(year, "_summer"),
                  dat = "portal_plants",
                  species = as.character(species)) %>%
    dplyr::rename(abund = abundance) %>%
    dplyr::select(site, year, species, abund) %>%
    dplyr::filter(!(year %in% c(1987, 1992, 1989, 1990)))

  portal_plants_winter <- portalr::plant_abundance(level = "Treatment", type = "Winter Annuals", plots = "All", unknowns = F, correct_sp = T, shape = "flat", min_quads = 16) %>%
    dplyr::filter(treatment == "control") %>%
    dplyr::select(year, species, abundance) %>%
    dplyr::mutate(site = paste0(year, "_winter"),
                  dat = "portal_plants",
                  species = as.character(species)) %>%
    dplyr::rename(abund = abundance) %>%
    dplyr::select(site, year, species, abund) %>%
    dplyr::filter(!(year %in% c(1987, 1992, 1993, 1989, 1984)))

  portal_plants <- dplyr::bind_rows(portal_plants_summer, portal_plants_winter)

  write.csv(portal_plants, file = file.path(storage_path, "portal_plants_spab.csv"), row.names = F)

}

#' Download MACDB data
#'
#' @param from_url defaults FALSE. If true, from figshare. Otherwise, loads data from storage internal to the package
#' @param storage_path where to put the data. Defaults to working-data/macdb_data.
#'
#' @return nothing
#' @export
#'
#' @importFrom here here
download_macdb <- function(from_url = FALSE, storage_path = here::here("working-data")) {

  inst_path = file.path(system.file(package= "scadsanalysis"), "macdb_data")

  if(!dir.exists(file.path(storage_path))) {
    dir.create(file.path(storage_path), recursive = T)
  }

  if(from_url) {

    if(!dir.exists(file.path(storage_path, "macdb_data"))) {
      dir.create(file.path(storage_path, "macdb_data"))
    }

    download.file(url = "https://ndownloader.figshare.com/files/3156878", destfile = file.path(storage_path,"macdb_data", "community_analysis_data.csv"))

    download.file(url = "https://ndownloader.figshare.com/files/3156887", destfile = file.path(storage_path,"macdb_data", "orderedcomparisons.csv"))

    download.file(url = "https://ndownloader.figshare.com/files/3156893", destfile = file.path(storage_path,"macdb_data", "sites_analysis_data.csv"))

    download.file(url = "https://ndownloader.figshare.com/files/3156884", destfile = file.path(storage_path,"macdb_data", "experiments_analysis_data.csv"))

    download.file(url = "https://ndownloader.figshare.com/files/3156890", destfile = file.path(storage_path,"macdb_data", "ref_analysis_data.csv"))

    download.file(url = "https://ndownloader.figshare.com/files/1429961", destfile = file.path(storage_path,"macdb_data", "MACD_metadata.pdf"))


  } else {
    file.copy(inst_path, storage_path, recursive = T)
  }
}
