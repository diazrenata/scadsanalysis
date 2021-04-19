#' Download and filter SAD data
#'
#' Downloads processed SAD data directly from the GitHub repo for White et al (2012) and figshare for Baldridge et al (2014), or copies pre-downloaded copies of these data that are included in the compenidum. These copies were downloaded in 2019 and the raw files are unedited.
#'
#' Also downloads a pre-processed version of the Portal plants data. These data were used by RMD for methods development, but not included in the final analysis because they differ from the other datasets in sampling - the Portal plants are repeated re-sampling of the same plots twice a year for 40 years, and may not be comparable to surveys of numerous independent communities.
#'
#' Then filters the raw datasets to the specifications for this analysis. For the Miscellaneous Abundance Database, this is filtering out communities with S >= 200 or N >= 40720, because these are too large to sample efficiently. We split the main FIA database into two subsets: those with fewer than 10 species (approximately 90,000 sites) and those with more than 10 species. We retain all sites with >= 10 species (a total of 10355). It creates memory problems to try and run all of the small communities, so we randomly selected 10,000 sites. We drew the 10,000 from the subset of sites with between 3 and 9 species, because a considerable proportion have fewer than 3 (26,667/92,988), and this analysis is poorly suited to SADs with only 1 or 2 species. We do not filter any of the other datasets, because they have S and N within the range we can sample effectively and they do not have as many different sites as FIA.
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
    filter_fia_small(storage_path = file.path(storage_path, "abund_data"))

  } else {
    file.copy(inst_path, storage_path, recursive = T)

    filter_miscabund(storage_path = file.path(storage_path, "abund_data"))
    filter_fia(storage_path = file.path(storage_path, "abund_data"))
    filter_fia_small(storage_path = file.path(storage_path, "abund_data"))

  }
}


