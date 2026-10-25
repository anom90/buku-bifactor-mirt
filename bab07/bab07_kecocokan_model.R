# ============================================================
# Bab 7 Kecocokan dan perbandingan model
# Buku : Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Data : kasus1_2pl_matematika.xlsx (data simulasi)
# R 4.6.1; mirt 1.48; openxlsx 4.2.8.1
# ============================================================

# Jalankan paket R dan panggil data
library(openxlsx)                                    #7.7_1
library(mirt)                                        #7.7_2
data <- read.xlsx("kasus1_2pl_matematika.xlsx",
                  sheet = 1)                         #7.7_3
butir <- data[, -1]                                  #7.7_4

# Spesifikasi model
spesifik <- c(rep(1, 7), rep(2, 7), rep(3, 7))       #7.7_5
model.kor <- "ALJ = 1-7
              GEO = 8-14
              TRG = 15-21
              COV = ALJ*GEO*TRG"                     #7.7_6

# Estimasi model
mod.uni <- mirt(butir, 1, verbose = FALSE)           #7.7_7
mod.kor <- mirt(butir, model.kor,
                verbose = FALSE)                     #7.7_8
mod.bif <- bfactor(butir, model = spesifik,
                   verbose = FALSE)                  #7.7_9

# Kecocokan relatif
anova(mod.uni, mod.bif)                              #7.7_10
anova(mod.uni, mod.kor)                              #7.7_11
anova(mod.kor, mod.bif)                              #7.7_12
round(summary(mod.kor, verbose = FALSE)$fcor, 3)     #7.7_13

# Kecocokan absolut
M2(mod.uni)                                          #7.7_14
M2(mod.kor)                                          #7.7_15
M2(mod.bif, QMC = TRUE)                              #7.7_16

# Kecocokan butir
fit.butir <- itemfit(mod.bif, QMC = TRUE,
                     p.adjust = "BH")                #7.7_17
fit.butir                                            #7.7_18

# Catat versi R dan paket
sessionInfo()
