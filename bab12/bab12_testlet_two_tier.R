# ============================================================
# Bab 12 Model testlet dan model two-tier
# Buku : Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Data : kasus4_testlet_matematika.xlsx (Kasus 4, desain DeMars 2006, N = 2.000)
#        kasus5_twotier_pisa.xlsx (Kasus 5, struktur PISA Cai 2010, N = 3.000)
#        (data simulasi)
# R 4.6.1; mirt 1.48; openxlsx 4.2.8.1
# Jalankan: Rscript bab12_testlet_two_tier.R >
#           log_bab12_testlet_two_tier.txt 2>&1
# ============================================================

options(width = 72)

# Jalankan paket R
library(openxlsx)                                    #12.5_1
library(mirt)                                        #12.5_2

# ---------- Kasus 4: model testlet ----------
# Panggil data
data <- read.xlsx("kasus4_testlet_matematika.xlsx",
                  sheet = 1)                         #12.5_3
butir <- data[, -1]                                  #12.5_4
spesifik <- rep(1:5, each = 5)                       #12.5_5

# Spesifikasi model
kendala <- paste0("(", 1:25, ", a1, a",
                  spesifik + 1, ")",
                  collapse = ", ")                   #12.5_6
spek.tl <- mirt.model(paste0("G = 1-25\n",
                             "CONSTRAIN = ", kendala, "\n",
                             "FREE = (GROUP, COV_22), (GROUP, COV_33),",
                             " (GROUP, COV_44), (GROUP, COV_55),",
                             " (GROUP, COV_66)"))    #12.5_7
spek.rasch <- "G = 1-25
  START = (1-25, a1, 1.0), (1-5, a2, 1.0), (6-10, a3, 1.0)
  START = (11-15, a4, 1.0), (16-20, a5, 1.0), (21-25, a6, 1.0)
  FIXED = (1-25, a1), (1-5, a2), (6-10, a3)
  FIXED = (11-15, a4), (16-20, a5), (21-25, a6)
  FREE  = (GROUP, COV_11), (GROUP, COV_22), (GROUP, COV_33)
  FREE  = (GROUP, COV_44), (GROUP, COV_55), (GROUP, COV_66)" #12.5_8

# Estimasi
mod.uni <- mirt(butir, 1, verbose = FALSE)           #12.5_9
mod.rtl <- bfactor(butir, model = spesifik,
                   model2 = spek.rasch,
                   verbose = FALSE,
                   technical = list(NCYCLES = 3000)) #12.5_10
mod.tl <- bfactor(butir, model = spesifik,
                  model2 = spek.tl,
                  verbose = FALSE)                   #12.5_11
mod.bif <- bfactor(butir, model = spesifik,
                   verbose = FALSE,
                   technical = list(NCYCLES = 3000)) #12.5_12

# Membaca output: dependensi lokal dan perbandingan model
q3 <- residuals(mod.uni, type = "Q3",
                verbose = FALSE)                     #12.5_13
round(q3[1:5, 1:5], 2)                               #12.5_14
round(q3[21:25, 21:25], 2)                           #12.5_15
sapply(list(mod.uni, mod.rtl, mod.tl, mod.bif),
       extract.mirt, "converged")                    #12.5_16
anova(mod.uni, mod.tl)                               #12.5_17
anova(mod.rtl, mod.tl)                               #12.5_18
anova(mod.tl, mod.bif)                               #12.5_19

# Membaca output: varians efek testlet
round(diag(coef(mod.tl, simplify = TRUE)$cov), 3)    #12.5_20
round(diag(coef(mod.rtl, simplify = TRUE)$cov), 3)   #12.5_21

# Membaca output: akibat mengabaikan testlet
sejati <- read.xlsx("kasus4_testlet_matematika_sejati.xlsx",
                    sheet = 1)                       #12.5_22
