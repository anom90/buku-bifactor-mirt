# Bab 14 Studi kasus terpadu

| Berkas | Isi |
|---|---|
| `bab14_studi_kasus_terpadu.R` | Script bab (#14.4_1–#14.4_76): tujuh langkah analisis dari pemeriksaan data sampai prediksi luaran |
| `kasus7_matematika.xlsx` | Kasus 7: tes matematika lima domain (KM, IR, AD, PL, PM), 60 butir (36 dikotomus 0–1, 24 politomus 0–2), N = 2.000, ditambah kolom `nilai` (nilai ujian akhir matematika, 0–100) |
| `kasus7_matematika_sejati.xlsx` | Parameter sejati butir (sheet `parameter`), kemampuan sejati (sheet `theta`), dan koefisien luaran (sheet `beta.luaran`) |
| `log_bab14_studi_kasus_terpadu.txt` | Log eksekusi asli (`Rscript bab14_studi_kasus_terpadu.R > log_bab14_studi_kasus_terpadu.txt 2>&1`), termasuk `sessionInfo()` |
| `kasus6_motivasi.xlsx` | Salinan data Kasus 6 (Bab 13), tidak dipakai di bab ini; kolom luarannya dapat dipakai untuk latihan |

Paket: openxlsx, mirt, BifactorIndicesCalculator, lavaan. Jadikan folder ini folder kerja (`setwd()`), lalu jalankan script baris demi baris. Waktu jalan sekitar 12 menit (R 4.6.1, mirt 1.48, lavaan 0.7-2); bagian terlama adalah `bfactor()` dengan `SE = TRUE` dan `M2()` dengan `QMC = TRUE`.

Desain data: parameter butir mengikuti Meng et al. (2022, pp. 7–10), dengan adaptasi penulis (data lengkap tanpa desain buklet, 12 butir per domain). Nilai ujian akhir dibangkitkan dari Z = 0,51 G + 0,25 PM + galat (pola koefisien Stefansson et al., 2016, p. 476), lalu diskalakan menjadi 70 + 10 Z.

Seluruh data adalah data simulasi. Respons dan hasil analisis bukan temuan artikel asal.

## Catatan penamaan berkas (2026-10-25)

Berkas data diganti nama agar sesuai nomor kasus di naskah: `kasusA_matematika*.xlsx` → `kasus7_matematika*.xlsx`; `kasusC_motivasi.xlsx` → `kasus6_motivasi.xlsx`. Isi berkas tidak berubah dan model tidak diestimasi ulang. Log eksekusi di folder ini dibuat sebelum penggantian nama, sehingga masih memuat nama berkas lama.
