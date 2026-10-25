# Bab 7 Kecocokan dan perbandingan model

| Berkas | Isi |
|---|---|
| `bab07_kecocokan_model.R` | Script bab (#7.7_1–#7.7_18): model 2PL unidimensi, tiga faktor berkorelasi, dan bifaktor; `anova()`, `M2()`, `itemfit()` |
| `kasus1_2pl_matematika.xlsx` | Kasus 1: tes matematika 21 butir, N = 899 |
| `log_bab07_kecocokan_model.txt` | Log eksekusi asli, diakhiri `sessionInfo()` |

Paket: openxlsx, mirt. Jadikan folder ini folder kerja (`setwd()`), lalu jalankan script baris demi baris. Waktu jalan sekitar 21 detik (R 4.6.1, mirt 1.48). Model bifaktor berdimensi empat, sehingga `M2()` dan `itemfit()` memakai `QMC = TRUE`.

Seluruh data adalah data simulasi.
