# This is a script to generate the P table to sample very large communities. RMD ran this on the hipergator once and then reuses the saved P table.

library(drake)
library(scadsanalysis)
library(ggplot2)

mp_tall = feasiblesads::fill_ps(max_s = 200, max_n = 40720,
                                storeyn = FALSE)

saveRDS(mp_tall, file = "analysis/masterp_tall.Rds")
