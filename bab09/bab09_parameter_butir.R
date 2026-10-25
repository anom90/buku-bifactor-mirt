# ============================================================
# Bab 9 Tafsiran parameter butir model bifaktor
# Buku : Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Data : kasus1_2pl_matematika.xlsx, kasus2_grm_efikasi.xlsx
#        (data simulasi)
# R 4.6.1; mirt 1.48; openxlsx 4.2.8.1
# Jalankan: Rscript bab09_parameter_butir.R > log_bab09_parameter_butir.txt 2>&1
# ============================================================

# Jalankan paket R
library(openxlsx)                                    #9.5_1
library(mirt)                                        #9.5_2

# Kasus 1: tes matematika (2PL bifaktor)
data <- read.xlsx("kasus1_2pl_matematika.xlsx",
                  sheet = 1)                         #9.5_3
butir <- data[, -1]                                  #9.5_4
spesifik <- c(rep(1, 7), rep(2, 7), rep(3, 7))       #9.5_5
mod.bif <- bfactor(butir, model = spesifik,
                   verbose = FALSE)                  #9.5_6
mod.uni <- mirt(butir, 1, verbose = FALSE)           #9.5_7

# Parameter bersyarat
koef.bif <- coef(mod.bif, simplify = TRUE)$items     #9.5_8
aG <- koef.bif[, "a1"]                               #9.5_9
aS <- rowSums(koef.bif[, c("a2", "a3", "a4")])       #9.5_10
sudut <- acos(aG / sqrt(aG^2 + aS^2)) * 180 / pi     #9.5_11
bersyarat <- data.frame(aG = aG, aS = aS,
                        d = koef.bif[, "d"],
                        MDISC = MDISC(mod.bif),
                        sudut = sudut)               #9.5_12
round(bersyarat, 3)                                  #9.5_13
plot(0, 0, type = "n", xlim = c(-0.4, 3.2), ylim = c(0, 1.8), asp = 1,
     xlab = expression(theta[G]), ylab = expression(theta[S])) #9.5_14
abline(0, 1, lty = 3)                                #9.5_15
for (j in c("ALJ2", "GEO6", "GEO4", "ALJ6")) {
  arrows(0, 0, aG[j], aS[j], length = 0.08, lwd = 1.5)
  text(aG[j], aS[j], paste0(j, " (", round(sudut[j]), "°)"),
       pos = c(ALJ2 = 4, GEO6 = 4, GEO4 = 3, ALJ6 = 2)[j],
       cex = 0.8)
}                                                    #9.5_16

# Parameter marginal dengan IRT proyektif (PIRT)
mod.pirt <- pirt(mod.bif)                            #9.5_17
koef.pirt <- coef(mod.pirt, simplify = TRUE)$items   #9.5_18
koef.uni <- coef(mod.uni, simplify = TRUE)$items     #9.5_19
banding <- data.frame(aG = aG,
                      a.pirt = koef.pirt[, "a1"],
                      a.uni = koef.uni[, "a1"],
                      d = koef.bif[, "d"],
                      d.pirt = koef.pirt[, "d"],
                      d.uni = koef.uni[, "d"])       #9.5_20
round(banding, 3)                                    #9.5_21
round(coef(mod.pirt, IRTpars = TRUE,
           simplify = TRUE)$items[, c("a", "b")], 3) #9.5_22

# Kurva karakteristik butir bersyarat dan marginal
theta <- seq(-3, 3, by = 0.05)                       #9.5_23
par(mfrow = c(1, 2))                                 #9.5_24
for (j in c("ALJ2", "ALJ6")) {
  P1 <- plogis(koef.bif[j, "a1"] * theta + koef.bif[j, "d"])
  P2 <- plogis(koef.pirt[j, "a1"] * theta + koef.pirt[j, "d"])
  P3 <- plogis(koef.uni[j, "a1"] * theta + koef.uni[j, "d"])
  plot(theta, P1, type = "l", lwd = 2, ylim = c(0, 1),
       xlab = expression(theta[G]), ylab = "Peluang benar",
       main = j)
  lines(theta, P2, lty = 2, lwd = 2)
  lines(theta, P3, lty = 3, lwd = 2)
  legend("bottomright", bty = "n", lty = 1:3, lwd = 2,
         cex = 0.8, legend = c("Bersyarat", "PIRT",
                               "Unidimensi"))
}                                                    #9.5_25

# Kasus 2: angket efikasi diri berbicara (GRM bifaktor)
data2 <- read.xlsx("kasus2_grm_efikasi.xlsx",
                   sheet = 1)                        #9.5_26
butir2 <- data2[, -1]                                #9.5_27
spesifik2 <- c(rep(1, 6), rep(2, 6),
               rep(3, 6), rep(4, 6))                 #9.5_28
mod.grm <- bfactor(butir2, model = spesifik2,
                   verbose = FALSE)                  #9.5_29
mod.grm.uni <- mirt(butir2, 1, verbose = FALSE)      #9.5_30
mod.grm.pirt <- pirt(mod.grm)                        #9.5_31
k.grm <- coef(mod.grm, simplify = TRUE)$items        #9.5_32
k.pirt <- coef(mod.grm.pirt, simplify = TRUE)$items  #9.5_33
k.uni <- coef(mod.grm.uni, simplify = TRUE)$items    #9.5_34
k.fa <- pirt(mod.grm, estimator = "FA")              #9.5_35
banding2 <- data.frame(aG = k.grm[, "a1"],
                       a.pirt = k.pirt[, "a1"],
                       a.fa = k.fa[, 1],
                       a.uni = k.uni[, "a1"])        #9.5_36
round(banding2, 3)                                   #9.5_37
round(coef(mod.grm.pirt, IRTpars = TRUE,
           simplify = TRUE)$items, 3)                #9.5_38

sessionInfo()
