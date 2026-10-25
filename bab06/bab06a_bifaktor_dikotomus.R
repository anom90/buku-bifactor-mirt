# ============================================================
# Bab 6.2 Model bifaktor untuk respons dikotomus
# Buku : Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Data : kasus1_2pl_matematika.xlsx, kasus1_3pl_matematika.xlsx,
#        kasus1_rasch_matematika.xlsx (data simulasi)
# R 4.6.1; mirt 1.48; openxlsx 4.2.8.1
# ============================================================

# Jalankan paket R
library(openxlsx)                                    #6.2_1
library(mirt)                                        #6.2_2

# Panggil data
data <- read.xlsx("kasus1_2pl_matematika.xlsx",
                  sheet = 1)                         #6.2_3
butir <- data[, -1]                                  #6.2_4
dim(butir)                                           #6.2_5

# Model 2PL bifaktor
spesifik <- c(rep(1, 7), rep(2, 7), rep(3, 7))       #6.2_6
mod.2pl <- bfactor(butir, model = spesifik,
                   SE = TRUE, verbose = FALSE)       #6.2_7
mod.2pl                                              #6.2_8
extract.mirt(mod.2pl, what = "time")                 #6.2_9
coef(mod.2pl, simplify = TRUE)                       #6.2_10
round(coef(mod.2pl, printSE = TRUE)$ALJ1, 3)        #6.2_11
skor <- fscores(mod.2pl, method = "EAP",
                full.scores = TRUE,
                full.scores.SE = TRUE, QMC = TRUE)   #6.2_12
head(round(skor, 3))                                 #6.2_13

# Model 3PL bifaktor (asimtot bawah ditetapkan 0,20)
data3 <- read.xlsx("kasus1_3pl_matematika.xlsx",
                   sheet = 1)                        #6.2_14
butir3 <- data3[, -1]                                #6.2_15
mod.3pl <- bfactor(butir3, model = spesifik,
                   guess = 0.20, SE = TRUE,
                   verbose = FALSE)                  #6.2_16
mod.3pl                                              #6.2_17
coef(mod.3pl, simplify = TRUE)                       #6.2_18

# Model Rasch bifaktor
datar <- read.xlsx("kasus1_rasch_matematika.xlsx",
                   sheet = 1)                        #6.2_19
butirr <- datar[, -1]                                #6.2_20
kendala.rasch <- "G = 1-21
  START = (1-21, a1, 1.0)
  START = (1-7, a2, 1.0)
  START = (8-14, a3, 1.0)
  START = (15-21, a4, 1.0)
  FIXED = (1-21, a1)
  FIXED = (1-7, a2)
  FIXED = (8-14, a3)
  FIXED = (15-21, a4)
  FREE  = (GROUP, COV_11)
  FREE  = (GROUP, COV_22)
  FREE  = (GROUP, COV_33)
  FREE  = (GROUP, COV_44)"                           #6.2_21
mod.rasch <- bfactor(butirr, model = spesifik,
                     model2 = kendala.rasch,
                     SE = TRUE, verbose = FALSE)     #6.2_22
mod.rasch                                            #6.2_23
coef(mod.rasch, simplify = TRUE)                     #6.2_24

# Model 1PL bifaktor
kendala.1pl <- "G = 1-21
  CONSTRAIN = (1-21, a1)
  CONSTRAIN = (1-7, a2)
  CONSTRAIN = (8-14, a3)
  CONSTRAIN = (15-21, a4)"                           #6.2_25
mod.1pl <- bfactor(butirr, model = spesifik,
                   model2 = kendala.1pl,
                   SE = TRUE, verbose = FALSE)       #6.2_26
mod.1pl                                              #6.2_27
round(coef(mod.1pl, simplify = TRUE)$items[c(1, 8, 15), ],
      3)                                             #6.2_28

# Catat versi R dan paket
sessionInfo()
