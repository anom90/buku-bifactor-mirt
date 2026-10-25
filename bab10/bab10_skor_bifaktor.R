# ============================================================
# Bab 10 Skor faktor umum dan faktor spesifik
# Buku : Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Data : kasus1_2pl_matematika.xlsx, kasus2_grm_efikasi.xlsx
#        (data simulasi)
# R 4.6.1; mirt 1.48; openxlsx 4.2.8.1
# Jalankan: Rscript bab10_skor_bifaktor.R > log_bab10_skor_bifaktor.txt 2>&1
# ============================================================

# Jalankan paket R
library(openxlsx)                                    #10.7_1
library(mirt)                                        #10.7_2

# Kasus 1: tes matematika (2PL bifaktor)
data <- read.xlsx("kasus1_2pl_matematika.xlsx",
                  sheet = 1)                         #10.7_3
butir <- data[, -1]                                  #10.7_4
spesifik <- c(rep(1, 7), rep(2, 7), rep(3, 7))       #10.7_5
mod.bif <- bfactor(butir, model = spesifik,
                   verbose = FALSE)                  #10.7_6

# Skor EAP semua faktor
skor <- fscores(mod.bif, method = "EAP",
                full.scores.SE = TRUE, QMC = TRUE,
                verbose = FALSE)                     #10.7_7
head(round(skor, 3))                                 #10.7_8
round(apply(skor[, 1:4], 2, sd), 3)                  #10.7_9
round(empirical_rxx(skor), 3)                        #10.7_10
round(cor(skor[, 1:4]), 3)                           #10.7_11
pola <- rbind(c(0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1,
                0, 1, 0, 1, 0, 0, 0),
              c(1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1,
                1, 1, 1, 1, 1, 1, 0))                 #10.7_12
colnames(pola) <- colnames(butir)                    #10.7_13
contoh <- fscores(mod.bif, method = "EAP",
                  response.pattern = pola,
                  QMC = TRUE)                        #10.7_14
round(contoh[, c("G", "S2", "SE_G", "SE_S2")], 3)    #10.7_15

# Skor faktor umum dengan reduksi dimensi
skor.G <- fscores(mod.bif, method = "EAP_general",
                  full.scores.SE = TRUE,
                  verbose = FALSE)                   #10.7_16
round(empirical_rxx(skor.G), 3)                      #10.7_17
round(cor(skor[, "G"], skor.G[, "G"]), 4)            #10.7_18

# Tabel konversi skor total ke skor EAP (Lord-Wingersky 2.0)
tabel <- fscores(mod.bif, method = "EAPsum_2.0",
                 full.scores = FALSE,
                 verbose = FALSE)                    #10.7_19
tabel                                                #10.7_20
rxx.total <- 1 - sum(tabel$observed * tabel$SE_G^2) /
                 sum(tabel$observed)                 #10.7_21
round(rxx.total, 3)                                  #10.7_22
skor.total <- rowSums(butir)                         #10.7_23
round(cor(skor.total, skor.G[, "G"]), 3)             #10.7_24

# Skor komposit subskala
koef <- coef(mod.bif, simplify = TRUE)$items         #10.7_25
acov <- fscores(mod.bif, method = "EAP", QMC = TRUE,
                return.acov = TRUE,
                verbose = FALSE)                     #10.7_26
nama <- list(c("ALJ", "GEO", "TRG"),
             c("wG", "wS", "rxx", "r.G"))
komposit <- matrix(NA, nrow = 3, ncol = 4,
                   dimnames = nama)                  #10.7_27
for (k in 1:3) {
  A <- koef[spesifik == k, c(1, k + 1)]
  w <- eigen(t(A) %*% A)$vectors[, 1]
  w <- w * sign(w[1])
  theta <- w[1] * skor[, 1] + w[2] * skor[, k + 1]
  se2 <- sapply(acov, function(V)
    w[1]^2 * V[1, 1] + w[2]^2 * V[k + 1, k + 1] +
      2 * w[1] * w[2] * V[1, k + 1])
  komposit[k, ] <- c(w, 1 - mean(se2), cor(theta, skor[, 1]))
}                                                    #10.7_28
round(komposit, 3)                                   #10.7_29

# Kasus 2: angket efikasi diri berbicara (GRM bifaktor)
data2 <- read.xlsx("kasus2_grm_efikasi.xlsx",
                   sheet = 1)                        #10.7_30
butir2 <- data2[, -1]                                #10.7_31
spesifik2 <- c(rep(1, 6), rep(2, 6),
               rep(3, 6), rep(4, 6))                 #10.7_32
mod.grm <- bfactor(butir2, model = spesifik2,
                   verbose = FALSE)                  #10.7_33
skor2 <- fscores(mod.grm, method = "EAP",
                 full.scores.SE = TRUE, QMC = TRUE,
                 verbose = FALSE)                    #10.7_34
round(empirical_rxx(skor2), 3)                       #10.7_35
tabel2 <- fscores(mod.grm, method = "EAPsum_2.0",
                  full.scores = FALSE,
                  verbose = FALSE)                   #10.7_36
head(tabel2)                                         #10.7_37
rxx.total2 <- 1 - sum(tabel2$observed * tabel2$SE_G^2) /
                  sum(tabel2$observed)               #10.7_38
round(rxx.total2, 3)                                 #10.7_39

sessionInfo()
