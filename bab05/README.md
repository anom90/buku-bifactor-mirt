# Bab 5 Identifikasi empiris dan perencanaan ukuran sampel

Unduh seluruh isi folder ini ke satu folder kerja, buka script di RStudio, lalu pilih
*Session > Set Working Directory > To Source File Location*.

| Script | Dataset | Isi | Waktu jalan |
|---|---|---|---|
| `bab05_identifikasi_empiris.R` | `kasus3_efikasidiri.xlsx` | GRM bifaktor lengkap (EM dan MH-RM) dan bifaktor tidak lengkap; ilustrasi masalah identifikasi empiris (Chen & Fujimoto, 2022) | sekitar 1 menit |
| `bab05_ukuran_sampel_2pl.R` | `kasus1_2pl_matematika_sejati.xlsx` | Simulasi Monte Carlo ukuran sampel 2PL bifaktor (N = 250, 500, 1.000; 100 replikasi) dengan kerangka ADEMP (Morris et al., 2019) dan kriteria bias relatif ≤ 10% (Muthén & Muthén, 2002) | sekitar 32 menit |

Paket yang diperlukan:
```r
install.packages(c("openxlsx", "mirt"))
```

## Data
**`kasus3_efikasidiri.xlsx`.** Data simulasi angket efikasi diri berbicara berdesain ESES (Zhang et al., 2023, p. 575): 12 butir skala 1-5, empat subskala (topik TP1-TP3, organisasi OR4-OR6, bahasa BH7-BH9, penyampaian PY10-PY12), 203 responden. Muatan baku pembangkit diadopsi dari model bifaktor Zhang et al. (2023, p. 577); muatan spesifik TP2 dibatasi -0,58 (asli -0,70) agar varians unik tidak negatif. Data ini disebut Kasus 3 di buku (Bab 5 dan Bab 11).

**`kasus1_2pl_matematika_sejati.xlsx`.** Parameter pembangkit data Kasus 1 (tes matematika 21 butir, Bab 6).

## Luaran
- `hasil_ukuran_sampel_2pl.xlsx`: tabel ukuran kinerja simulasi (dibaca oleh naskah Bab 5).
- `log_bab05_identifikasi_empiris.txt` dan `log_bab05_ukuran_sampel_2pl.txt`: log eksekusi asli (`Rscript script.R > log.txt 2>&1`), termasuk `sessionInfo()`. Log simulasi ukuran sampel dibuat 2026-10-24 ketika berkas parameter masih bernama `bif_2pl_matematika_sejati.xlsx`; isi berkas tidak berubah, sehingga script tidak dijalankan ulang (sekitar 32 menit). Log identifikasi empiris dibuat ulang 2026-10-25 dengan nama berkas baru.

Seluruh data adalah data simulasi. Respons dan hasil analisis bukan temuan artikel asal.
