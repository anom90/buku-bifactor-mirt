# ============================================================
# Bab 5 (bacaan lanjutan) Ilustrasi masalah identifikasi empiris
# Buku : Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Data : kasus3_efikasidiri.xlsx (data simulasi; 12 butir skala 1-5,
#        4 subskala x 3 butir, N = 203; muatan baku diadopsi dari
#        Zhang et al., 2023, p. 577; muatan spesifik TP2 dibatasi -0,58)
# R 4.6.1; mirt 1.48; openxlsx 4.2.8.1
# Waktu jalan: sekitar 1 menit.
# ============================================================

# Jalankan paket R
library(openxlsx)                                    #5.4_1
library(mirt)                                        #5.4_2

# Panggil data
data <- read.xlsx("kasus3_efikasidiri.xlsx",
                  sheet = 1)                         #5.4_3
butir <- data[, -1]                                  #5.4_4

# Spesifikasi model
spesifik <- rep(1:4, each = 3)                       #5.4_5
spesifik.tl <- c(NA, NA, NA, rep(2:4, each = 3) - 1) #5.4_6

# Estimasi
mod.bif <- bfactor(butir, model = spesifik,
                   verbose = FALSE,
                   technical = list(NCYCLES = 3000)) #5.4_7
set.seed(5)                                          #5.4_8
mod.mhrm <- mirt(butir, model = "G = 1-12
                 S1 = 1-3
                 S2 = 4-6
                 S3 = 7-9
                 S4 = 10-12", method = "MHRM",
                 verbose = FALSE)                    #5.4_9
mod.tl <- bfactor(butir, model = spesifik.tl,
                  verbose = FALSE)                   #5.4_10

# Membaca output
extract.mirt(mod.bif, "converged")                   #5.4_11
extract.mirt(mod.bif, "iterations")                  #5.4_12
round(summary(mod.bif, verbose = FALSE)$rotF[1:3, 1:2],
      2)                                             #5.4_13
round(summary(mod.mhrm, verbose = FALSE)$rotF[1:3, 1:2],
      2)                                             #5.4_14
c(EM = extract.mirt(mod.bif, "logLik"),
  MHRM = extract.mirt(mod.mhrm, "logLik"),
  tidak.lengkap = extract.mirt(mod.tl, "logLik"))    #5.4_15
extract.mirt(mod.tl, "converged")                    #5.4_16

# Informasi sesi R (untuk log eksekusi)
sessionInfo()

# Penjelasan nomor baris
# 5.4_1-4   Paket dijalankan; data Kasus B dibaca dan kolom id dibuang.
# 5.4_5     Struktur bifaktor lengkap: TP1-TP3 (topik), OR4-OR6 (organisasi),
#           BH7-BH9 (bahasa), PY10-PY12 (penyampaian).
# 5.4_6     Struktur bifaktor tidak lengkap: butir topik hanya bermuatan pada
#           faktor umum (NA); tiga subskala lain tetap punya faktor spesifik.
# 5.4_7     Model GRM bifaktor lengkap dengan EM reduksi dimensi; batas
#           iterasi dinaikkan dari 500 menjadi 3.000 (Paek & Cole, 2020,
#           pp. 262-263).
# 5.4_8-9   Model yang sama diestimasi dengan MH-RM. MH-RM bersifat
#           stokastik sehingga seed ditetapkan.
# 5.4_10    Model bifaktor tidak lengkap.
# 5.4_11-12 EM tidak konvergen walaupun 3.000 siklus.
# 5.4_13-14 Muatan baku butir topik pada faktor umum (G) dan faktor spesifik
#           topik (S1) dari EM dan MH-RM. Pola S1 berbeda jauh: EM memberi
#           muatan besar pada TP2, MH-RM pada TP1.
# 5.4_15    Log-likelihood ketiga solusi hampir sama.
# 5.4_16    Model bifaktor tidak lengkap konvergen.
