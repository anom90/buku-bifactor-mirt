# Bab 12 Model testlet dan model two-tier

| Berkas | Isi |
|---|---|
| `bab12_testlet_two_tier.R` | Script bab (#12.5_1–#12.5_54) |
| `kasus4_testlet_matematika.xlsx` | Kasus 4: tes literasi matematika berbasis stimulus, 25 butir dikotomus, 5 testlet × 5 butir, N = 2.000 |
| `kasus5_twotier_pisa.xlsx` | Kasus 5: tes gabungan matematika (12 butir: 2 testlet × 4 + 4 butir lepas) dan membaca (12 butir: 3 testlet × 4), N = 3.000 |
| `kasus4_testlet_matematika_sejati.xlsx`, `kasus5_twotier_pisa_sejati.xlsx` | Parameter sejati butir (sheet 1) dan kemampuan sejati (sheet 2) |
| `log_bab12_testlet_two_tier.txt` | Log eksekusi asli (`Rscript bab12_testlet_two_tier.R > log_bab12_testlet_two_tier.txt 2>&1`), termasuk `sessionInfo()` |

Paket: openxlsx, mirt. Jadikan folder ini folder kerja (`setwd()`), lalu jalankan script baris demi baris. Waktu jalan sekitar 10 menit (R 4.6.1, mirt 1.48); bagian terlama adalah model bifaktor Kasus 4 (sekitar 950 siklus EM) dan statistik C2 dengan `QMC = TRUE`.

Desain data:
- Kasus 4 mengikuti simulasi DeMars (2006, pp. 149-150, Tabel 1, butir 1-25). Slope testlet 0; 0,3; 0,6; 0,9; 1,2 sama dalam satu testlet dan tidak proporsional terhadap slope primer, sehingga data mengikuti model bifaktor. Testlet 1 sengaja tanpa efek testlet. Slope dan intersep DeMars dikalikan 1,7 karena mirt tidak memakai konstanta D; asimtot bawah 0,20 ditiadakan.
- Kasus 5 meniru struktur Buklet 8 PISA 2000 (Cai, 2010, pp. 595-599) dalam ukuran kecil. Korelasi matematika-membaca 0,80. Slope dan intersep mengikuti distribusi Meng et al. (2022, pp. 7-10).

Isi analisis:
- Kasus 4: Q3 dari model unidimensi, model testlet Rasch, model testlet 2PL (`CONSTRAIN` + `FREE` varians efek testlet di `model2`; Paek & Cole, 2020, pp. 251-255), model 2PL bifaktor, perbandingan bersarang, varians efek testlet, bias slope dan reliabilitas bila testlet diabaikan, serta model bifaktor tidak lengkap untuk testlet tanpa efek.
- Kasus 5: model dua faktor berkorelasi, model bifaktor satu dimensi primer, dan model two-tier (`MAT = 1-12`, `BACA = 13-24`, `FREE = (GROUP, COV_21)` di `model2`; Paek & Cole, 2020, pp. 258-259).

Seluruh data adalah data simulasi. Respons dan hasil analisis bukan temuan artikel asal.

## Catatan penamaan berkas (2026-10-25)

Berkas data diganti nama agar sesuai nomor kasus di naskah: `testlet_matematika*.xlsx` → `kasus4_testlet_matematika*.xlsx`; `twotier_pisa*.xlsx` → `kasus5_twotier_pisa*.xlsx`. Isi berkas tidak berubah dan model tidak diestimasi ulang. Log eksekusi di folder ini dibuat sebelum penggantian nama, sehingga masih memuat nama berkas lama.
