# bifaktor-mirt-r

Script R dan dataset pendamping buku **Bifactor-MIRT dalam Pendidikan: Konsep dan Analisis dengan R** (Heri Retnawati & Kartianom, UNY Press).

## Cara memakai
1. Unduh repositori ini (tombol **Code → Download ZIP**) lalu ekstrak.
2. Buka folder bab yang sedang dipelajari, misalnya `bab07/`. Setiap folder bab berisi script `.R`, dataset `.xlsx`, dan `README.md`.
3. Buka script di RStudio, arahkan folder kerja ke folder bab tersebut (`setwd()` atau *Session → Set Working Directory → To Source File Location*), lalu jalankan baris demi baris sesuai penjelasan di buku.

Paket yang diperlukan:
```r
install.packages(c("openxlsx", "mirt", "BifactorIndicesCalculator",
                   "psych", "GPArotation", "lavaan"))
```
`openxlsx` dan `mirt` dipakai di semua bab. `BifactorIndicesCalculator` dipakai pada Bab 8, 11, 13, dan 14; `psych` dan `GPArotation` pada Bab 13; `lavaan` pada Bab 14. Script diuji dengan R 4.6.1 dan mirt 1.48; versi lengkap paket tercatat pada `sessionInfo()` di akhir setiap log.

## Isi
| Folder | Isi |
|---|---|
| `bab05/` | Simulasi identifikasi empiris dan perencanaan ukuran sampel (ilustrasi Bab 5) |
| `bab06/` | Estimasi tujuh model bifaktor (Kasus 1 dan Kasus 2) |
| `bab07/` | Kecocokan model bifaktor dan model pesaing |
| `bab08/` | Indeks evaluasi bifaktor |
| `bab09/` | Parameter butir bersyarat, marginal, dan IRT proyektif |
| `bab10/` | Skor faktor umum dan faktor spesifik |
| `bab11/` | Model orde kedua, faktor spesifik runtuh, bifaktor tidak lengkap (Kasus 3) |
| `bab12/` | Model testlet dan *two-tier* (Kasus 4 dan Kasus 5) |
| `bab13/` | Bifaktor eksploratori (Kasus 6) |
| `bab14/` | Studi kasus terpadu (Kasus 7) |
| `bab15/` | Invariansi pengukuran dan DIF (Kasus 8) |

Bab 1–4 dan Bab 16 adalah bab konsep, sehingga tidak memiliki folder script. Folder `bab12/` sampai `bab15/` juga memuat dataset parameter sejati (`*_sejati.xlsx`).

## Catatan data
Seluruh dataset adalah data simulasi. Nama dataset diawali nomor kasusnya di buku (`kasusN_...xlsx`, misalnya `kasus1_2pl_matematika.xlsx` untuk Kasus 1). Konteks kasus mengadopsi artikel yang dirujuk di buku, tetapi nilai respons dan hasil analisisnya bukan temuan artikel asal.

## Lisensi
Belum ditetapkan (usulan: MIT untuk kode, CC BY 4.0 untuk data).
