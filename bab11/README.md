# Bab 11 Model orde kedua dan model bifaktor tidak lengkap

| Berkas | Isi |
|---|---|
| `bab11_orde_kedua_tidak_lengkap.R` | Script bab (#11.5_1–#11.5_47) |
| `kasus2_grm_efikasi.xlsx` | Kasus 2: angket efikasi diri berbicara 24 butir (0-3), 4 subskala × 6, N = 1.821 (salinan dari `bab06/`) |
| `kasus3_efikasidiri.xlsx` | Kasus 3: angket berdesain ESES 12 butir (1-5), 4 subskala × 3, N = 203 (sama dengan data Bab 5 di `bab05/`) |
| `log_bab11_orde_kedua_tidak_lengkap.txt` | Log eksekusi asli (`Rscript bab11_orde_kedua_tidak_lengkap.R > log_bab11_orde_kedua_tidak_lengkap.txt 2>&1`), termasuk `sessionInfo()` |

Paket: openxlsx, mirt, BifactorIndicesCalculator. Jadikan folder ini folder kerja (`setwd()`), lalu jalankan script baris demi baris. Waktu jalan sekitar 8 menit (R 4.6.1, mirt 1.48, BifactorIndicesCalculator 0.2.2); bagian terlama adalah model orde kedua Kasus 2 (sekitar 2 menit) dan model bifaktor lengkap Kasus 3 yang tidak konvergen dalam 3.000 siklus EM.

Isi analisis:
- Kasus 2: GRM bifaktor vs GRM orde kedua. Model orde kedua = bifaktor dengan slope umum dan slope spesifik setiap butir disamakan (`CONSTRAIN` di `model2`) dan varians faktor spesifik dibebaskan (tabel `pars`), mengikuti Rijmen (2010, pp. 365-366) dan Paek & Cole (2020, pp. 250-251).
- Kasus 3: diagnosis faktor spesifik topik yang runtuh (ωHS dari solusi EM dan MH-RM), model bifaktor tidak lengkap (`NA` pada vektor `model`), dan model orde kedua tidak lengkap.

Seluruh data adalah data simulasi. Respons dan hasil analisis bukan temuan artikel asal.

## Catatan penamaan berkas (2026-10-25)

Berkas data diganti nama agar sesuai nomor kasus di naskah: `bif_grm_efikasi.xlsx` → `kasus2_grm_efikasi.xlsx`; `kasusB_efikasidiri.xlsx` → `kasus3_efikasidiri.xlsx`. Isi berkas tidak berubah dan model tidak diestimasi ulang. Log eksekusi di folder ini dibuat sebelum penggantian nama, sehingga masih memuat nama berkas lama.
