library(drake)
library(scadsanalysis)
library(ggplot2)

mp_tall = feasiblesads::fill_ps(max_s = 200, max_n = 40720,
                                storeyn = FALSE)

saveRDS(mp_tall, file = "analysis/ptall.Rds")
