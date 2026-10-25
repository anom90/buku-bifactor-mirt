# ============================================================
# Bab 14 Studi Kasus Terpadu
# Buku: Bifactor-MIRT dalam Pendidikan (Retnawati & Kartianom)
# Kasus 7: tes kemampuan matematika lima domain (data simulasi
#   berdesain Meng et al., 2022; 60 butir campuran dikotomus dan
#   politomus, N = 2.000) ditambah nilai ujian akhir matematika
# Jalankan dengan folder kerja = bab14/
# ============================================================
options(width = 72)

# --- Jalankan Paket R, Panggil Data, dan Spesifikasi Model ---
library(openxlsx)                                    #14.4_1
library(mirt)                                        #14.4_2
library(BifactorIndicesCalculator)                   #14.4_3
library(lavaan)                                      #14.4_4
data <- read.xlsx("kasus7_matematika.xlsx",
                  sheet = 1)                         #14.4_5
butir <- data[, 2:61]                                #14.4_6
spesifik <- rep(1:5, each = 12)                      #14.4_7
model.kor <- "KM = 1-12
              IR = 13-24
              AD = 25-36
              PL = 37-48
              PM = 49-60
              COV = KM*IR*AD*PL*PM"                  #14.4_8

# --- Langkah 1: data dan asumsi ---
dim(butir)                                           #14.4_9
sum(is.na(butir))                                    #14.4_10
table(apply(butir, 2, max))                          #14.4_11
round(itemstats(butir)$overall, 3)                   #14.4_12
mod.uni <- mirt(butir, 1, verbose = FALSE)           #14.4_13
q3 <- residuals(mod.uni, type = "Q3",
                verbose = FALSE)                     #14.4_14
atas <- upper.tri(q3)                                #14.4_15
blok <- outer(spesifik, spesifik, "==")              #14.4_16
round(c(dalam = mean(q3[atas & blok]),
        antar = mean(q3[atas & !blok])), 3)          #14.4_17
table(dalam.domain = blok[atas],
      Q3.besar = abs(q3[atas]) > 0.2)                #14.4_18

# --- Langkah 2: estimasi model bifaktor ---
mod.bif <- bfactor(butir, model = spesifik, SE = TRUE,
                   verbose = FALSE)                  #14.4_19
extract.mirt(mod.bif, "converged")                   #14.4_20
extract.mirt(mod.bif, "iterations")                  #14.4_21
extract.mirt(mod.bif, "secondordertest")             #14.4_22

# --- Langkah 3: model pesaing ---
set.seed(14)                                         #14.4_23
mod.kor <- mirt(butir, model.kor, method = "MHRM",
                verbose = FALSE)                     #14.4_24
anova(mod.uni, mod.bif)                              #14.4_25
anova(mod.kor, mod.bif)                              #14.4_26
round(summary(mod.kor, verbose = FALSE)$fcor, 2)     #14.4_27
M2(mod.uni, type = "C2")                             #14.4_28
M2(mod.kor, type = "C2", QMC = TRUE)                 #14.4_29
M2(mod.bif, type = "C2", QMC = TRUE)                 #14.4_30
fit.butir <- itemfit(mod.bif, QMC = TRUE,
                     p.adjust = "BH")                #14.4_31
sum(fit.butir$p.S_X2 < 0.05)                         #14.4_32
round(max(fit.butir$RMSEA.S_X2), 3)                  #14.4_33

# --- Langkah 4: indeks bifaktor ---
muatan <- summary(mod.bif, verbose = FALSE)$rotF     #14.4_34
colnames(muatan) <- c("G", "KM", "IR", "AD", "PL", "PM") #14.4_35
muatan.uni <- summary(mod.uni, verbose = FALSE)$rotF #14.4_36
indeks <- bifactorIndices(muatan,
                          UniLambda = muatan.uni)    #14.4_37
