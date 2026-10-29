# Laporan Singkat Pembaruan Nomenklatur SIARJUNA

Oct 28, 2026 · @Direktorat Inovasi Pembelajaran Digital

Usulan pembaruan tabel `ms_nomenklatur` mengubah 52 baris dan menambah 530 baris, sehingga datanya naik dari 1.370 menjadi 1.900 baris. Tidak ada baris yang dihapus, dan `kode_prodi` yang sudah ada tidak berubah. Usulan ini sudah diuji di database sementara, tetapi belum diterapkan di server.

## Sumber per jenjang

Semua jenjang mengacu ke tiga dokumen resmi; tidak ada sumber tidak resmi yang dipakai.

| Jenjang | Dokumen resmi | Yang diambil |
| --- | --- | --- |
| S1 | [Kepdirjen Dikti No. 96/B/KPT/2025](https://lpmpp.isbiaceh.ac.id/wp-content/uploads/2025/11/7-70_-Salinan-96_B_KPT_2025_251105_101935_251114_163645.pdf) (9 Sep 2025), Lampiran I, dan [Surat Ditjen Dikti No. 1145/DST/B3/DT.03.02/2026](https://lldikti6.id/wp-content/uploads/2026/02/Pembukaan-Usulan-SIAGA.pdf) (14 Feb 2026) | Nama bercentang S yang berstatus "Dibuka" di lampiran surat; 4 S1 kesehatan yang ada di UNESA diambil dari Kepdirjen 96 saja |
| S2 | [Kepdirjen Dikti No. 96/B/KPT/2025](https://lpmpp.isbiaceh.ac.id/wp-content/uploads/2025/11/7-70_-Salinan-96_B_KPT_2025_251105_101935_251114_163645.pdf), Lampiran I | Nama bercentang M |
| S3 | [Kepdirjen Dikti No. 96/B/KPT/2025](https://lpmpp.isbiaceh.ac.id/wp-content/uploads/2025/11/7-70_-Salinan-96_B_KPT_2025_251105_101935_251114_163645.pdf), Lampiran I | Nama bercentang Dr |
| Profesi | [Kepdirjen Dikti No. 96/B/KPT/2025](https://lpmpp.isbiaceh.ac.id/wp-content/uploads/2025/11/7-70_-Salinan-96_B_KPT_2025_251105_101935_251114_163645.pdf), Lampiran II bagian I | Profesi yang ada di UNESA: Dokter, Dokter Gigi, Ners, Bidan |
| D3 | [Kepdirjen Diksi No. 27/D/M/2022](https://lldikti3.kemdiktisaintek.go.id/wp-content/uploads/2024/07/Kepdirjen-Diksi-No.-27-Tahun-2022-Tentang-Daftar-Nama-Profram-Studi-Jenis-Pendidikan-Tinggi-Vokasi.pdf) (14 Mar 2022), Lampiran I | Nama bercentang D.Tiga |
| D4 (Sarjana Terapan) | [Kepdirjen Diksi No. 27/D/M/2022](https://lldikti3.kemdiktisaintek.go.id/wp-content/uploads/2024/07/Kepdirjen-Diksi-No.-27-Tahun-2022-Tentang-Daftar-Nama-Profram-Studi-Jenis-Pendidikan-Tinggi-Vokasi.pdf), Lampiran I | Nama bercentang S.Tr |

Status "Dibuka" untuk D3, D4, dan Profesi mengikuti Surat 1145/2026 butir 3.a: program ini tidak harus STEM dan tidak ada daftar moratoriumnya. Salinan dokumen diunduh dari ISBI Aceh (Kepdirjen 96), LLDIKTI VI (Surat 1145), dan LLDIKTI III (Kepdirjen Diksi 27).

## Baris yang diubah (52 baris)

52 baris lama diubah (57 nilai): 28 baris berubah isi dan 24 baris hanya dirapikan spasinya. Perubahan isi mengikuti ejaan dan inisial gelar di Kepdirjen Dikti 96/B/KPT/2025.

### Nama disesuaikan dengan Kepdirjen 96/2025 (5 baris)

| Kode | Jenjang | Lama | Baru |
| --- | --- | --- | --- |
| 5030416005 | S1 | Manajemen Ritel | Manajemen Retail (juga sesuai SIAGA 2026) |
| 5050116073 | S1 | Pendidikan Vokasional Desain Fashion | Pendidikan Vokasional Desain Mode (juga sesuai SIAGA 2026) |
| 5060118017 | S2 | Rekayasa Penginderaan Jauh | Rekayasa Pengindraan Jauh |
| 5060118062 | S2 | Teknik Penginderaan Jauh | Teknik Pengindraan Jauh |
| 5160118019 | S2 | Penginderaan Jauh | Pengindraan Jauh |

### Salah ketik dan format nama (16 nilai)

- "RekayasaTelekomunikasi" dan "TeknikTelekomunikasi" menjadi "Rekayasa Telekomunikasi" dan "Teknik Telekomunikasi": 6 baris S1, S2, S3 (5060116045, 5060116091, 5060118044, 5060118088, 5060119036, 5060119172)
- "Rekayasa Perkeretapian" dan "Teknik Perkeretapian" menjadi "Perkeretaapian": 2 baris S1 (5060116044, 5060116090)
- "Ilmu Bahan/ Ilmu Material" dan "Sains Bahan/ Sains Material": spasi setelah "/" dihapus, 4 baris S2 dan S3 (3000718001, 3000718002, 3000719001, 3000719002)
- "KOREOGRAFI INKUIRI" menjadi "Koreografi Inkuiri" (1000416016, S1)
- "Pendidikan Bahasa dan sastra Aceh" menjadi "Pendidikan Bahasa dan Sastra Aceh" (5050116076, S1)
- "Pengelolaan Sumberdaya Alam dan Lingkungan" menjadi "Pengelolaan Sumber Daya Alam dan Lingkungan" (5070118013, S2)
- "Pembangunan dan Keuangan Berkelanjutan, Program Magister Universitas Udayana" menjadi "Pembangunan dan Keuangan Berkelanjutan" (5160118034, S2)

### Gelar dibakukan sesuai inisial Kepdirjen 96/2025 (11 baris)

| Lama | Baru | Kode |
| --- | --- | --- |
| S.Pd | Pd. | 1000216034 |
| Sn | Sn. | 1000416016, 1000416017 |
| M | Pi. | 5010118007, 5010118008 |
| M.Ds. | Ds. | 5020218003 |
| Dr. | Ds. | 5020219003 |
| S.E | Bns. | 5030216010 |
| S.E | M. | 5030416005 |
| sarjana pendidikan (SPd) | Pd. | 5050116076 |
| E | E. | 5160118034 |

### Nama Inggris dan spasi

- "INVESTIGATION OF CHOREOGRAPHY" menjadi "Choreographic Inquiry" (1000416016), sesuai Kepdirjen 96/2025.
- 24 nilai di 24 baris hanya dihapus spasi berlebihnya, misalnya "Fisioterapi␣" dan "Electrical␣␣Power Engineering". Isi namanya tidak berubah, jadi bagian ini tidak memerlukan sumber.

## Baris yang ditambahkan (530 baris)

530 baris baru ditambahkan untuk enam jenjang; 494 di antaranya vokasi (D3 dan D4). Jenis pendidikan baru "Pendidikan Vokasi" (kode 3) juga ditambahkan di tabel `ms_jns_pendidikan` untuk baris D3 dan D4.

| Jenjang | Jumlah | Nama prodi | Sumber |
| --- | --- | --- | --- |
| S1 | 5 | Akuakultur, Manajemen Sumber Daya Perairan, Pengelolaan Sumber Daya Perairan, Desain Mode, Kesehatan Lingkungan | [Kepdirjen Dikti 96/B/KPT/2025](https://lpmpp.isbiaceh.ac.id/wp-content/uploads/2025/11/7-70_-Salinan-96_B_KPT_2025_251105_101935_251114_163645.pdf) + [Surat 1145/DST/B3/DT.03.02/2026](https://lldikti6.id/wp-content/uploads/2026/02/Pembukaan-Usulan-SIAGA.pdf) (Dibuka) |
| S1 | 4 | Kedokteran, Kedokteran Gigi, Keperawatan, Kebidanan | [Kepdirjen Dikti 96/B/KPT/2025](https://lpmpp.isbiaceh.ac.id/wp-content/uploads/2025/11/7-70_-Salinan-96_B_KPT_2025_251105_101935_251114_163645.pdf); prodi yang ada di UNESA |
| S2 | 12 | Ekonomi Syariah, Akuakultur, Desain Mode, Pendidikan Agama Islam, Sains Teknologi Laboratorium Medik, Hukum Syariah, Kenotariatan, Inovasi Sistem dan Teknologi, Kajian Ketahanan Nasional, Kajian Strategis dan Global, Kajian Terorisme, Ketahanan Nasional | [Kepdirjen Dikti 96/B/KPT/2025](https://lpmpp.isbiaceh.ac.id/wp-content/uploads/2025/11/7-70_-Salinan-96_B_KPT_2025_251105_101935_251114_163645.pdf) |
| S3 | 11 | Ekonomi Syariah, Akuakultur, Manajemen Sumber Daya Perairan, Pengelolaan Sumber Daya Perairan, Desain Mode, Evaluasi Pendidikan, Pendidikan Agama Islam, Kajian Ketahanan Nasional, Kajian Strategis dan Global, Kajian Terorisme, Ketahanan Nasional | [Kepdirjen Dikti 96/B/KPT/2025](https://lpmpp.isbiaceh.ac.id/wp-content/uploads/2025/11/7-70_-Salinan-96_B_KPT_2025_251105_101935_251114_163645.pdf) |
| Profesi | 4 | Pendidikan Profesi Dokter, Dokter Gigi, Ners, Bidan | [Kepdirjen Dikti 96/B/KPT/2025](https://lpmpp.isbiaceh.ac.id/wp-content/uploads/2025/11/7-70_-Salinan-96_B_KPT_2025_251105_101935_251114_163645.pdf) Lampiran II |
| D3 | 256 | Rincian per bidang di bawah | [Kepdirjen Diksi 27/D/M/2022](https://lldikti3.kemdiktisaintek.go.id/wp-content/uploads/2024/07/Kepdirjen-Diksi-No.-27-Tahun-2022-Tentang-Daftar-Nama-Profram-Studi-Jenis-Pendidikan-Tinggi-Vokasi.pdf) |
| D4 | 238 | Rincian per bidang di bawah | [Kepdirjen Diksi 27/D/M/2022](https://lldikti3.kemdiktisaintek.go.id/wp-content/uploads/2024/07/Kepdirjen-Diksi-No.-27-Tahun-2022-Tentang-Daftar-Nama-Profram-Studi-Jenis-Pendidikan-Tinggi-Vokasi.pdf) |
| **Jumlah** | **530** |  |  |

### Rincian D3 dan D4 per bidang

| Bidang | D3 | D4 | Contoh prodi |
| --- | --- | --- | --- |
| Rekayasa dan teknologi | 79 | 64 | Teknologi Mesin, Teknologi Sipil, Teknologi Rekayasa Otomotif |
| Seni dan bahasa | 24 | 32 | Fotografi, Bahasa Inggris untuk Industri Pariwisata |
| Pertanian, peternakan, perikanan | 25 | 28 | Agribisnis, Budi Daya Ikan, Teknologi Pakan Ternak |
| Bisnis, manajemen, akuntansi, logistik | 27 | 24 | Akuntansi, Administrasi Bisnis, Manajemen Logistik |
| Kesehatan | 28 | 20 | Fisioterapi, Keperawatan, Teknologi Laboratorium Medis |
| Komputer dan statistika | 11 | 11 | Teknologi Rekayasa Perangkat Lunak, Statistika Terapan |
| Transportasi | 11 | 10 | Manajemen Transportasi Udara, Studi Nautika |
| Sosial, ekonomi, hukum, urusan publik | 4 | 16 | Administrasi Publik, Paralegal, Pekerjaan Sosial |
| Multi-/inter-/transdisiplin | 7 | 12 | Animasi, Sains Data Terapan, Teknologi Pangan |
| Arsitektur dan desain | 10 | 7 | Desain Grafis, Desain Interior, Desain Busana |
| Pariwisata | 8 | 6 | Perhotelan, Seni Kuliner |
| Kehutanan dan lingkungan | 8 | 1 | Pengelolaan Hutan, Pengelolaan Lingkungan |
| Komunikasi | 6 | 2 | Hubungan Masyarakat, Penyiaran |
| Kimia dan biologi | 4 | 3 | Analisis Kimia, Kimia Industri |
| Sains informasi | 2 | 2 | Perpustakaan, Kearsipan |
| Keolahragaan | 2 | 0 | Kepelatihan Olahraga, Pencak Silat |
| **Jumlah** | **256** | **238** |  |

## Catatan

Kode baris baru adalah kode internal aplikasi, karena dokumen resmi tidak memuat kode prodi.

- Segmen jenjang di `kode_prodi` baru: Profesi 17, D3 25, D4 26.
- 6 baris lama diusulkan dinonaktifkan (duplikat, moratorium S1, atau tidak tercantum di sumber). Usulan ini tidak dijalankan.
- Daftar lengkap per baris (kode, nilai lama dan baru, sumber) ada di CSV perbandingan dan CSV vokasi di folder `docs/nomenklatur` repositori siarjuna-v13.
- Skrip pembaruan hanya berisi `UPDATE` dan `INSERT` dalam satu transaksi, tanpa membuat tabel baru. Nilai yang di server sudah diubah orang lain dilewati, tidak ditimpa.
- Untuk membatalkan, tersedia skrip `ms_nomenklatur_pembatalan_2026-10-28.sql`: mengembalikan 57 nilai lama, menghapus baris tambahan yang belum dipakai ajuan, dan menghapus jenis "Pendidikan Vokasi" bila tidak dipakai.
- Setelah disetujui, skrip SQL dijalankan dulu di salinan database `siaga`, baru kemudian di server.
