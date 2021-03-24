context("Check dissimilarity to CT")

test_that("compare_props_off works", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site == "1001")

  set.seed(1)
  fs_samples <- sample_fs_wrapper(dat, site_name = "1001", singletons = F, n_samples = 5, p_table = NULL)

  fs_diffs <- compare_props_fs(fs_samples)

  fs_diffs_one <- compare_props_off_full(1, fs_samples, ncomps = 400)

  expect_true(dplyr::filter(fs_diffs, focal_sim == 1)$mean_po_comparison == mean(fs_diffs_one$prop_off))
  expect_true(nrow(fs_diffs_one) == 4)

  fs_diffs_true <- compare_props_off_full(-99, fs_samples)
  expect_true(nrow(fs_diffs_true) == 5)
  expect_true(dplyr::filter(fs_diffs, focal_sim == -99)$mean_po_comparison == mean(fs_diffs_true$prop_off))

  fs_diffs_one_sim <- compare_props_off_full(1, dplyr::filter(fs_samples, sim == 1))

  fs_diffs_one_true <- compare_props_off_full(-99, dplyr::filter(fs_samples, sim < 2))

  fs_diffs_too_small <- compare_props_fs(dplyr::filter(fs_samples, sim <2))

  expect_true(is.na(fs_diffs_one_sim$prop_off))
  expect_true(is.na(fs_diffs_too_small$mean_po_comparison[1]))
  expect_true(fs_diffs_too_small$mean_po_comparison[2] == fs_diffs_one_true$prop_off)
  expect_true(all(fs_diffs_too_small$n_po_comparisons == c(0,1)))


  })

test_that("identifying ct works", {

  dat <- load_dataset("mcdb")
  dat <- dat %>%
    dplyr::filter(site == "1001")

  set.seed(1)
  fs_samples <- sample_fs_wrapper(dat, site_name = "1001", singletons = F, n_samples = 5, p_table = NULL)

  fs_diffs <- compare_props_fs(fs_samples)

  ct <- po_central_tendency(fs_samples, fs_diffs)

  expect_true(ct$best_po_sim == fs_diffs$focal_sim[ which(fs_diffs$mean_po_comparison == min(fs_diffs$mean_po_comparison))])

  ct_pos <- compare_props_off_full(ct$best_po_sim, fs_samples, ncomps = length(unique(fs_samples$sim)) - 2) %>%
    dplyr::distinct()

  expect_true(ct$sim_pos_from_best == mean(ct_pos$prop_off))

  # make the "observed" the central tendency instead

  fs_sim <- fs_samples %>%
    dplyr::filter(sim == 2)


  fs_samples_observed <- fs_samples %>%
    dplyr::filter(source == "observed") %>%
    dplyr::mutate(rank = fs_sim$rank,
                  abund = fs_sim$abund)

  fs_samples <- fs_samples %>%
    dplyr::filter(source != "observed") %>%
    dplyr::bind_rows(fs_samples_observed)

  fs_diffs <- compare_props_fs(fs_samples)

  ct <- po_central_tendency(fs_samples, fs_diffs)

  expect_true(ct$best_po_sim == fs_diffs$focal_sim[ which(fs_diffs$mean_po_comparison == min(dplyr::filter(fs_diffs, focal_sim > 0)$mean_po_comparison))])

  ct_pos <- compare_props_off_full(ct$best_po_sim, fs_samples, ncomps = length(unique(fs_samples$sim)) - 2) %>%
    dplyr::distinct()

  expect_true(ct$sim_pos_from_best == mean(ct_pos$prop_off))
  })
