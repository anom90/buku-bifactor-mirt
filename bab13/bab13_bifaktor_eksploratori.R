# ============================================================
# Bab 13 Model Bifaktor Eksploratori
# Buku: Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Kasus 6: angket motivasi berorientasi pertumbuhan (data simulasi
#   berdesain Bostwick et al., 2025; 15 butir skala 7, N = 1.469)
# Jalankan dengan folder kerja = bab13/
# ============================================================
options(width = 72)

# --- Jalankan Paket R, Panggil Data, dan Spesifikasi Model ---
library(openxlsx)                                    #13.6_1
library(mirt)                                        #13.6_2
library(psych)                                       #13.6_3
library(GPArotation)                                 #13.6_4
library(BifactorIndicesCalculator)                   #13.6_5
data <- read.xlsx("kasus6_motivasi.xlsx", sheet = 1) #13.6_6
butir <- data[, 2:16]                                #13.6_7
butir[, 5:8] <- 8 - butir[, 5:8]                     #13.6_8
spesifik <- c(rep(1, 8), rep(2, 4), rep(3, 3))       #13.6_9
target <- matrix(0, nrow = 15, ncol = 4)             #13.6_10
target[, 1] <- NA                                    #13.6_11
target[1:8, 2] <- NA                                 #13.6_12
target[9:12, 3] <- NA                                #13.6_13
target[13:15, 4] <- NA                               #13.6_14

# --- Estimasi ---
mod.bif <- bfactor(butir, model = spesifik,
                   verbose = FALSE)                  #13.6_15
korelasi <- polychoric(butir)$rho                    #13.6_16
mod.sl <- schmid(korelasi, nfactors = 3, fm = "minres",
                 rotate = "oblimin",
                 n.obs = nrow(butir))                #13.6_17
set.seed(13)                                         #13.6_18
mod.efa <- mirt(butir, 4, method = "MHRM",
                verbose = FALSE)                     #13.6_19

# --- Membaca Output ---
# Langkah 1: bifaktor konfirmatori
muatan.bif <- summary(mod.bif, verbose = FALSE)$rotF #13.6_20
round(muatan.bif, 2)                                 #13.6_21
anova(mod.bif, mod.efa)                              #13.6_22

# Langkah 2: Schmid-Leiman
round(mod.sl$oblique[, 1:3], 2)                      #13.6_23
round(mod.sl$phi, 2)                                 #13.6_24
round(mod.sl$gloading[, 1], 3)                       #13.6_25
round(mod.sl$sl[, 1:4], 2)                           #13.6_26

# Langkah 3: rotasi bifaktor analitik Jennrich-Bentler
muatan.awal <- summary(mod.efa, rotate = "none",
                       verbose = FALSE)$rotF         #13.6_27
set.seed(13)                                         #13.6_28
rot.bq <- bifactorT(muatan.awal,
                    randomStarts = 1000)             #13.6_29
rot.bq$randStartChar                                 #13.6_30
tanda <- sign(colSums(rot.bq$loadings))              #13.6_31
muatan.bq <- rot.bq$loadings %*% diag(tanda)         #13.6_32
colnames(muatan.bq) <- paste0("F", 1:4)              #13.6_33
round(muatan.bq, 2)                                  #13.6_34
set.seed(13)                                         #13.6_35
rot.bg <- bigeominT(muatan.awal,
                    randomStarts = 1000)             #13.6_36
rot.bg$randStartChar                                 #13.6_37
tanda <- sign(colSums(rot.bg$loadings))              #13.6_38
muatan.bg <- rot.bg$loadings %*% diag(tanda)         #13.6_39
colnames(muatan.bg) <- paste0("F", 1:4)              #13.6_40
round(muatan.bg, 2)                                  #13.6_41

# Langkah 4: rotasi target ortogonal (B-ESEM)
set.seed(13)                                         #13.6_42
rot.tg <- targetT(muatan.awal, Target = target,
                  randomStarts = 1000)               #13.6_43
rot.tg$randStartChar                                 #13.6_44
tanda <- sign(colSums(rot.tg$loadings))              #13.6_45
muatan.tg <- rot.tg$loadings %*% diag(tanda)         #13.6_46
colnames(muatan.tg) <- c("G", "PT", "TD", "TT")      #13.6_47
round(muatan.tg, 2)                                  #13.6_48

# Langkah 5: perbandingan dengan nilai sejati
sejati <- read.xlsx("kasus6_motivasi_sejati.xlsx",
                    sheet = 1)                       #13.6_49
umum <- cbind(sejati = sejati$lam.G,
              konfirmatori = muatan.bif[, 1],
              SL = mod.sl$sl[, 1],
              biquartimin = muatan.bq[, 1],
              target = muatan.tg[, 1])               #13.6_50
round(umum, 2)                                       #13.6_51
round(sqrt(colMeans((umum[, -1] - umum[, 1])^2)), 3) #13.6_52
indeks.tg <- bifactorIndices(muatan.tg)              #13.6_53
round(indeks.tg$FactorLevelIndices[, c("ECV_SS",
                                       "OmegaH", "H")], 3) #13.6_54
indeks.bif <- bifactorIndices(muatan.bif)            #13.6_55
indeks.sj <- bifactorIndices(as.matrix(sejati[, 3:6])) #13.6_56
kolom <- c("ECV_SS", "OmegaH", "H")                  #13.6_57
indeks.G <- rbind(indeks.bif$FactorLevelIndices[1, kolom],
                  indeks.tg$FactorLevelIndices[1, kolom],
                  indeks.sj$FactorLevelIndices[1, kolom]) #13.6_58
rownames(indeks.G) <- c("konfirmatori", "target",
                        "sejati")                    #13.6_59
round(indeks.G, 3)                                   #13.6_60

sessionInfo()