k.uni <- coef(mod.uni, simplify = TRUE)$items        #12.5_23
k.tl <- coef(mod.tl, simplify = TRUE)$items          #12.5_24
k.bif <- coef(mod.bif, simplify = TRUE)$items        #12.5_25
round(rbind(uni = tapply(k.uni[, 1] - sejati$aG, spesifik, mean),
            testlet = tapply(k.tl[, 1] - sejati$aG, spesifik, mean),
            bifaktor = tapply(k.bif[, 1] - sejati$aG, spesifik, mean)),
      3)                                             #12.5_26
skor.uni <- fscores(mod.uni, full.scores.SE = TRUE)  #12.5_27
skor.tl <- fscores(mod.tl, full.scores.SE = TRUE,
                   QMC = TRUE)                       #12.5_28
skor.bif <- fscores(mod.bif, full.scores.SE = TRUE,
                    QMC = TRUE)                      #12.5_29
theta <- read.xlsx("kasus4_testlet_matematika_sejati.xlsx",
                   sheet = 2)                        #12.5_30
matrix(round(c(empirical_rxx(skor.uni),
               cor(skor.uni[, 1], theta$G)^2,
               empirical_rxx(skor.tl)[1],
               cor(skor.tl[, 1], theta$G)^2,
               empirical_rxx(skor.bif)[1],
               cor(skor.bif[, 1], theta$G)^2), 3),
       nrow = 2,
       dimnames = list(c("dilaporkan", "sebenarnya"),
                       c("uni", "testlet", "bifaktor")))  #12.5_31

# Membaca output: testlet tanpa efek
round(k.bif[1:5, c("a1", "a2", "d")], 3)             #12.5_32
spesifik.tl <- c(rep(NA, 5), rep(1:4, each = 5))     #12.5_33
mod.bif.tl <- bfactor(butir, model = spesifik.tl,
                      verbose = FALSE)               #12.5_34
anova(mod.bif.tl, mod.bif)                           #12.5_35
M2(mod.bif.tl, type = "C2", QMC = TRUE)              #12.5_36
M2(mod.tl, type = "C2", QMC = TRUE)                  #12.5_37

# ---------- Kasus 5: model two-tier ----------
# Panggil data
data5 <- read.xlsx("kasus5_twotier_pisa.xlsx",
                   sheet = 1)                        #12.5_38
butir5 <- data5[, -1]                                #12.5_39
spesifik5 <- c(1, 1, 1, 1, 2, 2, 2, 2,
               NA, NA, NA, NA,
               3, 3, 3, 3, 4, 4, 4, 4,
               5, 5, 5, 5)                           #12.5_40

# Spesifikasi model
spek.kor5 <- "MAT = 1-12
  BACA = 13-24
  COV = MAT*BACA"                                    #12.5_41
spek.2t <- "MAT = 1-12
  BACA = 13-24
  FREE = (GROUP, COV_21)"                            #12.5_42

# Estimasi
mod.kor5 <- mirt(butir5, spek.kor5,
                 verbose = FALSE)                    #12.5_43
mod.bif5 <- bfactor(butir5, model = spesifik5,
                    verbose = FALSE)                 #12.5_44
mod.2t <- bfactor(butir5, model = spesifik5,
                  model2 = spek.2t,
                  verbose = FALSE)                   #12.5_45

# Membaca output
sapply(list(mod.kor5, mod.bif5, mod.2t),
       extract.mirt, "converged")                    #12.5_46
anova(mod.kor5, mod.2t)                              #12.5_47
anova(mod.bif5, mod.2t)                              #12.5_48
round(coef(mod.kor5, simplify = TRUE)$cov, 3)        #12.5_49
round(coef(mod.2t, simplify = TRUE)$cov[1:2, 1:2], 3) #12.5_50
round(coef(mod.2t, simplify = TRUE)$items[c(1:4, 9:12, 13:16),
                                         c(1:3, 5, 8)], 2) #12.5_51
skor.2t <- fscores(mod.2t, full.scores.SE = TRUE,
                   QMC = TRUE)                       #12.5_52
round(empirical_rxx(skor.2t), 3)                     #12.5_53
M2(mod.2t, type = "C2", QMC = TRUE)                  #12.5_54

sessionInfo()
