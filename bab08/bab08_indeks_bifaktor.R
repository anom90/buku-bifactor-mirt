# ============================================================
# Bab 8 Indeks evaluasi model bifaktor
# Buku : Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Data : kasus1_2pl_matematika.xlsx, kasus2_grm_efikasi.xlsx
#        (data simulasi)
# R 4.6.1; mirt 1.48; openxlsx 4.2.8.1;
# BifactorIndicesCalculator 0.2.2
# ============================================================

# Jalankan paket R
library(openxlsx)                                    #8.7_1
library(mirt)                                        #8.7_2
library(BifactorIndicesCalculator)                   #8.7_3

# Kasus 1: tes matematika (2PL bifaktor)
data <- read.xlsx("kasus1_2pl_matematika.xlsx",
                  sheet = 1)                         #8.7_4
butir <- data[, -1]                                  #8.7_5
spesifik <- c(rep(1, 7), rep(2, 7), rep(3, 7))       #8.7_6
mod.bif <- bfactor(butir, model = spesifik,
                   verbose = FALSE)                  #8.7_7
mod.uni <- mirt(butir, 1, verbose = FALSE)           #8.7_8

# Indeks bifaktor
indeks <- bifactorIndices(mod.bif,
                          UniLambda = mod.uni)       #8.7_9
round(indeks$ModelLevelIndices, 3)                   #8.7_10
round(indeks$FactorLevelIndices, 3)                  #8.7_11
round(indeks$ItemLevelIndices, 3)                    #8.7_12

# Omega untuk skor jumlah butir kategorik
koef <- coef(mod.bif, simplify = TRUE)$items         #8.7_13
a <- koef[, grep("^a", colnames(koef))]              #8.7_14
d <- koef[, grep("^d", colnames(koef)),
          drop = FALSE]                              #8.7_15
penyebut <- sqrt(1.702^2 + rowSums(a^2))             #8.7_16
Lambda <- a / penyebut                               #8.7_17
colnames(Lambda) <- c("G", "S1", "S2", "S3")         #8.7_18
ambang <- split(-d / penyebut, row(d))               #8.7_19
indeks.kat <- bifactorIndices(Lambda,
                              Thresh = ambang)       #8.7_20
round(indeks.kat$FactorLevelIndices[,
      c("Omega", "OmegaH")], 3)                      #8.7_21

# Kasus 2: angket efikasi diri berbicara (GRM bifaktor)
data2 <- read.xlsx("kasus2_grm_efikasi.xlsx",
                   sheet = 1)                        #8.7_22
butir2 <- data2[, -1]                                #8.7_23
spesifik2 <- c(rep(1, 6), rep(2, 6),
               rep(3, 6), rep(4, 6))                 #8.7_24
mod.grm <- bfactor(butir2, model = spesifik2,
                   verbose = FALSE)                  #8.7_25
mod.grm.uni <- mirt(butir2, 1, verbose = FALSE)      #8.7_26
indeks2 <- bifactorIndices(mod.grm,
                           UniLambda = mod.grm.uni)  #8.7_27
round(indeks2$ModelLevelIndices, 3)                  #8.7_28
round(indeks2$FactorLevelIndices, 3)                 #8.7_29
koef2 <- coef(mod.grm, simplify = TRUE)$items        #8.7_30
a2 <- koef2[, grep("^a", colnames(koef2))]           #8.7_31
d2 <- koef2[, grep("^d", colnames(koef2))]           #8.7_32
penyebut2 <- sqrt(1.702^2 + rowSums(a2^2))           #8.7_33
Lambda2 <- a2 / penyebut2                            #8.7_34
colnames(Lambda2) <- c("G", "S1", "S2", "S3", "S4")  #8.7_35
ambang2 <- split(-d2 / penyebut2, row(d2))           #8.7_36
indeks2.kat <- bifactorIndices(Lambda2,
                               Thresh = ambang2)     #8.7_37
round(indeks2.kat$FactorLevelIndices[,
      c("Omega", "OmegaH")], 3)                      #8.7_38

# Catat versi R dan paket
sessionInfo()
