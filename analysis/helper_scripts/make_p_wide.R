
mp_wide = feasiblesads::fill_ps(max_s = 910,
                                max_n = 3510,
                                storeyn = FALSE)

saveRDS(mp_wide, file = here::here("analysis", "masterp_wide.Rds"))
