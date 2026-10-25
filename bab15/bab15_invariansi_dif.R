# ============================================================
# Bab 15 Invariansi Pengukuran dan DIF pada Model Bifaktor
# Buku: Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Kasus 8: tes pemahaman bacaan 12 butir (3 bacaan, skor 0-4),
#   perempuan (P, rujukan) dan laki-laki (L, fokal), N = 1.200;
#   data simulasi berdesain Liu & Thompson (2022)
# Jalankan dengan folder kerja = bab15/
# ============================================================
options(width = 72)

# --- Jalankan Paket R dan Panggil Data ---
library(openxlsx)                                    #15.5_1
library(mirt)                                        #15.5_2
data <- read.xlsx("kasus8_membaca.xlsx", sheet = 1)  #15.5_3
butir <- data[, 3:14]                                #15.5_4
kelompok <- factor(data$jk, levels = c("P", "L"))    #15.5_5
spesifik <- rep(1:3, each = 4)                       #15.5_6
table(kelompok)                                      #15.5_7
skor.total <- rowSums(butir)                         #15.5_8
round(tapply(skor.total, kelompok, mean), 2)         #15.5_9
round(tapply(skor.total, kelompok, sd), 2)           #15.5_10

# --- Spesifikasi Model: parameter laten kelompok fokal ---
laten <- c("MEAN_1", "MEAN_2", "MEAN_4", "COV_11",
           "COV_22", "COV_33", "COV_44")             #15.5_11
nama <- colnames(butir)                              #15.5_12
nilai <- bfactor(butir, spesifik, group = kelompok,
                 invariance = nama,
                 pars = "values")                    #15.5_13
fokal <- nilai$group == "L"                          #15.5_14
nilai$est[fokal & nilai$name %in% laten] <- TRUE     #15.5_15
nilai[fokal & nilai$name %in% c(laten, "MEAN_3"),
      c("group", "name", "value", "est")]            #15.5_16

# --- Estimasi Langkah 1: konfigural dan invariansi penuh ---
mod.kfg <- bfactor(butir, spesifik, group = kelompok,
                   verbose = FALSE)                  #15.5_17
mod.inv <- bfactor(butir, spesifik, group = kelompok,
                   invariance = nama, pars = nilai,
                   verbose = FALSE)                  #15.5_18
extract.mirt(mod.inv, "converged")                   #15.5_19
anova(mod.inv, mod.kfg)                              #15.5_20

# --- Estimasi Langkah 2: rerata faktor spesifik ---
nilai0 <- nilai                                      #15.5_21
nilai0$est[fokal & nilai0$name %in%
             c("MEAN_2", "MEAN_4")] <- FALSE         #15.5_22
mod.inv0 <- bfactor(butir, spesifik, group = kelompok,
                    invariance = nama, pars = nilai0,
                    verbose = FALSE)                 #15.5_23
anova(mod.inv0, mod.inv)                             #15.5_24
round(coef(mod.inv, simplify = TRUE)$L$means, 3)     #15.5_25
round(diag(coef(mod.inv, simplify = TRUE)$L$cov), 3) #15.5_26
nilai.s1 <- nilai                                    #15.5_27
nilai.s1$est[fokal & nilai.s1$name == "MEAN_2"] <- FALSE
nilai.s1$est[fokal & nilai.s1$name == "MEAN_3"] <- TRUE #15.5_28
mod.s1 <- bfactor(butir, spesifik, group = kelompok,
                  invariance = nama, pars = nilai.s1,
                  verbose = FALSE)                   #15.5_29
round(coef(mod.s1, simplify = TRUE)$L$means, 3)      #15.5_30
c(rujukan.S2 = extract.mirt(mod.inv, "logLik"),
  rujukan.S1 = extract.mirt(mod.s1, "logLik"))       #15.5_31

# --- Estimasi Langkah 3: semua butir lain sebagai anchor ---
uji1 <- data.frame(butir = nama, bacaan = spesifik,
                   X2 = NA, df = NA, p = NA)         #15.5_32
for (i in 1:12) {
  inv.i <- nama[-i]
  nilai.i <- bfactor(butir, spesifik, group = kelompok,
                     invariance = inv.i, pars = "values")
  nilai.i$est[nilai.i$group == "L" &
                nilai.i$name %in% laten] <- TRUE
  mod.i <- bfactor(butir, spesifik, group = kelompok,
                   invariance = inv.i, pars = nilai.i,
                   verbose = FALSE)
  hasil <- anova(mod.inv, mod.i)
  uji1$X2[i] <- hasil$X2[2]
  uji1$df[i] <- hasil$df[2]
  uji1$p[i] <- hasil$p[2]
}                                                    #15.5_33
uji1$LR.f <- uji1$X2 / uji1$df                       #15.5_34
uji1[, 3:6] <- round(uji1[, 3:6], 3)                 #15.5_35
uji1                                                 #15.5_36

# --- Langkah 4: memilih anchor (satu per bacaan) ---
urut <- uji1[order(uji1$bacaan, uji1$LR.f), ]        #15.5_37
anchor <- urut$butir[!duplicated(urut$bacaan)]       #15.5_38
anchor                                               #15.5_39

# --- Langkah 5: uji DIF dengan anchor terpilih ---
nilai.anc <- bfactor(butir, spesifik, group = kelompok,
                     invariance = anchor,
                     pars = "values")                #15.5_40
nilai.anc$est[nilai.anc$group == "L" &
                nilai.anc$name %in% laten] <- TRUE   #15.5_41
mod.anc <- bfactor(butir, spesifik, group = kelompok,
                   invariance = anchor,
                   pars = nilai.anc, verbose = FALSE) #15.5_42