round(indeks$ModelLevelIndices, 3)                   #14.4_38
round(indeks$FactorLevelIndices, 3)                  #14.4_39

# --- Langkah 5: parameter butir ---
koef <- coef(mod.bif, simplify = TRUE)$items         #14.4_40
aG <- koef[, "a1"]                                   #14.4_41
aS <- rowSums(koef[, c("a2", "a3", "a4", "a5", "a6")]) #14.4_42
iecv <- indeks$ItemLevelIndices[, "IECV"]            #14.4_43
butir.pm <- cbind(aG, aS, koef[, c("d", "d1", "d2")],
                  IECV = iecv)[49:60, ]              #14.4_44
round(butir.pm, 2)                                   #14.4_45
summary(iecv)                                        #14.4_46

# --- Langkah 6: skor ---
skor <- fscores(mod.bif, method = "EAP",
                full.scores.SE = TRUE, QMC = TRUE,
                verbose = FALSE)                     #14.4_47
colnames(skor)[1:6] <- colnames(muatan)              #14.4_48
round(empirical_rxx(skor), 3)                        #14.4_49
skor.total <- rowSums(butir)                         #14.4_50
skor.uni <- fscores(mod.uni, verbose = FALSE)        #14.4_51
round(cor(cbind(total = skor.total, uni = skor.uni[, 1],
                G = skor[, "G"])), 3)                #14.4_52

# --- Langkah 7: memprediksi luaran ---
z.nilai <- as.numeric(scale(data$nilai))             #14.4_53
skor.df <- as.data.frame(skor[, 1:6])                #14.4_54
rumus <- z.nilai ~ G + KM + IR + AD + PL + PM        #14.4_55
reg.G <- lm(z.nilai ~ G, data = skor.df)             #14.4_56
reg.bif <- lm(rumus, data = skor.df)                 #14.4_57
round(summary(reg.bif)$coefficients, 3)              #14.4_58
anova(reg.G, reg.bif)                                #14.4_59
round(c(R2.G = summary(reg.G)$r.squared,
        R2.bif = summary(reg.bif)$r.squared), 3)     #14.4_60
nama <- names(butir)                                 #14.4_61
ukur.G <- paste("G =~", paste(nama, collapse = " + ")) #14.4_62
ukur.S <- paste(colnames(muatan)[-1], "=~",
                tapply(nama, spesifik, paste,
                       collapse = " + "))            #14.4_63
model.sem <- c(ukur.G, ukur.S,
               "nilai ~ G + KM + IR + AD + PL + PM") #14.4_64
model.sem.uni <- c(paste("U =~",
                         paste(nama, collapse = " + ")),
                   "nilai ~ U")                      #14.4_65
sem.bif <- sem(model.sem, data = data, ordered = nama,
               std.lv = TRUE, orthogonal = TRUE)     #14.4_66
sem.uni <- sem(model.sem.uni, data = data,
               ordered = nama, std.lv = TRUE)        #14.4_67
round(fitMeasures(sem.bif, c("chisq.scaled", "df.scaled",
                             "cfi.scaled", "rmsea.scaled",
                             "srmr")), 3)            #14.4_68
jalur <- standardizedSolution(sem.bif)               #14.4_69
kolom <- c("rhs", "est.std", "se", "pvalue")         #14.4_70
jalur[jalur$op == "~", kolom]                        #14.4_71
jalur.uni <- standardizedSolution(sem.uni)           #14.4_72
jalur.uni[jalur.uni$op == "~", kolom]                #14.4_73
round(c(R2.bif = inspect(sem.bif, "r2")[["nilai"]],
        R2.uni = inspect(sem.uni, "r2")[["nilai"]]), 3) #14.4_74
sejati <- read.xlsx("kasus7_matematika_sejati.xlsx",
                    sheet = "theta")                 #14.4_75
round(coef(lm(rumus, data = sejati)), 3)             #14.4_76

sessionInfo()
