# Bab 15 Invariansi pengukuran dan DIF pada model bifaktor

| Berkas | Isi |
|---|---|
| `bab15_invariansi_dif.R` | Script bab (#15.5_1–#15.5_71): uji invariansi menyeluruh, rerata faktor spesifik, pemilihan anchor (satu per bacaan), uji DIF per butir dengan koreksi Benjamini-Hochberg, jenis parameter ber-DIF, dan model invariansi parsial |
| `kasus8_membaca.xlsx` | Kasus 8: tes pemahaman bacaan 12 butir (3 bacaan × 4 butir, skor 0–4), kolom `jk` (P = perempuan, kelompok rujukan; L = laki-laki, kelompok fokal), N = 1.200 (600 + 600) |
| `kasus8_membaca_sejati.xlsx` | Parameter sejati butir kedua kelompok (sheet `parameter`) dan kemampuan sejati (sheet `theta`) |
| `log_bab15_invariansi_dif.txt` | Log eksekusi asli (`Rscript bab15_invariansi_dif.R > log_bab15_invariansi_dif.txt 2>&1`), termasuk `sessionInfo()` |

Paket: openxlsx, mirt. Jadikan folder ini folder kerja (`setwd()`), lalu jalankan script baris demi baris. Waktu jalan sekitar 12 menit (R 4.6.1, mirt 1.48), karena lebih dari 30 model multikelompok diestimasi dengan `bfactor()`.

Desain data: model representatif dan nilai parameter mengikuti Liu & Thompson (2022, pp. 982–988): muatan umum 0,7 dan muatan spesifik 0,5; selisih rerata faktor umum 0,2; rerata faktor spesifik kelompok fokal 0,1; 0; 0,1; DIF 0,15 pada butir keempat setiap bacaan. Adaptasi penulis: tiga jenis DIF dalam satu dataset (B04 ambang, B08 muatan umum, B12 muatan spesifik).

Catatan teknis: rerata faktor spesifik tidak dibebaskan dengan `invariance = "free_means"`, karena pilihan itu membebaskan rerata semua faktor dan membuat solusi tidak stabil. Rerata kelompok fokal diatur melalui tabel `pars = "values"`, dengan rerata faktor spesifik bacaan 2 tetap 0 sebagai rujukan.

Seluruh data adalah data simulasi. Respons dan hasil analisis bukan temuan artikel asal.

## Catatan penamaan berkas (2026-10-25)

Berkas data diganti nama agar sesuai nomor kasus di naskah: `kasusE_membaca*.xlsx` → `kasus8_membaca*.xlsx`. Isi berkas tidak berubah dan model tidak diestimasi ulang. Log eksekusi di folder ini dibuat sebelum penggantian nama, sehingga masih memuat nama berkas lama.