#'
#' #' Download and preprocess Portal plants
#' #'
#' #' Download Portal plant data and process it. This includes reformatting and removing 4 sampling periods with very large values for S and N.
#' #'
#' #' The Portal plant data were used for methods development, but are not comparable to the datasets used in the actual analysis (because they are site-level records re-sampled over time, and not independent sites sampled once) and are not included in the manuscript.
#' #'
#' #' @param storage_path where to store the data
#' #'
#' #' @return nothing
#' #' @export
#' #'
#' #' @importFrom portalr plant_abundance
#' #' @importFrom dplyr filter select mutate rename bind_rows
#' download_portal_plants <- function(storage_path = here::here("working-data", "abund_data")) {
#'
#'   portal_plants_summer <- portalr::plant_abundance(level = "Treatment", type = "Summer Annuals", plots = "All", unknowns = F, correct_sp = T, shape = "flat", min_quads = 16) %>%
#'     dplyr::filter(treatment == "control") %>%
#'     dplyr::select(year, species, abundance) %>%
#'     dplyr::mutate(site = paste0(year, "_summer"),
#'                   dat = "portal_plants",
#'                   species = as.character(species)) %>%
#'     dplyr::rename(abund = abundance) %>%
#'     dplyr::select(site, year, species, abund) %>%
#'     dplyr::filter(!(year %in% c(1987, 1992, 1989, 1990)))
#'
#'   portal_plants_winter <- portalr::plant_abundance(level = "Treatment", type = "Winter Annuals", plots = "All", unknowns = F, correct_sp = T, shape = "flat", min_quads = 16) %>%
#'     dplyr::filter(treatment == "control") %>%
#'     dplyr::select(year, species, abundance) %>%
#'     dplyr::mutate(site = paste0(year, "_winter"),
#'                   dat = "portal_plants",
#'                   species = as.character(species)) %>%
#'     dplyr::rename(abund = abundance) %>%
#'     dplyr::select(site, year, species, abund) %>%
#'     dplyr::filter(!(year %in% c(1987, 1992, 1993, 1989, 1984)))
#'
#'   portal_plants <- dplyr::bind_rows(portal_plants_summer, portal_plants_winter)
#'
#'   write.csv(portal_plants, file = file.path(storage_path, "portal_plants_spab.csv"), row.names = F)
#'
#' }
#' #'
#' #' #' Download MACDB data
#' #' #'
#' #' #' This function is not included in the final analysis.
#' #' #'
#' #' #' @param from_url defaults FALSE. If true, from figshare. Otherwise, loads data from storage internal to the package
#' #' #' @param storage_path where to put the data. Defaults to working-data/macdb_data.
#' #' #'
#' #' #' @return nothing
#' #' #' @export
#' #' #'
#' #' #' @importFrom here here
#' #' download_macdb <- function(from_url = FALSE, storage_path = here::here("working-data")) {
#' #'
#' #'   inst_path = file.path(system.file(package= "scadsanalysis"), "macdb_data")
#' #'
#' #'   if(!dir.exists(file.path(storage_path))) {
#' #'     dir.create(file.path(storage_path), recursive = T)
#' #'   }
#' #'
#' #'   if(from_url) {
#' #'
#' #'     if(!dir.exists(file.path(storage_path, "macdb_data"))) {
#' #'       dir.create(file.path(storage_path, "macdb_data"))
#' #'     }
#' #'
#' #'     download.file(url = "https://ndownloader.figshare.com/files/3156878", destfile = file.path(storage_path,"macdb_data", "community_analysis_data.csv"))
#' #'
#' #'     download.file(url = "https://ndownloader.figshare.com/files/3156887", destfile = file.path(storage_path,"macdb_data", "orderedcomparisons.csv"))
#' #'
#' #'     download.file(url = "https://ndownloader.figshare.com/files/3156893", destfile = file.path(storage_path,"macdb_data", "sites_analysis_data.csv"))
#' #'
#' #'     download.file(url = "https://ndownloader.figshare.com/files/3156884", destfile = file.path(storage_path,"macdb_data", "experiments_analysis_data.csv"))
#' #'
#' #'     download.file(url = "https://ndownloader.figshare.com/files/3156890", destfile = file.path(storage_path,"macdb_data", "ref_analysis_data.csv"))
#' #'
#' #'     download.file(url = "https://ndownloader.figshare.com/files/1429961", destfile = file.path(storage_path,"macdb_data", "MACD_metadata.pdf"))
#' #'
#' #'     prep_macdb()
#' #'   } else {
#' #'     file.copy(inst_path, storage_path, recursive = T)
#' #'   }
#' #' }
#' #'
#' #'
#' #' #' Prepare MACDB for pipeline
#' #' #'
#' #' #' This function is not part of the final analysis.
#' #' #'
#' #' #' @param storage_path where to get the data
#' #' #' @param save defaults TRUE
#' #' #'
#' #' #' @return nothing
#' #' #' @export
#' #' #'
#' #' #' @importFrom here here
#' #' #' @importFrom dplyr select left_join filter mutate group_by ungroup row_number rename
#' #' prep_macdb <- function(storage_path = here::here("working-data", "macdb_data"), save = TRUE) {
#' #'
#' #'   communities <- read.csv(file.path(storage_path, "community_analysis_data.csv"), stringsAsFactors = F)
#' #'   experiments <- read.csv(file.path(storage_path, "experiments_analysis_data.csv"), stringsAsFactors = F)
#' #'
#' #'   communities <- dplyr::select(communities, -referenceID) %>%
#' #'     dplyr::left_join(experiments, by = "siteID")
#' #'
#' #'   communities <- communities %>%
#' #'     dplyr::filter(raw_abundance == 1) %>%
#' #'     dplyr::select(siteID, abundance) %>%
#' #'     dplyr::group_by(siteID) %>%
#' #'     dplyr::mutate(species = dplyr::row_number()) %>%
#' #'     dplyr::ungroup() %>%
#' #'     dplyr::rename(site = siteID, abund = abundance) %>%
#' #'     dplyr::mutate(year = NA) %>%
#' #'     dplyr::select(site, year, species, abund)
#' #'
#' #'   write.csv(communities, here::here("working-data", "abund_data", "macdb_spab.csv"), row.names = F)
#' #'
#' #' }
#' #'
#' #'
#' #' #' Download Portal plants with manipulations
#' #' #'
#' #' #' This function is not included in the final analysis.
#' #' #'
#' #' #' @param storage_path where it goes
#' #' #'
#' #' #' @return nothing
#' #' #' @export
#' #' #'
#' #' #' @importFrom portalr plant_abundance
#' #' #' @importFrom dplyr filter select mutate rename bind_rows n summarize group_by ungroup
#' #' download_portal_plants_manips <- function(storage_path = here::here("working-data", "abund_data")) {
#' #'
#' #'   portal_plants_summer <- portalr::plant_abundance(level = "Plot", type = "Summer Annuals", plots = "All", unknowns = F, correct_sp = T, shape = "flat", min_quads = 16) %>%
#' #'     dplyr::filter(treatment != "spectabs", year >= 1980, year <= 2014) %>%
#' #'     dplyr::select(year, species, abundance, plot, treatment) %>%
#' #'     dplyr::mutate(site = paste0(year, "_", plot, "_", treatment, "_summer"),
#' #'                   dat = "portal_plants_manip",
#' #'                   species = as.character(species)) %>%
#' #'     dplyr::rename(abund = abundance) %>%
#' #'     dplyr::select(site, year, species, abund)
#' #'
#' #'
#' #'   summer_sv_pass <- portal_plants_summer %>%
#' #'     dplyr::group_by(site, year) %>%
#' #'     dplyr::summarize(s0 = dplyr::n(), n0 = sum(abund)) %>%
#' #'     dplyr::ungroup() %>%
#' #'     dplyr::filter(s0 >= 2, n0 >= s0 + 1) %>%
#' #'     dplyr::filter(n0 <= 23000, s0 <= 42)
#' #'
#' #'   portal_plants_summer <- portal_plants_summer %>%
#' #'     dplyr::filter(site %in% summer_sv_pass$site)
#' #'
#' #'   portal_plants_winter <- portalr::plant_abundance(level = "Plot", type = "Winter Annuals", plots = "All", unknowns = F, correct_sp = T, shape = "flat", min_quads = 16) %>%
#' #'     dplyr::filter(treatment != "spectabs", year >= 1980, year <= 2014) %>%
#' #'     dplyr::select(year, species, abundance, plot, treatment) %>%
#' #'     dplyr::mutate(site = paste0(year, "_", plot, "_", treatment, "_winter"),
#' #'                   dat = "portal_plants_manip",
#' #'                   species = as.character(species)) %>%
#' #'     dplyr::rename(abund = abundance) %>%
#' #'     dplyr::select(site, year, species, abund)
#' #'
#' #'
#' #'   winter_sv_pass <- portal_plants_winter %>%
#' #'     dplyr::group_by(site) %>%
#' #'     dplyr::summarize(s0 = dplyr::n(), n0 = sum(abund)) %>%
#' #'     dplyr::ungroup() %>%
#' #'     dplyr::filter(s0 >= 2, n0 >= s0 + 1) %>%
#' #'     dplyr::filter(n0 <= 23000, s0 <= 42)
#' #'
#' #'   portal_plants_winter <- portal_plants_winter %>%
#' #'     dplyr::filter(site %in% winter_sv_pass$site)
#' #'
#' #'
#' #'   portal_plants <- dplyr::bind_rows(portal_plants_summer, portal_plants_winter)
#' #'
#' #'   write.csv(portal_plants, file = file.path(storage_path, "portal_plants_manip_spab.csv"), row.names = F)
#' #'
#' #' }
