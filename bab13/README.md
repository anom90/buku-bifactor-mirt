# Bab 13 Model bifaktor eksploratori

| Berkas | Isi |
|---|---|
| `bab13_bifaktor_eksploratori.R` | Script bab (#13.6_1–#13.6_60) |
| `kasus6_motivasi.xlsx` | Kasus 6: angket motivasi berorientasi pertumbuhan, 15 butir skala 1–7 (PT1–PT8, TD1–TD4, TT1–TT3; PT5–PT8 arah mentah), N = 1.469, ditambah tiga variabel luaran (bahan latihan analisis prediksi seperti Bab 14) |
| `kasus6_motivasi_sejati.xlsx` | Parameter sejati (sheet `parameter`: muatan lam.*, slope a.*, intersep d1–d6), kemampuan sejati (sheet `theta`), dan beta luaran (sheet `beta.luaran`) |
| `log_bab13_bifaktor_eksploratori.txt` | Log eksekusi asli (`Rscript bab13_bifaktor_eksploratori.R > log_bab13_bifaktor_eksploratori.txt 2>&1`), termasuk `sessionInfo()` |

Paket: openxlsx, mirt, psych, GPArotation, BifactorIndicesCalculator. Jadikan folder ini folder kerja (`setwd()`), lalu jalankan script baris demi baris. Waktu jalan sekitar 1 menit (R 4.6.1, mirt 1.48, GPArotation 2026.7.1, psych 2.6.5).

Desain data: muatan B-ESEM Bostwick et al. (2025, Tabel 2, p. 350), termasuk muatan silang, diubah menjadi parameter GRM (Reise, 2012, p. 681). Ambang diturunkan dari rerata dan SD subskala T2 (Tabel 1, p. 347). Kategori 1 kosong pada beberapa butir TD/TT karena reratanya tinggi.

Isi analisis: (1) bifaktor konfirmatori `bfactor()` dan perbandingannya dengan model eksploratori 4 dimensi (MH-RM); (2) Schmid-Leiman `psych::schmid()` pada korelasi polikorik (kasus ultra-Heywood); (3) rotasi Jennrich-Bentler `bifactorT()` dan `bigeominT()` dengan 1.000 nilai awal acak; (4) rotasi target ortogonal `targetT()` (padanan B-ESEM); (5) perbandingan muatan umum dengan nilai sejati (RMSE) dan indeks `bifactorIndices()`.

Seluruh data adalah data simulasi. Respons dan hasil analisis bukan temuan artikel asal.

## Catatan penamaan berkas (2026-10-25)

Berkas data diganti nama agar sesuai nomor kasus di naskah: `kasusC_motivasi*.xlsx` → `kasus6_motivasi*.xlsx`. Isi berkas tidak berubah dan model tidak diestimasi ulang. Log eksekusi di folder ini dibuat sebelum penggantian nama, sehingga masih memuat nama berkas lama.
