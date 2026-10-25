# ============================================================
# Bab 11 Model orde kedua dan model bifaktor tidak lengkap
# Buku : Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Data : kasus2_grm_efikasi.xlsx (Kasus 2, N = 1.821)
#        kasus3_efikasidiri.xlsx (Kasus 3, desain ESES, N = 203)
#        (data simulasi)
# R 4.6.1; mirt 1.48; openxlsx 4.2.8.1;
# BifactorIndicesCalculator 0.2.2
# Jalankan: Rscript bab11_orde_kedua_tidak_lengkap.R >
#           log_bab11_orde_kedua_tidak_lengkap.txt 2>&1
# ============================================================

options(width = 72)

# Jalankan paket R
library(openxlsx)                                    #11.5_1
library(mirt)                                        #11.5_2
library(BifactorIndicesCalculator)                   #11.5_3

# ---------- Kasus 2: bifaktor vs orde kedua ----------
# Panggil data
data <- read.xlsx("kasus2_grm_efikasi.xlsx",
                  sheet = 1)                         #11.5_4
butir <- data[, -1]                                  #11.5_5

# Spesifikasi model
spesifik <- rep(1:4, each = 6)                       #11.5_6
kendala <- paste0("(", 1:24, ", a1, a",
                  spesifik + 1, ")",
                  collapse = ", ")                   #11.5_7
spek.ord2 <- mirt.model(paste0("G = 1-24\n",
                               "CONSTRAIN = ",
                               kendala))             #11.5_8
nilai <- bfactor(butir, model = spesifik,
                 model2 = spek.ord2,
                 pars = "values")                    #11.5_9
nilai$est[nilai$name %in% c("COV_22", "COV_33",
                            "COV_44", "COV_55")] <- TRUE #11.5_10

# Estimasi
mod.bif <- bfactor(butir, model = spesifik,
                   verbose = FALSE)                  #11.5_11
mod.ord2 <- bfactor(butir, model = spesifik,
                    model2 = spek.ord2,
                    pars = nilai,
                    verbose = FALSE)                 #11.5_12

# Membaca output
extract.mirt(mod.ord2, "converged")                  #11.5_13
anova(mod.ord2, mod.bif)                             #11.5_14
koef <- coef(mod.bif, simplify = TRUE)$items         #11.5_15
rasio <- rowSums(koef[, 2:5]) / koef[, 1]            #11.5_16
round(rasio, 2)                                      #11.5_17
varS <- diag(coef(mod.ord2, simplify = TRUE)$cov)[-1] #11.5_18
round(varS, 3)                                       #11.5_19
round(1 / sqrt(1 + varS), 3)                         #11.5_20

# ---------- Kasus 3: faktor spesifik yang runtuh ----------
# Panggil data
data3 <- read.xlsx("kasus3_efikasidiri.xlsx",
                   sheet = 1)                        #11.5_21
butir3 <- data3[, -1]                                #11.5_22

# Spesifikasi model dan estimasi: bifaktor lengkap
spesifik3 <- rep(1:4, each = 3)                      #11.5_23
mod.bif3 <- bfactor(butir3, model = spesifik3,
                    verbose = FALSE,
                    technical = list(NCYCLES = 3000)) #11.5_24
set.seed(5)                                          #11.5_25
mod.mhrm3 <- mirt(butir3, model = "G = 1-12
                  S1 = 1-3
                  S2 = 4-6
                  S3 = 7-9
                  S4 = 10-12", method = "MHRM",
                  verbose = FALSE)                   #11.5_26

# Membaca output: omega hierarkis subskala dua solusi
ind.em <- bifactorIndices(summary(mod.bif3,
                          verbose = FALSE)$rotF)     #11.5_27
ind.mhrm <- bifactorIndices(summary(mod.mhrm3,
                            verbose = FALSE)$rotF)   #11.5_28
round(cbind(EM = ind.em$FactorLevelIndices[,
                 c("OmegaH", "H")],
            MHRM = ind.mhrm$FactorLevelIndices[,
                   c("OmegaH", "H")]), 3)            #11.5_29

# Spesifikasi model dan estimasi: bifaktor tidak lengkap
spesifik.tl <- c(NA, NA, NA, rep(1:3, each = 3))     #11.5_30
mod.tl <- bfactor(butir3, model = spesifik.tl,
                  verbose = FALSE)                   #11.5_31
mod.uni3 <- mirt(butir3, 1, verbose = FALSE)         #11.5_32

# Membaca output
extract.mirt(mod.tl, "converged")                    #11.5_33
ind.tl <- bifactorIndices(summary(mod.tl,
                          verbose = FALSE)$rotF)     #11.5_34
round(ind.tl$FactorLevelIndices, 3)                  #11.5_35
anova(mod.uni3, mod.tl)                              #11.5_36

# Spesifikasi model dan estimasi: orde kedua tidak lengkap
kendala.tl <- paste0("(", 4:12, ", a1, a",
                     spesifik.tl[4:12] + 1, ")")     #11.5_37
noquote(kendala.tl)                                  #11.5_38
spek.tl <- mirt.model(paste0("G = 1-12\n",
                             "CONSTRAIN = ",
                             paste(kendala.tl,
                                   collapse = ", "))) #11.5_39
nilai.tl <- bfactor(butir3, model = spesifik.tl,
                    model2 = spek.tl,
                    pars = "values")                 #11.5_40
nilai.tl$est[nilai.tl$name %in% c("COV_22", "COV_33",
                                  "COV_44")] <- TRUE #11.5_41
mod.o2.tl <- bfactor(butir3, model = spesifik.tl,
                     model2 = spek.tl,
                     pars = nilai.tl,
                     verbose = FALSE)                #11.5_42

# Membaca output
anova(mod.o2.tl, mod.tl)                             #11.5_43
varS.tl <- diag(coef(mod.o2.tl,
                     simplify = TRUE)$cov)[-1]       #11.5_44
round(1 / sqrt(1 + varS.tl), 3)                      #11.5_45
M2(mod.tl, type = "C2", QMC = TRUE)                  #11.5_46
M2(mod.o2.tl, type = "C2", QMC = TRUE)               #11.5_47

sessionInfo()
