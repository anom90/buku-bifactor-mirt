# ============================================================
# Bab 5 (bacaan lanjutan) Perencanaan ukuran sampel model 2PL bifaktor
# Buku : Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Data : kasus1_2pl_matematika_sejati.xlsx (parameter sejati Kasus 1, Bab 6)
# R 4.6.1; mirt 1.48; openxlsx 4.2.8.1
#
# Rancangan simulasi disusun menurut kerangka ADEMP (Morris et al., 2019,
# pp. 1, 4):
#   A  Tujuan      : mencari ukuran sampel terkecil agar slope 2PL bifaktor
#                    tes matematika 21 butir diestimasi cukup tepat.
#   D  Pembangkit  : parameter sejati Kasus 1; theta ~ N(0, I); N = 250,
#                    500, 1.000; 100 replikasi per kondisi.
#   E  Estimand    : slope umum (aG) dan slope spesifik (aS) 21 butir.
#   M  Metode      : bfactor() (EM reduksi dimensi), pengaturan bawaan.
#   P  Ukuran      : laju konvergensi, bias, bias relatif, SE empiris,
#                    RMSE, dan SE Monte Carlo bias (Morris et al., 2019,
#                    pp. 12-15); kriteria bias relatif <= 10% (Muthen &
#                    Muthen, 2002, pp. 605-606).
# Waktu jalan di MacBook Air penulis: sekitar 32 menit.
# ============================================================

# Jalankan paket R
library(openxlsx)                                    #5.8_1
library(mirt)                                        #5.8_2

# Panggil data (parameter sejati)
sejati <- read.xlsx("kasus1_2pl_matematika_sejati.xlsx",
                    sheet = 1)                       #5.8_3
spesifik <- c(rep(1, 7), rep(2, 7), rep(3, 7))       #5.8_4
a <- matrix(0, nrow = 21, ncol = 4)                  #5.8_5
a[, 1] <- sejati$aG                                  #5.8_6
a[cbind(1:21, spesifik + 1)] <- sejati$aS            #5.8_7
d <- matrix(sejati$d, ncol = 1)                      #5.8_8

# Spesifikasi simulasi
ukuran <- c(250, 500, 1000)                          #5.8_9
replikasi <- 100                                     #5.8_10
set.seed(2025)                                       #5.8_11
est.aG <- array(NA, dim = c(replikasi, 21, 3))       #5.8_12
est.aS <- array(NA, dim = c(replikasi, 21, 3))       #5.8_13
konvergen <- matrix(NA, nrow = replikasi, ncol = 3)  #5.8_14

# Estimasi pada setiap replikasi
for (k in 1:3) {                                     #5.8_15
  for (r in 1:replikasi) {                           #5.8_16
    butir <- simdata(a, d, N = ukuran[k],
                     itemtype = "2PL")               #5.8_17
    mod.bif <- bfactor(butir, model = spesifik,
                       verbose = FALSE)              #5.8_18
    konvergen[r, k] <- extract.mirt(mod.bif,
                                    "converged")     #5.8_19
    par <- coef(mod.bif, simplify = TRUE)$items      #5.8_20
    est.aG[r, , k] <- par[, "a1"]                    #5.8_21
    est.aS[r, , k] <- rowSums(par[, c("a2", "a3",
                                      "a4")])        #5.8_22
  }                                                  #5.8_23
}                                                    #5.8_24

# Membaca output: ukuran kinerja
hasil <- data.frame(N = ukuran,
                    konvergen = colMeans(konvergen)) #5.8_25
