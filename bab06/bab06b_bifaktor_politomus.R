# ============================================================
# Bab 6.3 Model bifaktor untuk respons politomus
# Buku : Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Data : kasus2_grm_efikasi.xlsx, kasus2_gpcm_efikasi.xlsx,
#        kasus2_pcm_efikasi.xlsx (data simulasi)
# R 4.6.1; mirt 1.48; openxlsx 4.2.8.1
# ============================================================

# Jalankan paket R
library(openxlsx)                                    #6.3_1
library(mirt)                                        #6.3_2

# Panggil data
data <- read.xlsx("kasus2_grm_efikasi.xlsx", sheet = 1) #6.3_3
butir <- data[, -1]                                  #6.3_4
dim(butir)                                           #6.3_5
apply(butir, 2, table)                               #6.3_6

# Model GRM bifaktor
spesifik <- c(rep(1, 6), rep(2, 6),
              rep(3, 6), rep(4, 6))                  #6.3_7
mod.grm <- bfactor(butir, model = spesifik,
                   SE = TRUE, verbose = FALSE)       #6.3_8
mod.grm                                              #6.3_9
extract.mirt(mod.grm, what = "time")                 #6.3_10
coef(mod.grm, simplify = TRUE)                       #6.3_11
skor <- fscores(mod.grm, method = "EAP",
                full.scores = TRUE,
                full.scores.SE = TRUE, QMC = TRUE)   #6.3_12
head(round(skor, 3))                                 #6.3_13

# Model GPCM bifaktor
data2 <- read.xlsx("kasus2_gpcm_efikasi.xlsx",
                   sheet = 1)                        #6.3_14
butir2 <- data2[, -1]                                #6.3_15
spesifik2 <- c(rep(1, 6), rep(2, 6))                 #6.3_16
mod.gpcm <- bfactor(butir2, model = spesifik2,
                    itemtype = "gpcm", SE = TRUE,
                    verbose = FALSE)                 #6.3_17
mod.gpcm                                             #6.3_18
koef.gpcm <- coef(mod.gpcm, simplify = TRUE)         #6.3_19
round(koef.gpcm$items[, c("a1", "a2", "a3",
                         "d1", "d2", "d3")], 3)     #6.3_20

# Model PCM bifaktor
data3 <- read.xlsx("kasus2_pcm_efikasi.xlsx",
                   sheet = 1)                        #6.3_21
butir3 <- data3[, -1]                                #6.3_22
kendala.pcm <- "G = 1-12
  START = (1-12, a1, 1.0)
  START = (1-6, a2, 1.0)
  START = (7-12, a3, 1.0)
  FIXED = (1-12, a1)
  FIXED = (1-6, a2)
  FIXED = (7-12, a3)
  FREE  = (GROUP, COV_11)
  FREE  = (GROUP, COV_22)
  FREE  = (GROUP, COV_33)"                           #6.3_23
mod.pcm <- bfactor(butir3, model = spesifik2,
                   model2 = kendala.pcm,
                   itemtype = "gpcm", SE = TRUE,
                   verbose = FALSE)                  #6.3_24
mod.pcm                                              #6.3_25
koef.pcm <- coef(mod.pcm, simplify = TRUE)           #6.3_26
round(koef.pcm$items[, c("d1", "d2", "d3")], 3)      #6.3_27
round(koef.pcm$cov, 3)                               #6.3_28

# Catat versi R dan paket
sessionInfo()