diuji <- setdiff(nama, anchor)                       #15.5_43
uji2 <- data.frame(butir = diuji, X2 = NA, df = NA,
                   p = NA)                           #15.5_44
for (i in 1:length(diuji)) {
  inv.i <- c(anchor, diuji[i])
  nilai.i <- bfactor(butir, spesifik, group = kelompok,
                     invariance = inv.i, pars = "values")
  nilai.i$est[nilai.i$group == "L" &
                nilai.i$name %in% laten] <- TRUE
  mod.i <- bfactor(butir, spesifik, group = kelompok,
                   invariance = inv.i, pars = nilai.i,
                   verbose = FALSE)
  hasil <- anova(mod.i, mod.anc)
  uji2$X2[i] <- hasil$X2[2]
  uji2$df[i] <- hasil$df[2]
  uji2$p[i] <- hasil$p[2]
}                                                    #15.5_45
uji2$p.BH <- p.adjust(uji2$p, method = "BH")         #15.5_46
uji2[, 2:5] <- round(uji2[, 2:5], 3)                 #15.5_47
uji2                                                 #15.5_48
dif <- uji2$butir[uji2$p.BH < 0.05]                  #15.5_49
dif                                                  #15.5_50

# --- Langkah 6: parameter mana yang berbeda? ---
jenis <- data.frame(butir = rep(dif, each = 3),
                    parameter = c("aG", "aS", "d"),
                    X2 = NA, df = NA, p = NA)        #15.5_51
for (i in 1:nrow(jenis)) {
  k <- jenis$butir[i]
  s <- spesifik[nama == k]
  baris <- nilai.anc$item == k
  if (jenis$parameter[i] == "aG") {
    kendala <- list(nilai.anc$parnum[baris &
                      nilai.anc$name == "a1"])
  }
  if (jenis$parameter[i] == "aS") {
    kendala <- list(nilai.anc$parnum[baris &
                      nilai.anc$name == paste0("a", s + 1)])
  }
  if (jenis$parameter[i] == "d") {
    p.d <- matrix(nilai.anc$parnum[baris &
                    nilai.anc$name %in% paste0("d", 1:4)],
                  ncol = 2)
    kendala <- split(p.d, row(p.d))
  }
  mod.k <- bfactor(butir, spesifik, group = kelompok,
                   invariance = anchor, pars = nilai.anc,
                   constrain = kendala, verbose = FALSE)
  hasil <- anova(mod.k, mod.anc)
  jenis$X2[i] <- hasil$X2[2]
  jenis$df[i] <- hasil$df[2]
  jenis$p[i] <- hasil$p[2]
}                                                    #15.5_52
jenis[, 3:5] <- round(jenis[, 3:5], 3)               #15.5_53
jenis                                                #15.5_54

# --- Langkah 7: model invariansi parsial ---
tetap <- setdiff(nama, dif)                          #15.5_55
nilai.prs <- bfactor(butir, spesifik, group = kelompok,
                     invariance = tetap,
                     pars = "values")                #15.5_56
nilai.prs$est[nilai.prs$group == "L" &
                nilai.prs$name %in% laten] <- TRUE   #15.5_57
mod.prs <- bfactor(butir, spesifik, group = kelompok,
                   invariance = tetap, pars = nilai.prs,
                   SE = TRUE, verbose = FALSE)       #15.5_58
extract.mirt(mod.prs, "converged")                   #15.5_59
anova(mod.inv, mod.prs)                              #15.5_60
koef <- coef(mod.prs, printSE = TRUE)                #15.5_61
round(koef$L$GroupPars[, 1:4], 3)                    #15.5_62
for (k in dif) {
  cat("\nButir", k, "\n")
  print(round(rbind(P = koef$P[[k]]["par", ],
                    L = koef$L[[k]]["par", ]), 2))
}                                                    #15.5_63

# --- Membaca Output: dampak DIF pada rerata faktor umum ---
sejati <- read.xlsx("kasus8_membaca_sejati.xlsx",
                    sheet = "parameter")             #15.5_64
benar <- sejati[sejati$butir %in% dif,
                c("aG.ref", "aG.fok", "aS.ref", "aS.fok",
                  "d.ref.1", "d.fok.1")]             #15.5_65
rownames(benar) <- dif                               #15.5_66
round(benar, 2)                                      #15.5_67
rerata.G <- c(penuh = coef(mod.inv,
                 simplify = TRUE)$L$means[1],
              parsial = coef(mod.prs,
                 simplify = TRUE)$L$means[1])        #15.5_68
round(rerata.G, 3)                                   #15.5_69
theta <- read.xlsx("kasus8_membaca_sejati.xlsx",
                   sheet = "theta")                  #15.5_70
round(tapply(theta$G, theta$jk, mean), 3)            #15.5_71

# --- Gambar: skor harapan B08 menurut kelompok ---
th.G <- seq(-3, 3, by = 0.05)                        #15.5_72
Theta <- cbind(th.G, 0, 0, 0)                        #15.5_73
skor.P <- expected.item(extract.item(mod.prs, "B08",
                                     group = 1), Theta) #15.5_74
skor.L <- expected.item(extract.item(mod.prs, "B08",
                                     group = 2), Theta) #15.5_75
plot(th.G, skor.P, type = "l", lwd = 2, ylim = c(0, 4),
     xlab = expression(theta[G]),
     ylab = "Skor harapan B08")                      #15.5_76
lines(th.G, skor.L, lty = 2, lwd = 2)                #15.5_77
legend("topleft", bty = "n", lty = 1:2, lwd = 2,
       legend = c("Perempuan", "Laki-laki"))         #15.5_78

sessionInfo()
