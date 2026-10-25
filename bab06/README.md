# Model Bifaktor IRT untuk Data Dikotomus dan Politomus

Unduh seluruh isi folder ini ke satu folder kerja, buka script di RStudio, lalu pilih
*Session > Set Working Directory > To Source File Location*.

| Script | Dataset | Model |
|---|---|---|
| `bab06a_bifaktor_dikotomus.R` | `kasus1_2pl_matematika.xlsx` | 2PL bifaktor (`bfactor()`) |
| | `kasus1_3pl_matematika.xlsx` | 3PL bifaktor dengan asimtot bawah ditetapkan 0,20 |
| | `kasus1_rasch_matematika.xlsx` | Rasch bifaktor dan 1PL bifaktor (`bfactor()` dengan `model2`) |
| `bab06b_bifaktor_politomus.R` | `kasus2_grm_efikasi.xlsx` | GRM bifaktor (`bfactor()`) |
| | `kasus2_gpcm_efikasi.xlsx` | GPCM bifaktor (`bfactor()`, `itemtype = "gpcm"`) |
| | `kasus2_pcm_efikasi.xlsx` | PCM bifaktor (`bfactor()`, slope ditetapkan 1) |

## Skenario kasus
**Kasus 1: tes matematika (dikotomus).** Tes pilihan ganda 21 butir mengukur kemampuan matematika umum dan tiga domain: aljabar (ALJ1-ALJ7), geometri (GEO1-GEO7), dan trigonometri (TRG1-TRG7). Peserta 899 siswa (2.000 siswa untuk data 3PL). Contoh struktur ini mengikuti ilustrasi Paek & Cole (2020, p. 239). Untuk model 3PL, setiap butir memiliki lima pilihan jawaban.

**Kasus 2: angket efikasi diri (politomus).** Angket efikasi diri berbicara di depan umum dalam bahasa Inggris, dengan empat subskala yang diadopsi dari Zhang et al. (2023): topik (TP), organisasi (OR), bahasa (BH), dan penyampaian (PY). Setiap subskala terdiri atas 6 butir dengan skala 0 = sangat tidak setuju, 1 = tidak setuju, 2 = setuju, 3 = sangat setuju. Responden 1.821 mahasiswa. Model GPCM dan PCM memakai 12 butir subskala topik dan organisasi, seperti contoh Paek & Cole (2020, p. 249).

Seluruh data adalah **data simulasi**. Respons dan hasil analisis bukan temuan artikel asal.

## Log eksekusi
`log_bab06a_bifaktor_dikotomus.txt` (±1 menit) dan `log_bab06b_bifaktor_politomus.txt` (±1,5 menit) adalah log eksekusi asli (`Rscript script.R > log.txt 2>&1`, R 4.6.1, mirt 1.48), diakhiri `sessionInfo()`.