for (k in 1:3) {                                     #5.8_26
  ok <- konvergen[, k]                               #5.8_27
  aG.ok <- matrix(est.aG[ok, , k], ncol = 21)        #5.8_28
  aS.ok <- matrix(est.aS[ok, , k], ncol = 21)        #5.8_29
  bias.aG <- colMeans(aG.ok) - sejati$aG             #5.8_30
  bias.aS <- colMeans(aS.ok) - sejati$aS             #5.8_31
  hasil$biasrel.aG.maks[k] <-
    max(abs(bias.aG / sejati$aG))                    #5.8_32
  hasil$bias.aS.maks[k] <- max(abs(bias.aS))         #5.8_33
  hasil$seemp.aG[k] <- mean(apply(aG.ok, 2, sd))     #5.8_34
  hasil$seemp.aS[k] <- mean(apply(aS.ok, 2, sd))     #5.8_35
  hasil$rmse.aG[k] <- mean(sqrt(colMeans(
    sweep(aG.ok, 2, sejati$aG)^2)))                  #5.8_36
  hasil$rmse.aS[k] <- mean(sqrt(colMeans(
    sweep(aS.ok, 2, sejati$aS)^2)))                  #5.8_37
  hasil$mcse.bias.aS[k] <-
    max(apply(aS.ok, 2, sd) / sqrt(sum(ok)))         #5.8_38
}                                                    #5.8_39
round(hasil, 3)                                      #5.8_40
write.xlsx(hasil, "hasil_ukuran_sampel_2pl.xlsx",
           overwrite = TRUE)                         #5.8_41

# Informasi sesi R (untuk log eksekusi)
sessionInfo()

# Penjelasan nomor baris
# 5.8_1-2   Paket openxlsx (membaca/menyimpan .xlsx) dan mirt dijalankan.
# 5.8_3     Parameter sejati Kasus 1 (21 butir: aG, aS, d) dibaca.
# 5.8_4     Struktur faktor spesifik: aljabar, geometri, trigonometri.
# 5.8_5-8   Matriks slope 21 x 4 (kolom 1 = faktor umum, kolom 2-4 = faktor
#           spesifik) dan vektor intersep disusun untuk simdata().
# 5.8_9     Tiga kondisi ukuran sampel yang dibandingkan.
# 5.8_10    Jumlah replikasi per kondisi. Morris et al. (2019, pp. 15-16)
#           menganjurkan jumlah replikasi dipilih dari SE Monte Carlo yang
#           dapat diterima; 100 dipakai agar script selesai dalam beberapa
#           menit. Naikkan (mis. 500) untuk keputusan yang sebenarnya.
# 5.8_11    Seed ditetapkan sekali di awal (Morris et al., 2019, p. 9).
# 5.8_12-14 Wadah hasil estimasi aG, aS, dan status konvergensi.
# 5.8_15-24 Untuk setiap N dan replikasi: data dibangkitkan dari parameter
#           sejati dengan theta ~ N(0, I), model 2PL bifaktor diestimasi,
#           status konvergensi dan slope disimpan. Slope spesifik setiap
#           butir diambil dari jumlah kolom a2-a4 (hanya satu yang tak nol).
# 5.8_25    Laju konvergensi: proporsi replikasi yang konvergen. Replikasi
#           yang tidak konvergen dikeluarkan dari ukuran kinerja lain
#           (Morris et al., 2019, p. 12).
# 5.8_27-31 Estimasi dari replikasi yang konvergen diambil, lalu bias setiap
#           butir dihitung (rerata estimasi dikurangi nilai sejati).
# 5.8_32    Bias relatif terbesar aG (dalam proporsi; 0,10 = 10%).
#           Bias relatif aS tidak dihitung karena beberapa aS sejati
#           mendekati 0 (Morris et al., 2019, pp. 13-14).
# 5.8_33    Bias mutlak terbesar aS.
# 5.8_34-35 SE empiris: rerata simpangan baku estimasi antarreplikasi.
# 5.8_36-37 RMSE: akar rerata kuadrat selisih estimasi dan nilai sejati,
#           dirata-ratakan atas 21 butir.
# 5.8_38    SE Monte Carlo terbesar untuk bias aS (SE empiris / akar R).
# 5.8_40-41 Tabel ukuran kinerja dicetak dan disimpan.
