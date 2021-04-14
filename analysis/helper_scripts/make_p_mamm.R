
mp_mamm = feasiblesads::fill_ps(max_s = 62, max_n = 10100,
                                storeyn = FALSE)

saveRDS(mp_mamm, file = here::here("analysis", "masterp_mamm.Rds"))
