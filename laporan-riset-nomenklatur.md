# Laporan Riset dan Pembaruan Data Referensi Nomenklatur (`ms_nomenklatur`)

| | |
|---|---|
| Aplikasi | SIARJUNA v13 (Laravel 13), koneksi `siagasiakadu`, database `siaga` |
| Data yang dianalisis | `ms_nomenklatur.sql` (dump Navicat, 28 Oktober 2026 11:23, 1.370 baris) |
| Tanggal riset | 28 Oktober 2026 |
| Disusun | dengan bantuan Claude (asisten AI); semua angka di bawah dapat ditelusuri ke file di folder ini |
| Status | **Kandidat, belum diterapkan.** Perlu ditinjau sebelum dijalankan di server |

## 1. Ringkasan

- **Acuan resmi yang berlaku:** Keputusan Dirjen Pendidikan Tinggi Kemdiktisaintek **Nomor 96/B/KPT/2025** (9 September 2025). Keputusan ini mencabut Kepdirjen 163/E/KPT/2022 sepanjang mengenai nama program studi. Hampir semua baris tabel dibuat pada 19 September 2023, jadi kemungkinan besar masih mengikuti versi 2022.
- **Acuan program Sarjana untuk usul prodi baru:** Surat Ditjen Dikti **Nomor 1145/DST/B3/DT.03.02/2026** (14 Februari 2026) beserta lampirannya, yaitu daftar program Sarjana berstatus "Dibuka" atau "Moratorium".
- **Hasil perbandingan:** 1.324 dari 1.370 baris masih sesuai. Baris S1 di tabel praktis sama dengan daftar "Dibuka" di SIAGA, karena S1 yang dimoratorium memang tidak dimasukkan.
- **Yang diusulkan berubah:**
  - **52 baris diperbaiki** (57 nilai): salah ketik, format, spasi, format gelar, dan 5 nama yang disesuaikan dengan ejaan resmi.
  - **530 baris baru** (S1 9, S2 12, S3 11, Profesi 4, D3 256, D4 238).
  - **6 baris diusulkan nonaktif**, tetapi tidak dijalankan.
- **Yang tidak diubah dan perlu konfirmasi:** 8 baris dengan ejaan yang berbeda antardokumen resmi, 10 baris S1 yang tidak tercantum di lampiran SIAGA 2026, 1 nama yang tidak tercantum tetapi sudah dipakai ajuan, dan status STEM/Dibuka untuk 13 baris baru.
- **Uji di database sementara lolos:** 1.370 → 1.900 baris, tidak ada baris yang hilang, tidak ada duplikat, dan aman dijalankan ulang. Skrip hanya berisi `UPDATE` dan `INSERT` (tanpa membuat tabel); nilai yang di server sudah berbeda dari dump dilewati, tidak ditimpa. Pembatalannya ada di skrip terpisah.
- **Prodi kesehatan yang ada di UNESA:** atas permintaan, SQL yang sama juga menambahkan S1 Kedokteran, Kedokteran Gigi, Keperawatan, dan Kebidanan, serta Profesi Dokter, Dokter Gigi, Ners, dan Bidan (Lampiran II R1). S1 Fisioterapi sudah ada di tabel. Profesi lain di Lampiran II, serta 62 program Spesialis dan 230 Subspesialis, hanya diekstrak sebagai referensi (lihat Bagian 12).
- **Vokasi (D3 dan Sarjana Terapan):** atas permintaan, SQL yang sama menambahkan **494 baris vokasi** (D3 256, D4 238; 484 nama prodi) dari Lampiran I **Kepdirjen Pendidikan Vokasi Nomor 27/D/M/2022** (R6), serta jenis pendidikan baru "Pendidikan Vokasi" (kode 3) di `ms_jns_pendidikan`. Sebelumnya tabel tidak memiliki satu pun baris vokasi, padahal jenjang D3/D4 sudah ada di daftar jenjang SIAGA aplikasi. Rinciannya ada di Bagian 13.

## 2. Data yang dianalisis dan konteks aplikasi

### 2.1 Struktur tabel (dari dump)

| Kolom | Tipe | Keterangan dari data |
|---|---|---|
| `kode_prodi` | varchar(255), **PRIMARY KEY** | 10 digit: `kode_rumpun`(3) + `kode_sub_rumpun`(2) + jenjang (16=S1, 18=S2, 19=S3) + urut(3). Polanya konsisten di 1.369 baris; satu pengecualian adalah `5030418012` |
| `name_prodi`, `name_prodi_eng` | varchar(255) | Nama Indonesia dan Inggris |
| `program_id` | varchar(32) | `S1` 379, `S2` 586, `S3` 405 |
| `id_jenj_didik` | varchar(255) | 30/35/40 (S1/S2/S3), dipakai untuk menyaring dropdown |
| `jenis_pendidikan_id` | int4 | Selalu 1 (Pendidikan Akademik); tidak ada baris profesi |
| `gelar` | varchar(255) | Inisial gelar, mis. `T.`, `Pd.`, `Sos.` |
| `status_prodi_id`/`status_prodi` | int4/varchar | 1 = `STEM` (626), 2 = `Dibuka` (744); tidak ada nilai lain |
| `kode_rumpun`, `kode_sub_rumpun`, `rumpun_id` | varchar | 100/200/300/400/501–516; `rumpun_id` selalu sama dalam satu kelompok rumpun+sub |
| `is_kesehatan` | varchar | `1` untuk 84 baris |
| `id_sms` | varchar | UUID unik per baris; **disalin ke `tr_ajuan.id_sms`** saat prodi diajukan |
| `soft_delete`, `deleted_at` | varchar(1)/timestamp | Semua baris `0`/NULL |

Dump identik dengan isi database lokal (1.370 baris, tidak ada sel yang berbeda). **Perhatian:** dump diawali `DROP TABLE IF EXISTS`. Jangan menjalankan dump itu di server untuk "memperbarui" data, karena tabel akan dihapus lalu dibuat ulang.

### 2.2 Pemakaian di aplikasi (dicek di kode `siarjuna-v13`)

- `Fungsi::pilihan_nomenklatur()` membuat dropdown nomenklatur pada ajuan prodi. Penyaringnya hanya `jenis_pendidikan_id` dan `id_jenj_didik`, **tanpa memeriksa `deleted_at`/`soft_delete`**.
- `tr_ajuan.kode_prodi` merujuk `ms_nomenklatur.kode_prodi` lewat relasi Eloquent, **tanpa foreign key**. Ada 10 kode yang sedang dipakai ajuan: `5030218005, 5030319001, 2000416014, 2000119007, 5060119169, 5060116023, 5020116001, 5060119144, 5130116002, 2000118001`. Akibatnya, `kode_prodi` lama tidak boleh diganti atau dihapus.
- Ajuan prodi menyalin `ms_nomenklatur.id_sms` ke `tr_ajuan.id_sms`, jadi setiap baris baru wajib punya `id_sms` unik.
- Hapus di halaman Data Master Nomenklatur adalah **hapus permanen** (tidak memakai SoftDeletes).
- Kolom `status_prodi`, `is_kesehatan`, `rumpun_id`, dan `kode_sub_rumpun` tidak dipakai dalam logika aplikasi, hanya disimpan.
- Tabel lain yang memuat `kode_prodi`/`id_nomenklatur` (`sms`, `tr_tambah_nomenklatur`, `tr_ubah_nomenklatur`) tidak berisi kode dari tabel ini.

## 3. Sumber referensi

| No | Sumber/dokumen | Penerbit | Nomor & tanggal | Status keberlakuan (hasil verifikasi) | URL yang dipakai | Data yang didukung |
|---|---|---|---|---|---|---|
| R1 | Keputusan Dirjen Pendidikan Tinggi tentang Nama Program Studi pada Jenis Pendidikan Akademik dan Pendidikan Profesi | Direktorat Jenderal Pendidikan Tinggi, Kemdiktisaintek (ditandatangani Dirjen Khairul Munadi; salinan bercap "sesuai dengan aslinya" oleh Plt. Sekretaris Ditjen Dikti, Setiawan) | 96/B/KPT/2025, ditetapkan di Jakarta 9 September 2025 | **Berlaku** sejak tanggal ditetapkan (Diktum KELIMA). Diktum KEEMPAT mencabut Kepdirjen 163/E/KPT/2022 sepanjang mengenai nama prodi sarjana, magister, doktor, profesi, dan spesialis. Penelusuran sampai 28 Oktober 2026 tidak menemukan keputusan pengganti atau perubahan | Salinan yang diunduh: [lpmpp.isbiaceh.ac.id](https://lpmpp.isbiaceh.ac.id/wp-content/uploads/2025/11/7-70_-Salinan-96_B_KPT_2025_251105_101935_251114_163645.pdf) (47 hlm., 9.489.378 bita, SHA-256 `c8fd56c3c38f83e93874f4b331335e1056451e8f03aa959b4e6781d3789fdeeb`). Nama berkasnya sama dengan salinan di [LLDIKTI XV](https://lldikti15.kemdikbud.go.id/wp-content/uploads/2025/11/7-70_-Salinan-96_B_KPT_2025.pdf), yang tidak dapat diakses saat riset | Lampiran I (hlm. 4–31): 587 nama prodi akademik, nama Inggris, centang S/M/Dr, dan inisial gelar. Lampiran II (hlm. 32–47): pendidikan profesi, spesialis, dan subspesialis (Bagian 12) |
| R2 | Pengumuman "LLDIKTI Wilayah V Dukung Implementasi Keputusan Dirjen Dikti tentang Penyesuaian Nama Program Studi" | LLDIKTI Wilayah V, Kemdiktisaintek | 4 November 2025 | Penguat R1: menyebut 96/B/KPT/2025 sebagai pemutakhiran 163/E/KPT/2022 | [lldikti5.kemdiktisaintek.go.id](https://lldikti5.kemdiktisaintek.go.id/home/detailpost/lldikti-wilayah-v-dukung-implementasi-keputusan-dirjen-dikti-tentang-penyesuaian-nama-program-studi) | Status dan keterkaitan R1 |
| R3 | Surat "Pembukaan Penerimaan Usul Layanan Perizinan Kelembagaan Perguruan Tinggi tahun 2026" beserta lampirannya | Direktur Kelembagaan, Ditjen Dikti (Prof. Dr. Mukhamad Najib) | 1145/DST/B3/DT.03.02/2026, 14 Februari 2026 | **Berlaku untuk penerimaan usul tahun 2026** (Intake I 16 Feb–31 Mar 2026, Intake II 1 Jul–30 Sep 2026). Butir 3.b: program Sarjana hanya untuk prodi STEM yang tidak sedang dimoratorium, dengan daftar nama terlampir | [lldikti6.id](https://lldikti6.id/wp-content/uploads/2026/02/Pembukaan-Usulan-SIAGA.pdf) (teks asli PDF, bukan OCR) | 371 nama program Sarjana: 306 "Dibuka", 65 "Moratorium" |
| R4 | Peraturan Mendikbudristek tentang Penamaan Program Studi pada Perguruan Tinggi | Kemendikbudristek | No. 32 Tahun 2021 | Disebut sebagai dasar R1 (konsiderans dan Mengingat butir 4). Statusnya tidak diperiksa terpisah | – (dikutip dari R1) | Dasar hukum penamaan |
| R5 | Keputusan Dirjen Diktiristek tentang Nama Program Studi | Ditjen Diktiristek | 163/E/KPT/2022 | **Dicabut sebagian** oleh R1 (Diktum KEEMPAT). Dokumennya tidak diunduh | – | Diduga menjadi dasar data lama (tidak dipakai sebagai acuan) |
| R6 | Keputusan Dirjen Pendidikan Vokasi tentang Daftar Nama Program Studi Jenis Pendidikan Tinggi Vokasi | Direktorat Jenderal Pendidikan Vokasi, Kemendikbudristek (ditandatangani Dirjen Wikan Sakarinto; salinan "sesuai dengan aslinya" oleh Sekretaris Ditjen Pendidikan Vokasi, Dr. Wartanto) | 27/D/M/2022, ditetapkan di Jakarta 14 Maret 2022 | **Berlaku** sejak ditetapkan (Diktum KEDELAPAN). Diktum KETUJUH mencabut Kepdirjen Belmawa 232/B/HK/2019 sepanjang mengenai nama prodi vokasi. R1 hanya mengatur pendidikan akademik dan profesi, dan penelusuran sampai 28 Oktober 2026 tidak menemukan daftar nama prodi vokasi pengganti | [lldikti3.kemdiktisaintek.go.id](https://lldikti3.kemdiktisaintek.go.id/wp-content/uploads/2024/07/Kepdirjen-Diksi-No.-27-Tahun-2022-Tentang-Daftar-Nama-Profram-Studi-Jenis-Pendidikan-Tinggi-Vokasi.pdf) (42 hlm., 8.037.158 bita, SHA-256 `3542365b5b3ea638502db1bd59549e3f2a442aa2b9029a6250cd2960fef9f35f`) | Lampiran I (hlm. 6–34): nama prodi vokasi pada PT binaan Kemendikbudristek, nama Inggris, centang D.Satu–D.Tr, dan inisial gelar. Lampiran II (hlm. 35–42, PT binaan K/L lain) tidak dipakai |

Sumber sekunder, hanya sebagai konteks dan tidak menjadi dasar perubahan: pemberitaan Mei 2026 tentang istilah "Teknik/Rekayasa", misalnya [Kompas, 18 Mei 2026](https://www.kompas.com/edu/read/2026/05/18/104518471/kemendikti-tegaskan-tak-ubah-prodi-teknik-jadi-rekayasa-keduanya-tetap). Menurut berita itu, kementerian menegaskan tidak ada kewajiban mengganti "Teknik" menjadi "Rekayasa". Ini sejalan dengan teks R1 sendiri: "Rekayasa (masih bisa menggunakan kata TEKNIK)".

## 4. Metode verifikasi

1. **Struktur dan isi data.** Dump diurai menjadi data terstruktur, lalu dicocokkan sel demi sel dengan database lokal (hasilnya identik). Pemakaian tabel di kode aplikasi dibaca langsung.
2. **Ekstraksi Lampiran I R1.** PDF R1 adalah hasil pindaian dengan lapisan teks OCR, dan tanda centang S/M/Dr tidak terbaca di lapisan teks. Karena itu:
   - teks nama diambil dari lapisan OCR;
   - tanda centang/strip dibaca dari gambar halaman (150 dpi) pada posisi baris yang disejajarkan dengan nomor urut;
   - **171 baris diverifikasi visual** terhadap gambar halaman, termasuk semua baris yang menjadi dasar perubahan atau penambahan. Pembaca otomatis akhir benar pada 170 dari 171 baris itu; satu-satunya selisih (#487) dikoreksi manual.
   - Versi pembaca sebelumnya sempat salah membaca kolom Dr di 55 baris. Kesalahan ini ketahuan saat verifikasi visual dan sudah diperbaiki sebelum perbandingan akhir.
   - **20 kesalahan ejaan OCR** pada nama/nama Inggris resmi dikoreksi setelah dicek di gambar, misalnya "Mela30i" → "Melayu", "Pen3oaluhan" → "Penyuluhan", "llmu" → "Ilmu", dan teks judul grup yang ikut tergabung.
3. **Pencocokan nama.** Normalisasi huruf dan tanda baca, lalu pencocokan persis lebih dulu (1.008 baris). Bila tidak ketemu persis, dipakai padanan yang dinyatakan di R1 (330 baris): "Ilmu atau Sains X", "Manajemen atau Pengelolaan X", "Rekayasa X" ↔ "Teknik X" (grup Rekayasa), "A/B", dan nama alternatif "X atau Y". Tabel lama memang menyimpan setiap alternatif sebagai baris terpisah, misalnya "Ilmu Kebumian" dan "Sains Kebumian".
4. **Program Sarjana** dicocokkan pula dengan lampiran R3, dengan toleransi salah ketik di lampiran itu sendiri ("Konvervasi", "Insfrastruktur").
5. **Hanya perubahan berbukti yang masuk SQL.** Perbedaan yang dokumen resminya saling bertentangan, atau yang tanpa sumber resmi, ditandai *perlu verifikasi* dan tidak diubah.
6. **Lampiran I R6 (vokasi)** juga berupa pindaian dengan lapisan OCR. Garis tabel dan centang D.Tiga/S.Tr dibaca dari gambar halaman, lalu **semua halaman 6–34 dicek visual** baris demi baris untuk baris D3/S.Tr. Rinciannya di Bagian 13.2.

## 5. Temuan utama

1. **Sebagian besar data masih berlaku.** 1.324 baris cocok dengan nama dan jenjang di R1. Tidak ada baris yang namanya tercantum tetapi jenjangnya dicabut.
2. **Kesalahan data internal (bukan perubahan regulasi):**
   - salah ketik "RekayasaTelekomunikasi"/"TeknikTelekomunikasi" (6 baris) dan "Perkeretapian" (2 baris);
   - nama yang memuat ", Program Magister Universitas Udayana";
   - "Sumberdaya", spasi setelah "/", "KOREOGRAFI INKUIRI" dalam huruf kapital, dan "dan sastra" dengan huruf kecil;
   - spasi berlebih pada 24 nilai;
   - gelar dengan format tidak baku pada 11 baris ("S.Pd", "S.E", "sarjana pendidikan (SPd)", "M.Ds.", "Dr.", "M", "E", "Sn").
3. **Perubahan nama menurut R1:**
   - "Manajemen Ritel" → "Manajemen Retail" (juga di R3);
   - "Pendidikan Vokasional Desain Fashion" → "Pendidikan Vokasional Desain Mode" (juga di R3);
   - "Penginderaan Jauh" → "Pengindraan Jauh" (3 baris S2).
4. **Ejaan berbeda antardokumen resmi (tidak diubah):**

   | Database (= R3) | R1 |
   |---|---|
   | Pendidikan Bahasa Perancis | Pendidikan Bahasa Prancis |
   | Teknologi Pasca Panen | Teknologi Pascapanen |
   | Instrumentasi dan Otomasi | Instrumentasi dan Automasi |

   R1 sendiri masih memakai "Perancis" untuk Bahasa/Sastra/Kajian Perancis.
5. **Nomenklatur baru di R1 yang belum ada di tabel:** 530 baris (lihat Bagian 7.3). Contohnya Ekonomi Syariah (S2/S3), Akuakultur, Desain Mode, Pendidikan Agama Islam (S2/S3), Hukum Syariah, Kenotariatan, Ketahanan Nasional, dan Kajian Terorisme.
6. **Program Sarjana yang dimoratorium (R3):** 65 nama. Dua di antaranya masih ada di tabel: Manajemen Olahraga (`5130116004`) dan Manajemen Bencana (`5160116016`). Ada pula 79 nama S1 di R1 yang belum ada di tabel: 63 berstatus Moratorium di R3, 12 tidak tercantum di R3 (mis. Kedokteran, Keperawatan, Kebidanan, Ekonomi Syariah, Pendidikan Agama Islam), dan 4 berstatus Dibuka. Hanya 4 yang Dibuka yang ditambahkan; sisanya **sengaja tidak ditambahkan**, mengikuti pola data lama. Pengecualiannya adalah 4 S1 kesehatan yang ada di UNESA (Kedokteran, Kedokteran Gigi, Keperawatan, Kebidanan), yang ditambahkan atas permintaan (lihat Bagian 7.2).
7. **Tidak tercantum di R1:**
   - Pengajaran Fisika (S2);
   - Sains Laboratorium Klinis dan Sains Laboratorium Medis (S2). R1 memuat "Sains Teknologi Laboratorium Medik" (S2), tetapi tidak ada bukti eksplisit bahwa ini penggantinya;
   - Ilmu Ekonomi Islam (S3, ditambahkan 11 Maret 2026 dan sudah dipakai ajuan). R1 memuat "Ekonomi Syariah" dan "Ekonomi dan Keuangan Islam". Diktum KEDUA membolehkan PTN badan hukum memakai nama sepadan asal dilaporkan, jadi dasar penamaannya perlu dikonfirmasi.
8. **Duplikat:** "Manajemen Ritel" S1 ada dua (`5030416005` dan `5030418012`). Kode `5030418012` berpola S2 padahal programnya S1.
9. **Kesenjangan cakupan (di luar SQL ini):**
   - Lampiran II R1 (pendidikan profesi, spesialis, subspesialis) belum ada di tabel, padahal `ms_jns_pendidikan` memiliki "Pendidikan Profesi", sehingga dropdown untuk jenis profesi kosong. Empat profesi yang ada di UNESA kini ditambahkan (Bagian 12);
   - tabel tidak memiliki baris vokasi (D3/D4), padahal jenjang D3 (22) dan D4 (23) ada di daftar jenjang SIAGA dan sudah ada 2 ajuan D4. Kini ditambahkan dari R6 (Bagian 13);
   - "Kecerdasan Buatan" berstatus "Dibuka" untuk S1 di R3, tetapi R1 hanya mencentang M;
   - "Rekayasa Keamanan Siber" dan "Pendidikan Seni Budaya" ada di R3 tetapi tidak ada di Lampiran I R1;
   - `1000216034` Pendidikan Bahasa Melayu memakai `kode_rumpun` 100 (Humaniora), bukan 505 (Pendidikan).

## 6. Tabel perbandingan

Tabel lengkap untuk 1.370 baris ditambah 530 baris baru ada di `perbandingan-ms_nomenklatur-2026-10-28.csv`. CSV itu juga memuat nama Inggris resmi, inisial resmi, dan status SIAGA. Di bawah ini ditampilkan semua baris yang **bukan** "Sesuai", lalu baris yang hanya dirapikan formatnya.

### 6.1 Baris yang berubah, bermasalah, atau perlu konfirmasi

| No. | Data Saat Ini | Referensi Terbaru | Jenis Perubahan | Sumber Resmi | Tindakan yang Disarankan |
|---|---|---|---|---|---|
| 1 | `3000718001` S2 Ilmu Bahan/ Ilmu Material (gelar Si.) | #172 Ilmu atau Sains Bahan/Ilmu atau Sains Material [S/M/Dr: -VV], Si. | Perbaikan salah ketik/format | R1 #172 | Ubah (Bagian A) — name_prodi: "Ilmu Bahan/ Ilmu Material" -> "Ilmu Bahan/Ilmu Material" |
| 2 | `3000719001` S3 Ilmu Bahan/ Ilmu Material (gelar Si.) | #172 Ilmu atau Sains Bahan/Ilmu atau Sains Material [S/M/Dr: -VV], Si. | Perbaikan salah ketik/format | R1 #172 | Ubah (Bagian A) — name_prodi: "Ilmu Bahan/ Ilmu Material" -> "Ilmu Bahan/Ilmu Material" |
| 3 | `1000416016` S1 KOREOGRAFI INKUIRI (gelar Sn) | #10 Koreografi Inkuiri [S/M/Dr: V--], Sn.; R3: Dibuka (no. 17) | Perbaikan salah ketik/format | R1 #10; R3 no. 17 | Ubah (Bagian A) — gelar: "Sn" -> "Sn."; name_prodi: "KOREOGRAFI INKUIRI" -> "Koreografi Inkuiri"; name_prodi_eng: "INVESTIGATION OF CHOREOGRAPHY" -> "Choreographic Inquiry" |
| 4 | `5160118034` S2 Pembangunan dan Keuangan Berkelanjutan, Program Magister Universitas Udayana (gelar E) | #576 Pembangunan dan Keuangan Berkelanjutan [S/M/Dr: -V-], E. | Perbaikan salah ketik/format | R1 #576 | Ubah (Bagian A) — gelar: "E" -> "E."; name_prodi: "Pembangunan dan Keuangan Berkelanjutan, Program Magister Universitas Udayana" -> "Pembangunan dan Keuangan Berkelanjutan" |
| 5 | `5050116076` S1 Pendidikan Bahasa dan sastra Aceh (gelar sarjana pendidikan (SPd)) | #333 Pendidikan Bahasa dan Sastra Aceh [S/M/Dr: V--], Pd.; R3: Dibuka (no. 228) | Perbaikan salah ketik/format | R1 #333 | Ubah (Bagian A) — gelar: "sarjana pendidikan (SPd)" -> "Pd."; name_prodi: "Pendidikan Bahasa dan sastra Aceh" -> "Pendidikan Bahasa dan Sastra Aceh" |
| 6 | `5070118013` S2 Pengelolaan Sumberdaya Alam dan Lingkungan (gelar Ling.) | #458 Pengelolaan Sumber Daya Alam dan Lingkungan [S/M/Dr: -V-], Ling. | Perbaikan salah ketik/format | R1 #458 | Ubah (Bagian A) — name_prodi: "Pengelolaan Sumberdaya Alam dan Lingkungan" -> "Pengelolaan Sumber Daya Alam dan Lingkungan" |
| 7 | `5060116044` S1 Rekayasa Perkeretapian (gelar T.) | #450 Rekayasa Perkeretaapian [S/M/Dr: V--], T.; R3: Dibuka (no. 316) | Perbaikan salah ketik/format | R1 #450; R3 no. 316 | Ubah (Bagian A) — name_prodi: "Rekayasa Perkeretapian" -> "Rekayasa Perkeretaapian" |
| 8 | `5060116045` S1 RekayasaTelekomunikasi (gelar T.) | #451 Rekayasa Telekomunikasi [S/M/Dr: VVV], T.; R3: Dibuka (no. 317) | Perbaikan salah ketik/format | R1 #451; R3 no. 317 | Ubah (Bagian A) — name_prodi: "RekayasaTelekomunikasi" -> "Rekayasa Telekomunikasi" |
| 9 | `5060118044` S2 RekayasaTelekomunikasi (gelar T.) | #451 Rekayasa Telekomunikasi [S/M/Dr: VVV], T. | Perbaikan salah ketik/format | R1 #451 | Ubah (Bagian A) — name_prodi: "RekayasaTelekomunikasi" -> "Rekayasa Telekomunikasi" |
| 10 | `5060119036` S3 RekayasaTelekomunikasi (gelar T.) | #451 Rekayasa Telekomunikasi [S/M/Dr: VVV], T. | Perbaikan salah ketik/format | R1 #451 | Ubah (Bagian A) — name_prodi: "RekayasaTelekomunikasi" -> "Rekayasa Telekomunikasi" |
| 11 | `3000718002` S2 Sains Bahan/ Sains Material (gelar Si.) | #172 Ilmu atau Sains Bahan/Ilmu atau Sains Material [S/M/Dr: -VV], Si. | Perbaikan salah ketik/format | R1 #172 | Ubah (Bagian A) — name_prodi: "Sains Bahan/ Sains Material" -> "Sains Bahan/Sains Material" |
| 12 | `3000719002` S3 Sains Bahan/ Sains Material (gelar Si.) | #172 Ilmu atau Sains Bahan/Ilmu atau Sains Material [S/M/Dr: -VV], Si. | Perbaikan salah ketik/format | R1 #172 | Ubah (Bagian A) — name_prodi: "Sains Bahan/ Sains Material" -> "Sains Bahan/Sains Material" |
| 13 | `5060116090` S1 Teknik Perkeretapian (gelar T.) | #450 Rekayasa Perkeretaapian [S/M/Dr: V--], T.; R3: Dibuka (no. 316) | Perbaikan salah ketik/format | R1 #450; R3 no. 316 | Ubah (Bagian A) — name_prodi: "Teknik Perkeretapian" -> "Teknik Perkeretaapian" |
| 14 | `5060116091` S1 TeknikTelekomunikasi (gelar T.) | #451 Rekayasa Telekomunikasi [S/M/Dr: VVV], T.; R3: Dibuka (no. 317) | Perbaikan salah ketik/format | R1 #451; R3 no. 317 | Ubah (Bagian A) — name_prodi: "TeknikTelekomunikasi" -> "Teknik Telekomunikasi" |
| 15 | `5060118088` S2 TeknikTelekomunikasi (gelar T.) | #451 Rekayasa Telekomunikasi [S/M/Dr: VVV], T. | Perbaikan salah ketik/format | R1 #451 | Ubah (Bagian A) — name_prodi: "TeknikTelekomunikasi" -> "Teknik Telekomunikasi" |
| 16 | `5060119172` S3 TeknikTelekomunikasi (gelar T.) | #451 Rekayasa Telekomunikasi [S/M/Dr: VVV], T. | Perbaikan salah ketik/format | R1 #451 | Ubah (Bagian A) — name_prodi: "TeknikTelekomunikasi" -> "Teknik Telekomunikasi" |
| 17 | `5030416005` S1 Manajemen Ritel (gelar S.E) | #280 Manajemen Retail [S/M/Dr: V--], M.; R3: Dibuka (no. 185) | Perubahan nama/ejaan | R1 #280; R3 no. 185 "Manajemen Retail" | Ubah (Bagian B) — gelar: "S.E" -> "M."; name_prodi: "Manajemen Ritel" -> "Manajemen Retail" |
| 18 | `5050116073` S1 Pendidikan Vokasional Desain Fashion (gelar Pd.) | #395 Pendidikan Vokasional Desain Mode [S/M/Dr: V--], Pd.; R3: Dibuka (no. 270) | Perubahan nama/ejaan | R1 #395; R3 no. 270 "Pendidikan Vokasional Desain Mode" | Ubah (Bagian B) — name_prodi: "Pendidikan Vokasional Desain Fashion" -> "Pendidikan Vokasional Desain Mode" |
| 19 | `5160118019` S2 Penginderaan Jauh (gelar Geo.) | #554 Pengindraan Jauh [S/M/Dr: -V-], Geo. | Perubahan nama/ejaan | R1 #554 | Ubah (Bagian B) — name_prodi: "Penginderaan Jauh" -> "Pengindraan Jauh" |
| 20 | `5060118017` S2 Rekayasa Penginderaan Jauh (gelar T.) | #416 Rekayasa Pengindraan Jauh [S/M/Dr: -V-], T. | Perubahan nama/ejaan | R1 #416 | Ubah (Bagian B) — name_prodi: "Rekayasa Penginderaan Jauh" -> "Rekayasa Pengindraan Jauh" |
| 21 | `5060118062` S2 Teknik Penginderaan Jauh (gelar T.) | #416 Rekayasa Pengindraan Jauh [S/M/Dr: -V-], T. | Perubahan nama/ejaan | R1 #416 (Teknik = padanan Rekayasa, grup 34) | Ubah (Bagian B) — name_prodi: "Teknik Penginderaan Jauh" -> "Teknik Pengindraan Jauh" |
| 22 | `5050116025` S1 Pendidikan Bahasa Perancis (gelar Pd.) | #331 Pendidikan Bahasa Prancis [S/M/Dr: VVV], Pd.; R3: Dibuka (no. 224) | Beda ejaan antardokumen resmi | R1: Pendidikan Bahasa Prancis (#331); R3 no. 224 masih "Pendidikan Bahasa Perancis" | Pertahankan; konfirmasi ke Ditjen Dikti |
| 23 | `5050118021` S2 Pendidikan Bahasa Perancis (gelar Pd.) | #331 Pendidikan Bahasa Prancis [S/M/Dr: VVV], Pd. | Beda ejaan antardokumen resmi | R1: Pendidikan Bahasa Prancis (#331); R3 no. 224 masih "Pendidikan Bahasa Perancis" | Pertahankan; konfirmasi ke Ditjen Dikti |
| 24 | `5050119018` S3 Pendidikan Bahasa Perancis (gelar Pd.) | #331 Pendidikan Bahasa Prancis [S/M/Dr: VVV], Pd. | Beda ejaan antardokumen resmi | R1: Pendidikan Bahasa Prancis (#331); R3 no. 224 masih "Pendidikan Bahasa Perancis" | Pertahankan; konfirmasi ke Ditjen Dikti |
| 25 | `5060116020` S1 Rekayasa Instrumentasi dan Otomasi (gelar T.) | #423 Rekayasa Instrumentasi dan Automasi [S/M/Dr: V--], T.; R3: Dibuka (no. 292) | Beda ejaan antardokumen resmi | R1: Rekayasa Instrumentasi dan Automasi (#423); R3 no. 292 "Teknik/Rekayasa Instrumentasi dan Otomasi" | Pertahankan; konfirmasi ke Ditjen Dikti |
| 26 | `5060116066` S1 Teknik Instrumentasi dan Otomasi (gelar T.) | #423 Rekayasa Instrumentasi dan Automasi [S/M/Dr: V--], T.; R3: Dibuka (no. 292) | Beda ejaan antardokumen resmi | R1: Rekayasa Instrumentasi dan Automasi (#423); R3 no. 292 "Teknik/Rekayasa Instrumentasi dan Otomasi" | Pertahankan; konfirmasi ke Ditjen Dikti |
| 27 | `5010416005` S1 Teknologi Pasca Panen (gelar T.P.) | #237 Teknologi Pascapanen [S/M/Dr: VVV], T.P.; R3: Dibuka (no. 147) | Beda ejaan antardokumen resmi | R1: Teknologi Pascapanen (#237); R3 no. 147 masih "Teknologi Pasca Panen" | Pertahankan; konfirmasi ke Ditjen Dikti |
| 28 | `5010418006` S2 Teknologi Pasca Panen (gelar T.P.) | #237 Teknologi Pascapanen [S/M/Dr: VVV], T.P. | Beda ejaan antardokumen resmi | R1: Teknologi Pascapanen (#237); R3 no. 147 masih "Teknologi Pasca Panen" | Pertahankan; konfirmasi ke Ditjen Dikti |
| 29 | `5010419006` S3 Teknologi Pasca Panen (gelar T.P.) | #237 Teknologi Pascapanen [S/M/Dr: VVV], T.P. | Beda ejaan antardokumen resmi | R1: Teknologi Pascapanen (#237); R3 no. 147 masih "Teknologi Pasca Panen" | Pertahankan; konfirmasi ke Ditjen Dikti |
| 30 | `2000119007` S3 Ilmu Ekonomi Islam (gelar E.) | tidak tercantum di Lampiran I | Tidak tercantum di 96/B/KPT/2025 | R1; yang tercantum: "Ekonomi Syariah" (#148), "Ekonomi dan Keuangan Islam" (#141) | Pertahankan (dipakai tr_ajuan); konfirmasi dasar penamaan (Diktum KEDUA: PTN-BH boleh memakai nama sepadan dan melapor) — name_prodi_eng: "Islamic Economic " -> "Islamic Economic" |
| 31 | `5050118029` S2 Pengajaran Fisika (gelar Pd.) | tidak tercantum di Lampiran I | Tidak tercantum di 96/B/KPT/2025 | S2 Pengajaran Fisika tidak tercantum di Lampiran I 96/B/KPT/2025 (yang ada: Pengajaran Kimia, Pengajaran Matematika) | Usul dinonaktifkan (Bagian D, dikomentari) |
| 32 | `5080818001` S2 Sains Laboratorium Klinis (gelar Kes.) | tidak tercantum di Lampiran I | Tidak tercantum di 96/B/KPT/2025 | S2 Sains Laboratorium Klinis tidak tercantum di Lampiran I; kemungkinan digantikan "Sains Teknologi Laboratorium Medik" (#516) - belum ada bukti eksplisit | Usul dinonaktifkan (Bagian D, dikomentari) |
| 33 | `5080818002` S2 Sains Laboratorium Medis (gelar Kes.) | tidak tercantum di Lampiran I | Tidak tercantum di 96/B/KPT/2025 | S2 Sains Laboratorium Medis tidak tercantum di Lampiran I; kemungkinan digantikan "Sains Teknologi Laboratorium Medik" (#516) - belum ada bukti eksplisit | Usul dinonaktifkan (Bagian D, dikomentari) |
| 34 | `5160116016` S1 Manajemen Bencana (gelar M.B.) | #572 Manajemen Bencana [S/M/Dr: VV-], M.B.; R3: Moratorium (no. 364) | Moratorium S1 (SIAGA 2026) | S1 Manajemen Bencana berstatus Moratorium di lampiran R3 no. 364 | Usul dinonaktifkan (Bagian D, dikomentari) |
| 35 | `5130116004` S1 Manajemen Olahraga (gelar M.) | #538 Manajemen Olahraga [S/M/Dr: V--], Or.; R3: Moratorium (no. 347) | Moratorium S1 (SIAGA 2026) | S1 Manajemen Olahraga berstatus Moratorium di lampiran R3 no. 347 | Usul dinonaktifkan (Bagian D, dikomentari) |
| 36 | `5030418012` S1 Manajemen Ritel (gelar S.E) | #280 Manajemen Retail [S/M/Dr: V--], M.; R3: Dibuka (no. 185) | Duplikat | Duplikat "Manajemen Ritel" S1 (kode berpola S2 "18"); padanan resminya 5030416005 yang diganti menjadi "Manajemen Retail" | Usul dinonaktifkan (Bagian D, dikomentari) |
| 37 | `1000116002` S1 Filsafat Agama (gelar Fil.) | #86 Filsafat Agama [S/M/Dr: VVV], Fil.; R3: tidak tercantum | S1 tidak tercantum di lampiran SIAGA 2026 | R1 #86; R3: tidak ada | Pertahankan; konfirmasi apakah masih dapat diusulkan |
| 38 | `1000116003` S1 Filsafat Buddhis (gelar Fil.) | #87 Filsafat Buddhis [S/M/Dr: VVV], Fil.; R3: tidak tercantum | S1 tidak tercantum di lampiran SIAGA 2026 | R1 #87; R3: tidak ada | Pertahankan; konfirmasi apakah masih dapat diusulkan |
| 39 | `1000116004` S1 Filsafat Hindu (gelar Fil.) | #88 Filsafat Hindu [S/M/Dr: VVV], Fil.; R3: tidak tercantum | S1 tidak tercantum di lampiran SIAGA 2026 | R1 #88; R3: tidak ada | Pertahankan; konfirmasi apakah masih dapat diusulkan |
| 40 | `1000116005` S1 Filsafat Islam (gelar Fil.) | #89 Filsafat Islam [S/M/Dr: VVV], Fil.; R3: tidak tercantum | S1 tidak tercantum di lampiran SIAGA 2026 | R1 #89; R3: tidak ada | Pertahankan; konfirmasi apakah masih dapat diusulkan |
| 41 | `1000116006` S1 Filsafat Keilahian (gelar Fil.) | #90 Filsafat Keilahian [S/M/Dr: VVV], Fil.; R3: tidak tercantum | S1 tidak tercantum di lampiran SIAGA 2026 | R1 #90; R3: tidak ada | Pertahankan; konfirmasi apakah masih dapat diusulkan |
| 42 | `1000116007` S1 Filsafat Kong Hu Cu (gelar Fil.) | #91 Filsafat Kong Hu Cu [S/M/Dr: VVV], Fil.; R3: tidak tercantum | S1 tidak tercantum di lampiran SIAGA 2026 | R1 #91; R3: tidak ada | Pertahankan; konfirmasi apakah masih dapat diusulkan |
| 43 | `5050116041` S1 Pendidikan Keagamaan Buddha (gelar Pd.) | #350 Pendidikan Keagamaan Buddha [S/M/Dr: VVV], Pd.; R3: tidak tercantum | S1 tidak tercantum di lampiran SIAGA 2026 | R1 #350; R3: tidak ada | Pertahankan; konfirmasi apakah masih dapat diusulkan |
| 44 | `5050116042` S1 Pendidikan Keagamaan Hindu (gelar Pd.) | #351 Pendidikan Keagamaan Hindu [S/M/Dr: VVV], Pd.; R3: tidak tercantum | S1 tidak tercantum di lampiran SIAGA 2026 | R1 #351; R3: tidak ada | Pertahankan; konfirmasi apakah masih dapat diusulkan |
| 45 | `5050116047` S1 Pendidikan Kepercayaan Terhadap Tuhan Yang Maha Esa (gelar Pd.) | #356 Pendidikan Kepercayaan terhadap Tuhan Yang Maha Esa [S/M/Dr: V--], Pd.; R3: tidak tercantum | S1 tidak tercantum di lampiran SIAGA 2026 | R1 #356; R3: tidak ada | Pertahankan; konfirmasi apakah masih dapat diusulkan |
| 46 | `1000116008` S1 Studi Perbandingan Agama (gelar Fil.) | #92 Studi Perbandingan Agama [S/M/Dr: VVV], Fil.; R3: tidak tercantum | S1 tidak tercantum di lampiran SIAGA 2026 | R1 #92; R3: tidak ada | Pertahankan; konfirmasi apakah masih dapat diusulkan |

### 6.2 Baris "Sesuai" yang hanya dirapikan formatnya (Bagian A)

| No. | Kode | Kolom | Nilai lama | Nilai baru | Alasan | Sumber |
|---|---|---|---|---|---|---|
| 1 | `1000216034` | gelar | `S.Pd` | `Pd.` | format inisial gelar tidak baku | R1 #330 |
| 2 | `1000416017` | gelar | `Sn` | `Sn.` | format inisial gelar tidak baku | R1 #15 |
| 3 | `5010118007` | gelar | `M` | `Pi.` | format inisial gelar tidak baku | R1 #249 |
| 4 | `5010118008` | gelar | `M` | `Pi.` | format inisial gelar tidak baku | R1 #249 |
| 5 | `5020218003` | gelar | `M.Ds.` | `Ds.` | format inisial gelar tidak baku | R1 #266 |
| 6 | `5020219003` | gelar | `Dr.` | `Ds.` | format inisial gelar tidak baku | R1 #266 |
| 7 | `5030216010` | gelar | `S.E` | `Bns.` | format inisial gelar tidak baku | R1 #288 |
| 8 | `5010416006` | name_prodi | `Teknologi Pangan dan Hasil Pertanian ` | `Teknologi Pangan dan Hasil Pertanian` | hapus spasi berlebih | konsistensi data |
| 9 | `5010418007` | name_prodi | `Teknologi Pangan dan Hasil Pertanian ` | `Teknologi Pangan dan Hasil Pertanian` | hapus spasi berlebih | konsistensi data |
| 10 | `5010419007` | name_prodi | `Teknologi Pangan dan Hasil Pertanian ` | `Teknologi Pangan dan Hasil Pertanian` | hapus spasi berlebih | konsistensi data |
| 11 | `5050116024` | name_prodi | `Pendidikan Bahasa Makassar ` | `Pendidikan Bahasa Makassar` | hapus spasi berlebih | konsistensi data |
| 12 | `5050118023` | name_prodi | `Pendidikan Bahasa dan Kebudayaan  Sunda` | `Pendidikan Bahasa dan Kebudayaan Sunda` | hapus spasi berlebih | konsistensi data |
| 13 | `5060116039` | name_prodi | `Rekayasa Minyak dan Gas ` | `Rekayasa Minyak dan Gas` | hapus spasi berlebih | konsistensi data |
| 14 | `5060116085` | name_prodi | `Teknik Minyak dan Gas ` | `Teknik Minyak dan Gas` | hapus spasi berlebih | konsistensi data |
| 15 | `5060118009` | name_prodi | `Rekayasa Energi Panas Bumi ` | `Rekayasa Energi Panas Bumi` | hapus spasi berlebih | konsistensi data |
| 16 | `5060118054` | name_prodi | `Teknik Energi Panas Bumi ` | `Teknik Energi Panas Bumi` | hapus spasi berlebih | konsistensi data |
| 17 | `5080816003` | name_prodi | `Fisioterapi ` | `Fisioterapi` | hapus spasi berlebih | konsistensi data |
| 18 | `5080818005` | name_prodi | `Fisioterapi ` | `Fisioterapi` | hapus spasi berlebih | konsistensi data |
| 19 | `5130116003` | name_prodi | `Rekayasa Keolahragaan ` | `Rekayasa Keolahragaan` | hapus spasi berlebih | konsistensi data |
| 20 | `5160116017` | name_prodi | `Rekayasa Tata Kelola Air Terpadu ` | `Rekayasa Tata Kelola Air Terpadu` | hapus spasi berlebih | konsistensi data |
| 21 | `5160119008` | name_prodi | `Konseling dan Psikoterapi ` | `Konseling dan Psikoterapi` | hapus spasi berlebih | konsistensi data |
| 22 | `5030216005` | name_prodi_eng | `Maritime Business ` | `Maritime Business` | hapus spasi berlebih | konsistensi data |
| 23 | `5030216007` | name_prodi_eng | `Entrepreneurship ` | `Entrepreneurship` | hapus spasi berlebih | konsistensi data |
| 24 | `5030618001` | name_prodi_eng | `Digital Bussiness ` | `Digital Bussiness` | hapus spasi berlebih | konsistensi data |
| 25 | `5030619001` | name_prodi_eng | `Digital Bussiness ` | `Digital Bussiness` | hapus spasi berlebih | konsistensi data |
| 26 | `5060116009` | name_prodi_eng | `Electrical  Power Engineering` | `Electrical Power Engineering` | hapus spasi berlebih | konsistensi data |
| 27 | `5060116056` | name_prodi_eng | `Electrical  Power Engineering` | `Electrical Power Engineering` | hapus spasi berlebih | konsistensi data |
| 28 | `5060118010` | name_prodi_eng | `Electrical  Power Engineering` | `Electrical Power Engineering` | hapus spasi berlebih | konsistensi data |
| 29 | `5060118055` | name_prodi_eng | `Electrical  Power Engineering` | `Electrical Power Engineering` | hapus spasi berlebih | konsistensi data |
| 30 | `5160118030` | name_prodi_eng | `Coffee Economics ` | `Coffee Economics` | hapus spasi berlebih | konsistensi data |

### 6.3 Selisih yang dilaporkan tetapi tidak diubah

- **Nama Inggris:** 45 baris berbeda dengan R1. Sebagian karena salah ketik di R1 sendiri ("Japanese Language Eduction", "Digital Bussiness"), jadi tidak diterapkan otomatis. Lihat kolom `nama_inggris_resmi` di CSV.
- **Inisial gelar:** perbedaan seperti `Sos.` vs `I.Pol.`, `Kes.` vs `K.M.`, atau `P.W.K` vs `Par.` tidak diubah. Diktum KETIGA R1 membolehkan inisial rumpun ilmu maupun inisial nama prodi. Hanya format yang jelas tidak baku yang dirapikan.

## 7. File SQL kandidat

File: `ms_nomenklatur_pembaruan_2026-10-28.sql`. File asli `ms_nomenklatur.sql` **tidak** diubah.

Pendekatannya sengaja **berbeda dari dump**: bukan `DROP TABLE` + `INSERT` ulang, melainkan pembaruan bertahap. Dengan cara ini, data yang berubah di server setelah dump tidak tertimpa, `kode_prodi` dan `id_sms` yang dirujuk ajuan tetap sama, dan setiap perubahan dapat diaudit. Skrip hanya berisi `UPDATE` dan `INSERT` langsung: tidak membuat tabel cadangan maupun tabel sementara.

### 7.1 Isi dan pengaman

| Bagian | Isi | Jumlah |
|---|---|---|
| A | Perbaikan salah ketik/format nama, spasi, format gelar | 52 nilai |
| B | Nama disesuaikan dengan R1 | 5 nilai |
| C | Jenis "Pendidikan Vokasi" (kode 3) di `ms_jns_pendidikan`, hanya bila belum ada | 1 baris |
| C | Penambahan nomenklatur baru | 530 baris |
| D | Usulan penonaktifan, **dalam komentar** | 6 baris |

Pengaman yang dipasang:

- Semua perubahan berjalan dalam satu transaksi; bila satu perintah gagal, semuanya batal.
- Setiap `UPDATE` memuat nilai lama di `WHERE`. Nilai yang di server sudah berbeda dari dump dilewati (`UPDATE 0`), tidak ditimpa.
- `INSERT` melewati `kode_prodi` yang sudah ada dan nama+program yang sudah ada. Baris D3/D4 hanya masuk bila kode jenis 3 adalah "Pendidikan Vokasi".
- Skrip aman dijalankan ulang.
- Tidak ada tabel cadangan. Pembatalan memakai `ms_nomenklatur_pembatalan_2026-10-28.sql`, kebalikan skrip ini yang juga hanya berisi `UPDATE` dan `DELETE`.

### 7.2 Penyusunan baris baru (Bagian C)

- **Sumber:** S1 hanya ditambahkan bila tercentang S di R1 **dan** berstatus "Dibuka" di R3. S2/S3 ditambahkan bila tercentang M/Dr di R1.
- **Prodi kesehatan UNESA (permintaan pengguna):** S1 Kedokteran, Kedokteran Gigi, Keperawatan, dan Kebidanan ditambahkan walaupun tidak tercantum di lampiran R3, karena prodi ini sudah ada di UNESA. Keempatnya tercentang S di R1, dan centangnya sudah dicek visual. S1 Fisioterapi sudah ada (`5080816003`). Profesi Dokter, Dokter Gigi, Ners, dan Bidan ikut ditambahkan di bagian yang sama (rincian di Bagian 12.2).
- **Vokasi (permintaan pengguna):** semua nama yang tercentang D.Tiga atau S.Tr di Lampiran I R6 (rincian di Bagian 13).
- **`kode_prodi`** disusun dengan pola yang sudah dipakai tabel (rumpun + sub + jenjang + nomor urut berikutnya). Kode ini **kode internal aplikasi**, karena dokumen resmi tidak memuat kode.
- **Kelompok rumpun:** bila nama yang sama sudah ada di jenjang lain, kelompoknya diikuti. Bila belum ada, dipakai kelompok yang paling banyak dipakai baris lain dari grup Lampiran yang sama.
- **`status_prodi`:** mengikuti nama yang sama di jenjang lain, atau mengikuti kelompok bila statusnya seragam. Bila kelompoknya campuran, diisi "Dibuka" dan ditandai *perlu verifikasi* (13 baris).
- **Kolom lain:** "Manajemen atau Pengelolaan Sumber Daya Perairan" dipecah menjadi dua baris, sesuai pola tabel. `id_sms` dibuat dengan `gen_random_uuid()`, dan `id_updater` dibiarkan NULL.

### 7.3 Daftar baris baru

Tabel ini memuat baris baru akademik dan profesi. Daftar 494 baris vokasi terlalu panjang untuk laporan; ringkasannya ada di Bagian 13.4 dan daftar lengkapnya (dengan `kode_prodi` usulan) di `referensi/lampiran1-kepdirjen-diksi-27-D-M-2022-D3-D4.csv`.

| No. | kode_prodi (baru) | Program | Nama | Nama Inggris | Gelar | Rumpun/sub | status_prodi (dasar) | Sumber |
|---|---|---|---|---|---|---|---|---|
| 1 | `2000118011` | S2 | Ekonomi Syariah | Islamic Economics | E. | 200/01 | Dibuka (seragam di kelompok 200/01 S2) | R1 #148 (M tercentang) |
| 2 | `2000119008` | S3 | Ekonomi Syariah | Islamic Economics | E. | 200/01 | Dibuka (seragam di kelompok 200/01 S3) | R1 #148 (Dr tercentang) |
| 3 | `5010116009` | S1 | Akuakultur | Aquaculture | Pi. | 501/01 | Dibuka (PERLU VERIFIKASI: kelompok 501/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #248 (S tercentang); R3 no. 156 "Akuakultur" = Dibuka |
| 4 | `5010118009` | S2 | Akuakultur | Aquaculture | Pi. | 501/01 | Dibuka (PERLU VERIFIKASI: kelompok 501/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #248 (M tercentang) |
| 5 | `5010119005` | S3 | Akuakultur | Aquaculture | Pi. | 501/01 | Dibuka (PERLU VERIFIKASI: kelompok 501/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #248 (Dr tercentang) |
| 6 | `5010116010` | S1 | Manajemen Sumber Daya Perairan | Water or Aquatic Resources Management | Pi. | 501/01 | STEM (sama dengan baris "Manajemen Sumber Daya Perairan" jenjang lain) | R1 #249 (S tercentang); R3 no. 157 "Manajemen atau Pengelolaan Sumber Daya Perairan" = Dibuka |
| 7 | `5010116011` | S1 | Pengelolaan Sumber Daya Perairan | Water or Aquatic Resources Management | Pi. | 501/01 | STEM (sama dengan baris "Pengelolaan Sumber Daya Perairan" jenjang lain) | R1 #249 (S tercentang); R3 no. 157 "Manajemen atau Pengelolaan Sumber Daya Perairan" = Dibuka |
| 8 | `5010119006` | S3 | Manajemen Sumber Daya Perairan | Water or Aquatic Resources Management | Pi. | 501/01 | STEM (sama dengan baris "Manajemen Sumber Daya Perairan" jenjang lain) | R1 #249 (Dr tercentang) |
| 9 | `5010119007` | S3 | Pengelolaan Sumber Daya Perairan | Water or Aquatic Resources Management | Pi. | 501/01 | STEM (sama dengan baris "Pengelolaan Sumber Daya Perairan" jenjang lain) | R1 #249 (Dr tercentang) |
| 10 | `5020216006` | S1 | Desain Mode | Fashion Design | Ds. | 502/02 | Dibuka (seragam di kelompok 502/02 S1) | R1 #267 (S tercentang); R3 no. 172 "Desain Mode" = Dibuka |
| 11 | `5020218006` | S2 | Desain Mode | Fashion Design | Ds. | 502/02 | Dibuka (seragam di kelompok 502/02 S2) | R1 #267 (M tercentang) |
| 12 | `5020219006` | S3 | Desain Mode | Fashion Design | Ds. | 502/02 | Dibuka (seragam di kelompok 502/02 S3) | R1 #267 (Dr tercentang) |
| 13 | `5050119050` | S3 | Evaluasi Pendidikan | Education Evaluation | Pd. | 505/01 | Dibuka (seragam di kelompok 505/01 S3) | R1 #309 (Dr tercentang) |
| 14 | `5050118067` | S2 | Pendidikan Agama Islam | Islamic Religion Education | Pd. | 505/01 | Dibuka (seragam di kelompok 505/01 S2) | R1 #352 (M tercentang) |
| 15 | `5050119051` | S3 | Pendidikan Agama Islam | Islamic Religion Education | Pd. | 505/01 | Dibuka (seragam di kelompok 505/01 S3) | R1 #352 (Dr tercentang) |
| 16 | `5080816005` | S1 | Kesehatan Lingkungan | Environmental Health | K.M. | 508/08 | STEM (sama dengan baris "Kesehatan Lingkungan" jenjang lain) | R1 #502 (S tercentang); R3 no. 333 "Kesehatan Lingkungan" = Dibuka |
| 17 | `5080818014` | S2 | Sains Teknologi Laboratorium Medik | Medical Laboratory Technology Science | Si.T.L.M. | 508/08 | Dibuka (PERLU VERIFIKASI: kelompok 508/08 campuran STEM/Dibuka; diisi Dibuka) | R1 #516 (M tercentang) |
| 18 | `5100118011` | S2 | Hukum Syariah | Syariah Law | H. | 510/01 | Dibuka (seragam di kelompok 510/01 S2) | R1 #527 (M tercentang) |
| 19 | `5100118012` | S2 | Kenotariatan | Notary Law | H. | 510/01 | Dibuka (seragam di kelompok 510/01 S2) | R1 #529 (M tercentang) |
| 20 | `5160118035` | S2 | Inovasi Sistem dan Teknologi | System and Technology Innovation | I.S.T. | 516/01 | Dibuka (PERLU VERIFIKASI: kelompok 516/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #559 (M tercentang) |
| 21 | `5160118036` | S2 | Kajian Ketahanan Nasional | National Resillience Studies | Si. | 516/01 | Dibuka (PERLU VERIFIKASI: kelompok 516/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #560 (M tercentang) |
| 22 | `5160119014` | S3 | Kajian Ketahanan Nasional | National Resillience Studies | Si. | 516/01 | Dibuka (PERLU VERIFIKASI: kelompok 516/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #560 (Dr tercentang) |
| 23 | `5160118037` | S2 | Kajian Strategis dan Global | Strategic and Global Studies | Si. | 516/01 | Dibuka (PERLU VERIFIKASI: kelompok 516/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #561 (M tercentang) |
| 24 | `5160119015` | S3 | Kajian Strategis dan Global | Strategic and Global Studies | Si. | 516/01 | Dibuka (PERLU VERIFIKASI: kelompok 516/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #561 (Dr tercentang) |
| 25 | `5160118038` | S2 | Kajian Terorisme | Terrorism Studies | Si. | 516/01 | Dibuka (PERLU VERIFIKASI: kelompok 516/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #562 (M tercentang) |
| 26 | `5160119016` | S3 | Kajian Terorisme | Terrorism Studies | Si. | 516/01 | Dibuka (PERLU VERIFIKASI: kelompok 516/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #562 (Dr tercentang) |
| 27 | `5160118039` | S2 | Ketahanan Nasional | National Resillience | Si. | 516/01 | Dibuka (PERLU VERIFIKASI: kelompok 516/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #563 (M tercentang) |
| 28 | `5160119017` | S3 | Ketahanan Nasional | National Resillience | Si. | 516/01 | Dibuka (PERLU VERIFIKASI: kelompok 516/01 campuran STEM/Dibuka; diisi Dibuka) | R1 #563 (Dr tercentang) |
| 29 | `5080216003` | S1 | Kedokteran | Medicine | Ked. | 508/02 | STEM (seragam di kelompok 508/02 S1) | R1 #482 (S tercentang); tidak tercantum di lampiran R3; prodi ini ada di UNESA (permintaan pengguna) |
| 30 | `5080316001` | S1 | Kedokteran Gigi | Dental Medicine | K.G. | 508/03 | STEM (seragam di kelompok 508/03) | R1 #484 (S tercentang); tidak tercantum di lampiran R3; prodi ini ada di UNESA (permintaan pengguna) |
| 31 | `5080616001` | S1 | Kebidanan | Midwifery | Keb. | 508/06 | STEM (sama dengan baris "Kebidanan" jenjang lain) | R1 #504 (S tercentang); tidak tercantum di lampiran R3; prodi ini ada di UNESA (permintaan pengguna) |
| 32 | `5080716001` | S1 | Keperawatan | Nursing | Kep. | 508/07 | STEM (sama dengan baris "Keperawatan" jenjang lain) | R1 #505 (S tercentang); tidak tercantum di lampiran R3; prodi ini ada di UNESA (permintaan pengguna) |
| 33 | `5080617001` | Profesi | Pendidikan Profesi Bidan | Midwife Profession Education | Bdn. | 508/06 | Dibuka (Surat 1145/2026 butir 3.a: profesi tidak harus STEM; tidak ada daftar moratorium profesi) | R1I bagian I no. 10; prodi ini ada di UNESA (permintaan pengguna) |
| 34 | `5080217001` | Profesi | Pendidikan Profesi Dokter | Medical Doctor Profession Education | dr. | 508/02 | Dibuka (Surat 1145/2026 butir 3.a: profesi tidak harus STEM; tidak ada daftar moratorium profesi) | R1I bagian I no. 12; prodi ini ada di UNESA (permintaan pengguna) |
| 35 | `5080317001` | Profesi | Pendidikan Profesi Dokter Gigi | Dentist Profession Education | drg. | 508/03 | Dibuka (Surat 1145/2026 butir 3.a: profesi tidak harus STEM; tidak ada daftar moratorium profesi) | R1I bagian I no. 13; prodi ini ada di UNESA (permintaan pengguna) |
| 36 | `5080717001` | Profesi | Pendidikan Profesi Ners | Nurse Profession Education | Ners. | 508/07 | Dibuka (Surat 1145/2026 butir 3.a: profesi tidak harus STEM; tidak ada daftar moratorium profesi) | R1I bagian I no. 16; prodi ini ada di UNESA (permintaan pengguna) |

### 7.4 Cara menerapkan

1. Tinjau laporan ini dan CSV-nya. Hapus baris dari Bagian C bila ada yang tidak disetujui.
2. Jalankan dulu di **salinan** database `siaga`:

   ```
   psql -v ON_ERROR_STOP=1 -d siaga -f ms_nomenklatur_pembaruan_2026-10-28.sql
   ```

   Bila data sama dengan dump, keluarannya 57× `UPDATE 1`, lalu `INSERT 0 1` (jenis Vokasi), lalu `INSERT 0 n` per jenjang: S1 9, S2 12, S3 11, Profesi 4, D3 256, D4 238. Angka yang lebih kecil berarti baris itu dilewati karena datanya sudah berbeda. Bila ada perintah yang gagal, tidak ada perubahan yang tersimpan.
3. Setelah disetujui, jalankan di server pada jam sepi, lalu cek dengan kueri di bagian 5 skrip.
4. Bagian D baru dijalankan setelah aplikasi menyaring `deleted_at` (lihat Bagian 10).
5. Untuk pembatalan: jalankan `ms_nomenklatur_pembatalan_2026-10-28.sql`. Skrip ini mengembalikan 57 nilai, menghapus baris tambahan yang belum dipakai ajuan, dan menghapus jenis "Pendidikan Vokasi" bila tidak dipakai. Bila ingin cadangan penuh, buat berkas dengan `pg_dump` sebelum menjalankan skrip pembaruan.

## 8. Ringkasan perubahan

| Kategori | Jumlah | Keterangan |
|---|---|---|
| Dipertahankan tanpa perubahan | 1.312 (termasuk baris yang perlu konfirmasi, lihat baris terakhir tabel ini) | Sesuai R1 (dan R3 untuk S1) |
| Diperbarui | 52 baris / 57 nilai | A: 52, B: 5; `kode_prodi` tidak berubah |
| Ditambahkan | 530 | S1 9, S2 12, S3 11, Profesi 4, D3 256, D4 238; ditambah 1 jenis pendidikan "Pendidikan Vokasi" |
| Diusulkan dinonaktifkan | 6 | `5030418012` (duplikat), `5130116004` & `5160116016` (moratorium S1), `5050118029`, `5080818001`, `5080818002` (tidak tercantum di R1). Tidak dijalankan |
| Dipertahankan, perlu konfirmasi | 19 baris lama + 13 status baris baru | 8 beda ejaan antardokumen, 10 S1 tidak ada di R3 (Filsafat ×6, Studi Perbandingan Agama, Pendidikan Keagamaan Hindu/Buddha, Pendidikan Kepercayaan), 1 Ilmu Ekonomi Islam |
| Dihapus permanen | 0 | – |

## 9. Hasil validasi (database sementara)

Skrip diuji pada database PostgreSQL sementara (`uji_nomenklatur_20261028`, dibuat lalu dihapus) di mesin pengembang. Database `siaga` tidak diubah; isinya hanya dibaca untuk menyalin tabel referensi.

| Pemeriksaan | Hasil |
|---|---|
| Jumlah baris sebelum → sesudah | 1.370 → 1.900 (+530) |
| Baris lama yang hilang | 0 |
| Baris yang berubah | 52, hanya pada `name_prodi`, `name_prodi_eng`, `gelar`; kolom lain tidak berubah sama sekali |
| Nama+program ganda / `id_sms` ganda | 0 / 0 |
| `kode_prodi` di luar pola | 1 (`5030418012`, data lama yang diusulkan nonaktif) |
| Spasi berlebih tersisa | 0 |
| `kode_prodi` yang dipakai `tr_ajuan` | 10 dari 10 masih ada |
| Dijalankan ulang | Tidak ada perubahan (idempoten) |
| Tabel baru yang dibuat skrip | Tidak ada (daftar tabel sebelum dan sesudah sama) |
| Keluaran per perintah | 57× `UPDATE 1`; `INSERT` 1 (jenis), lalu 9, 12, 11, 4, 256, 238; semua 57 nilai terpasang |
| Pembatalan | Kembali ke 1.370 baris dengan isi sama seperti dump (kecuali `updated_at`); jenis Vokasi terhapus; aman dijalankan ulang |
| Nilai di server sudah diubah orang lain | Nilai itu dilewati, tidak ditimpa; perubahan lain tetap berjalan |
| `program_id`/`id_jenj_didik`/`jenis_pendidikan_id` tidak serasi | 0 (S1/30/1, S2/35/1, S3/40/1, Profesi/25/2, D3/22/3, D4/23/3) |
| `ms_jns_pendidikan` (disalin dari database lokal ke database uji) | Akademik (1), Profesi (2) → ditambah **Pendidikan Vokasi (3)**; tidak bertambah lagi saat dijalankan ulang |
| Kode jenis 3 sudah dipakai nama lain | Jenis itu tidak ditimpa dan baris D3/D4 tidak ditambahkan; baris lain tetap berjalan |
| `kode_prodi` baru sudah dipakai nama lain | Baris itu dilewati, baris lain tetap ditambahkan; pembatalan tidak menghapus baris milik orang lain |

## 10. Risiko dan tindak lanjut

1. **Penonaktifan belum berdampak.** Aplikasi belum menyaring `deleted_at`/`soft_delete`, jadi baris yang ditandai nonaktif tetap muncul di dropdown ajuan dan Data Master. Tindak lanjut: tambahkan `whereNull('deleted_at')` di `Fungsi::pilihan_nomenklatur()` dan halaman Data Master Nomenklatur, lalu jalankan Bagian D. Jangan menghapus permanen baris yang dirujuk `tr_ajuan`.
2. **Kode baris baru adalah kode internal.** Bila `kode_prodi` harus sama dengan sistem lain (SIAGA/PDDikti), sesuaikan sebelum diterapkan.
3. **Status STEM/Dibuka untuk 13 baris baru** diisi "Dibuka" karena kelompoknya campuran. Konfirmasikan ke pengelola usulan prodi.
4. **Ejaan antardokumen** (Prancis/Perancis, Pascapanen/Pasca Panen, Automasi/Otomasi). Sebaiknya ikuti yang dipakai SIAGA saat pengusulan, atau minta konfirmasi Ditjen Dikti.
5. **Ilmu Ekonomi Islam (S3)** sudah dipakai ajuan. Pastikan dasar penamaannya (nama sepadan PTN-BH yang dilaporkan, Diktum KEDUA) atau beralih ke "Ekonomi Syariah".
6. **Daftar moratorium bersifat tahunan.** R3 berlaku untuk penerimaan usul 2026, yang Intake II-nya sudah ditutup 30 September 2026. Periksa ulang daftar S1 saat surat pembukaan usul 2027 terbit.
7. **Sumber R1 berupa salinan pindaian** yang diunggah perguruan tinggi lain (salinan LLDIKTI XV tidak dapat diakses). Sebaiknya dapatkan salinan resmi melalui saluran Ditjen Dikti/JDIH Kemdiktisaintek (atau surat penyampaian keputusan yang diterima UNESA), lalu cocokkan baris yang berubah. Nama yang tidak diverifikasi visual masih mungkin mengandung salah baca OCR. Namun semua nama yang masuk SQL sudah diverifikasi visual atau dikuatkan teks asli R3.
8. **Spesialis dan Subspesialis (Lampiran II R1)** belum dapat dimasukkan, karena tabel `jenjang_pendidikan` aplikasi belum memiliki jenjang tersebut. Bila SIARJUNA akan melayani usul prodi spesialis, jenjangnya perlu ditambahkan dulu (dengan `is_siaga = 1`). Setelah itu datanya bisa diambil dari CSV referensi (Bagian 12).
9. **Dump asli berisi `DROP TABLE`.** Jangan menjalankannya di server untuk memperbarui data.
10. **Dua ajuan D4 yang sudah ada memakai jenis Akademik.** Di database lokal ada 2 ajuan dengan jenjang 23 (D4) dan `id_jns_pendidikan = 1`, keduanya belum memilih nomenklatur. Nomenklatur D4 yang baru memakai jenis 3 (Vokasi), jadi dropdown untuk kedua ajuan itu tetap kosong sampai jenis pendidikannya diubah ke "Pendidikan Vokasi". Periksa juga apakah formulir ajuan perlu membatasi pasangan jenis–jenjang.
11. **Kode jenjang vokasi "25" (D3) dan "26" (D4) adalah usulan internal.** Segmen jenjang yang ada (16/18/19) tampak mengikuti level KKNI (6/8/9) dengan awalan 1; untuk vokasi dipakai awalan 2 + level KKNI (D3 = 5, Sarjana Terapan = 6) agar tidak bentrok dengan S1. Aturan ini bisa diteruskan bila kelak jenjang vokasi lain diaktifkan (D1 = 23, D2 = 24, M.Tr = 28, D.Tr = 29) dan sejajar dengan akademik (S1 16 ↔ D4 26). Segmen ini **bukan** `id_jenj_didik`; kesamaan angka "25" dengan `id_jenj_didik` Profesi hanya kebetulan (S1 pun bersegmen 16 walau `id_jenj_didik`-nya 30). Aplikasi tidak membaca isi `kode_prodi` (kode diisi manual di form Data Master), dan tidak ada dokumen resmi yang mengatur kode ini.
12. **R6 terbit 2022 di bawah Kemendikbudristek.** Diktum KELIMA dan KEENAM menyatakan daftar ini dapat bertambah dan pembaruannya dicantumkan di sistem layanan perizinan (SIAGA) dan keputusan Dirjen. Bila terbit daftar nama prodi vokasi yang lebih baru, cocokkan ulang. Nama vokasi yang hanya ada di SIAGA, tetapi tidak di R6, tidak tercakup.
13. **`jenjang_pendidikan.sebutan` untuk D3 berisi "Sarjana".** Seharusnya Diploma Tiga. Nilai `csf` baris D3 sama persis dengan baris S1 (840629195), jadi kemungkinan barisnya disalin dari S1. SIARJUNA tidak membaca kolom `sebutan` (yang dipakai hanya `nm_jenj_didik`), sehingga tidak berpengaruh ke aplikasi ini. Tabel itu tampaknya hasil sinkronisasi (`last_sync` 2016) dan mungkin dipakai aplikasi lain, jadi tidak diubah oleh SQL ini; laporkan ke pengelolanya bila perlu diperbaiki.
14. **Cek duplikat saat menambah nomenklatur lewat Data Master terlalu luas.** `NomenklaturController::store()` menolak data bila ada nama yang *mengandung* teks yang sama di jenjang mana pun (`trim(name_prodi) ilike '%nama%'`), sedangkan `update()` membandingkan nama persis + `id_jenj_didik`. Karena tabel memang menyimpan nama yang sama di beberapa jenjang (dan kini juga D3/D4), admin tidak bisa menambah, misalnya, "Bisnis Kreatif" S1 lewat form karena sudah ada sebagai D4. Ini perilaku lama aplikasi, bukan akibat SQL ini, tetapi makin terasa setelah 494 baris vokasi masuk. **Sudah diperbaiki (28 Oktober 2026):** `store()` kini menganggap ganda hanya nama yang sama persis (huruf besar/kecil dan spasi tepi diabaikan) pada `id_jenj_didik` yang sama; diuji di `tests/Feature/Porting/DuplikatNomenklaturTest.php`.

## 11. Daftar file

| File | Isi |
|---|---|
| `laporan-riset-nomenklatur-2026-10-28.md` | Laporan ini |
| `perbandingan-ms_nomenklatur-2026-10-28.csv` | Perbandingan lengkap per baris (UTF-8, bisa dibuka di Excel) |
| `ms_nomenklatur_pembaruan_2026-10-28.sql` | SQL kandidat: hanya `UPDATE` dan `INSERT` dalam satu transaksi, tanpa tabel baru, idempoten |
| `ms_nomenklatur_pembatalan_2026-10-28.sql` | Kebalikan SQL kandidat (`UPDATE` dan `DELETE`), pengganti tabel cadangan |
| `referensi/lampiran1-kepdirjen-96-B-KPT-2025.csv` | Hasil ekstraksi Lampiran I R1 (587 baris; kolom `verifikasi_visual` dan `koreksi_ocr`) |
| `referensi/siaga-2026-program-sarjana.csv` | Lampiran R3 (371 program Sarjana, Dibuka/Moratorium) |
| `referensi/lampiran2-profesi-kepdirjen-96-B-KPT-2025.csv` | Lampiran II bagian I: 21 program Profesi beserta kode usulan |
| `referensi/lampiran2-spesialis-kepdirjen-96-B-KPT-2025.csv` | Lampiran II bagian II: 62 program Spesialis (inisial 2022 dan usul perubahan) |
| `referensi/lampiran2-subspesialis-kepdirjen-96-B-KPT-2025.csv` | Lampiran II bagian III: 230 Subspesialis dari 44 spesialis induk |
| `referensi/lampiran1-kepdirjen-diksi-27-D-M-2022-D3-D4.csv` | Lampiran I R6: 494 baris D3/S.Tr beserta kelompok, gelar, tanda *, `kode_prodi` usulan, dan catatan OCR |
| `skrip/` | Skrip ekstraksi, pencocokan, pembuatan SQL, dan uji database, untuk menelusuri ulang hasil |

## 12. Lampiran II: Profesi, Spesialis, dan Subspesialis

### 12.1 Isi dan cara ekstraksi

| Bagian Lampiran II R1 | Halaman PDF | Jumlah | Ada di `ms_nomenklatur` | Cara ekstraksi |
|---|---|---|---|---|
| I. Program Profesi | 32–33 | 21 program | 0 | Lapisan teks, lalu **seluruh baris dicek visual** |
| II. Program Spesialis (Sp.) | 34–36 | 62 program (1 Psikologi, 55 Kesehatan, 6 Pekerja Sosial) | 0 | Lapisan teks, lalu **seluruh baris dicek visual**; 1 koreksi manual (#34/#35) |
| III. Program Subspesialis (Subsp.) | 37–47 | 230 subspesialis dari 44 spesialis induk | 0 | **Disalin langsung dari gambar halaman**, karena lapisan teks OCR untuk tabel ini rusak; dicek silang dengan hasil OCR |

Catatan isi dokumen sumber, dicatat apa adanya:
- Pada Mikrobiologi Klinik, kolom inisial 163/E/KPT/2022 untuk Mikologi dan Virologi tertukar (Vir./Mik.); usul perubahannya sudah benar (Mik./Vir.).
- Ada beberapa salah ketik di dokumen: "Serobiologi Molekuker", "Uropatologi Repdroduksi", "Neuroulogy", "Dentomaxillofacial Radiolog".
- Kolom Spesialis memuat dua inisial: inisial lama (Lampiran II 163/E/KPT/2022) dan **usul perubahan**. Untuk Psikologi, usulnya "Tetap", sehingga inisialnya tetap "Psikolog".

### 12.2 Profesi yang ditambahkan (bagian dari SQL utama)

Hanya **4 profesi yang ada di UNESA** yang dimasukkan, yaitu Dokter, Dokter Gigi, Ners, dan Bidan. Keempatnya ada di Bagian C file `ms_nomenklatur_pembaruan_2026-10-28.sql` dan berjalan dalam transaksi yang sama. Profesi lain di Lampiran II hanya dicatat di CSV referensi.

- **Nilai kolom:**
  - `jenis_pendidikan_id = 2` (Pendidikan Profesi di `ms_jns_pendidikan`);
  - `id_jenj_didik = '25'` (jenjang "Profesi" yang sudah ada di daftar jenjang SIAGA aplikasi);
  - `program_id = 'Profesi'`, sama dengan nilai yang diisi `NomenklaturController` untuk jenjang 25;
  - `gelar` = inisial resmi, misalnya `dr.`, `drg.`, `Apt.`, `Ners.`, `Ir.`, `Guru`, `Advokat`.
- **Profesi lain:** profesi selain keempat itu (misalnya Apoteker, PPG, Insinyur, Advokat) tidak dimasukkan. Kode usulannya tetap tercatat di tabel di bawah, kalau suatu saat diperlukan.
- **Kelompok rumpun** (`kode_rumpun`, `kode_sub_rumpun`, `rumpun_id`, `is_kesehatan`) mengikuti grup akademik padanannya di Lampiran I. Contohnya Profesi Dokter mengikuti Ilmu Kedokteran (508/02), Apoteker mengikuti Farmasi (508/05), dan PPG/Konselor mengikuti Pendidikan (505/01).
- **`kode_prodi` = rumpun + sub + "17" + urut.** Nilai "17" dipilih untuk Profesi karena 16/18/19 sudah dipakai S1/S2/S3. Ini **kode internal dan perlu dikonfirmasi**.
- **`status_prodi` = "Dibuka".** Surat R3 butir 3.a menyatakan program profesi tidak harus STEM, dan tidak ada daftar moratorium untuk profesi.
- **Tampilan di aplikasi:** dropdown menampilkan nama jenjang + nama, sehingga tertulis "Profesi Pendidikan Profesi Dokter". Ini sesuai data, hanya agak berulang.

| No. | kode_prodi (usulan) | Nama | Gelar | Kelompok R1 | Kelompok kode (grup padanan) | Masuk SQL |
|---|---|---|---|---|---|---|
| 1 | `5010217001` | Pendidikan Profesi Pengultur Jaringan Tanaman | K.Jar. | A PERTANIAN | 501/02 (20 Ilmu atau Sains Pertanian) | tidak |
| 2 | `5010217002` | Pendidikan Profesi Pemulia Tanaman | P.T. | A PERTANIAN | 501/02 (20 Ilmu atau Sains Pertanian) | tidak |
| 3 | `5010217003` | Pendidikan Profesi Penyuluh Pertanian | Pen. | A PERTANIAN | 501/02 (20 Ilmu atau Sains Pertanian) | tidak |
| 4 | `5020117001` | Pendidikan Profesi Arsitek | P.Ars. | B ARSITEKTUR, DESAIN, DAN PERENCANAAN | 502/01 (24 Arsitektur) | tidak |
| 5 | `5030317001` | Pendidikan Profesi Akuntan | Ak. | C BISNIS | 503/03 (27 Ilmu atau Sains Akuntansi) | tidak |
| 6 | `5050117001` | Pendidikan Profesi Konselor | Kons. | E PENDIDIKAN | 505/01 (33 Pendidikan) | tidak |
| 7 | `5050117002` | Pendidikan Profesi Guru (PPG) | Guru | E PENDIDIKAN | 505/01 (33 Pendidikan) | tidak |
| 8 | `5060117001` | Pendidikan Profesi Insinyur | Ir. | F REKAYASA | 506/01 (34 Rekayasa) | tidak |
| 9 | `5080517001` | Pendidikan Profesi Apoteker | Apt. | H KESEHATAN | 508/05 (40 Ilmu Farmasi) | tidak |
| 10 | `5080617001` | Pendidikan Profesi Bidan | Bdn. | H KESEHATAN | 508/06 (43 Kebidanan) | **ya** (ada di UNESA) |
| 11 | `5080117001` | Pendidikan Profesi Dietisien | Dietisien | H KESEHATAN | 508/01 (41 Ilmu atau Sains Gizi) | tidak |
| 12 | `5080217001` | Pendidikan Profesi Dokter | dr. | H KESEHATAN | 508/02 (37 Ilmu atau Sains Kedokteran) | **ya** (ada di UNESA) |
| 13 | `5080317001` | Pendidikan Profesi Dokter Gigi | drg. | H KESEHATAN | 508/03 (38 Ilmu atau Sains Kedokteran Gigi) | **ya** (ada di UNESA) |
| 14 | `5080417001` | Pendidikan Profesi Dokter Hewan | drh. | H KESEHATAN | 508/04 (39 Ilmu atau Sains Veteriner) | tidak |
| 15 | `5080417002` | Pendidikan Profesi Veterinarian | Vet. | H KESEHATAN | 508/04 (39 Ilmu atau Sains Veteriner) | tidak |
| 16 | `5080817001` | Pendidikan Profesi Fisioterapis | Ftr. | H KESEHATAN | 508/08 (45 Kesehatan) | tidak |
| 17 | `5080717001` | Pendidikan Profesi Ners | Ners. | H KESEHATAN | 508/07 (44 Keperawatan) | **ya** (ada di UNESA) |
| 18 | `5080117002` | Pendidikan Profesi Nutrisionis | Nutr. | H KESEHATAN | 508/01 (41 Ilmu atau Sains Gizi) | tidak |
| 19 | `5080817002` | Pendidikan Profesi Pengobat Tradisional Indonesia | P.T.I. | H KESEHATAN | 508/08 (45 Kesehatan) | tidak |
| 20 | `5080817003` | Pendidikan Profesi Pengobat Tradisional Tiongkok | P.T.T. | H KESEHATAN | 508/08 (45 Kesehatan) | tidak |
| 21 | `5100117001` | Pendidikan Profesi Advokat | Advokat | J HUKUM | 510/01 (47 Hukum) | tidak |
| 22 | `5120117001` | Pendidikan Profesi Pekerja Sosial | Pek.Sos. | L SOSIAL | 512/01 (49 Urusan Publik) | tidak |

### 12.3 Hasil uji

Hasil uji SQL gabungan ada di Bagian 9. Jumlah per jenis/jenjang setelah dijalankan:

| `jenis_pendidikan_id` / `program_id` / `id_jenj_didik` | Jumlah |
|---|---|
| 1 / S1 / 30 | 388 |
| 1 / S2 / 35 | 598 |
| 1 / S3 / 40 | 416 |
| 2 / Profesi / 25 | 4 |
| 3 / D3 / 22 | 256 |
| 3 / D4 / 23 | 238 |
| **Total** | **1.900** |

Skrip tidak lagi memeriksa tabel jenjang. Data `jenjang_pendidikan` yang dikirim pengguna sudah memastikan 22 = D3, 23 = D4, dan 25 = Profesi. Di database uji, `ms_jns_pendidikan`, `jenjang_pendidikan`, dan `tr_ajuan` disalin dari database lokal `siaga`.

## 13. Vokasi: D3 dan Sarjana Terapan (R6)

### 13.1 Cakupan

- Sumber: Lampiran I R6 (hlm. 6–34), yaitu prodi vokasi pada PT binaan Kemendikbudristek. Lampiran II R6 (PT binaan kementerian/lembaga lain, mis. sekolah kedinasan) tidak dipakai.
- Diambil semua nama yang tercentang **D.Tiga** (menjadi `D3`) atau **S.Tr** (menjadi `D4`). Nama yang tercentang keduanya menjadi dua baris. D.Satu, D.Dua, M.Tr, dan D.Tr tidak dimasukkan karena jenjangnya tidak ada di daftar jenjang SIAGA aplikasi.
- Data `jenjang_pendidikan` yang dikirim pengguna (28 Oktober 2026) mengonfirmasi hal ini: jenjang dengan `is_siaga = 1` hanya 22 D3, 23 D4 (sebutan "Sarjana Terapan (D4)"), 25 Profesi, 30 S1, 35 S2, dan 40 S3. Nilainya sama dengan yang diperiksa skrip sebelum menambah baris.
- Hasil: **494 baris** (D3 256, D4 238) dari 484 nama prodi. Tidak ada nama ganda dalam jenjang yang sama, dan tidak ada yang sudah ada di tabel.

### 13.2 Ekstraksi dan verifikasi

1. Posisi garis tabel dan sel centang dibaca dari gambar halaman (150 dpi). Teks nama, nama Inggris, dan gelar diambil dari lapisan OCR. Judul kelompok yang berarsir dipisahkan dari baris prodi.
2. Ejaan OCR hanya dirapikan secara pasti, misalnya huruf "l" yang terbaca di awal "Ilmu"/"Industri" dan potongan kata yang tersambung. Koreksi berbasis kemiripan sempat dicoba lalu **dibatalkan**, karena mengganti kata yang benar (mis. "Perbaikan" → "Perbankan").
3. **Semua halaman 6–34 dicek visual** untuk baris D3/S.Tr: centang, nama, nama Inggris, dan gelar. Semua centang hasil baca otomatis cocok dengan gambar. Koreksi dari pengecekan ini:
   - **34 nama Indonesia**, misalnya "Desain Susana" → "Desain Busana", "Teknologi Elektra Perkeretaapian" → "Teknologi Elektro Perkeretaapian", "BudiDayalkan" → "Budi Daya Ikan", dan "Pub lik" → "Publik";
   - **12 nama Inggris**, misalnya "Minong Karawitan" → "Minang Karawitan" dan "30 Graphic…" → "3D Graphic…";
   - **50 gelar**, misalnya "Korn." → "Kom.", "Os." → "Ds.", "5.1.G." → "S.I.G.", serta titik akhir yang hilang ("T" → "T.", "M.B" → "M.B.", "C.G" → "C.G.");
   - **1 baris yang tidak terbaca otomatis** disalin dari gambar: "Teknologi Rekayasa Instrumentasi dan Kontrol" (S.Tr, hlm. 20).
4. Huruf kecil yang jelas salah cetak dirapikan ("Administrasi perpajakan", "Operasi kapal"). Ejaan berikut **dipertahankan sesuai dokumen** walaupun kemungkinan salah ketik di sumber: "Intrumentasi dan Metrologi", "Teknologi Rekayasa Geometika dan Survei", dan "Rahabilitasi Sosial". Nama Inggris berhuruf kecil di sumber (mis. "Graphic design") juga dibiarkan.
5. "Teknologi Rekayasa Kimia Berkelanjutan" (hlm. 21) tercantum tanpa centang dan tanpa gelar, sehingga tidak dimasukkan.

### 13.3 Nilai kolom

- `jenis_pendidikan_id = 3`. Jenis "Pendidikan Vokasi" (kode 3) ditambahkan ke `ms_jns_pendidikan` dalam transaksi yang sama, hanya bila belum ada. Bila kode 3 sudah dipakai nama lain, jenis itu tidak ditimpa dan baris D3/D4 tidak ditambahkan. Dropdown jenis pendidikan di aplikasi membaca tabel ini (urut `kode_pendidikan`), jadi pilihan "Pendidikan Vokasi" otomatis muncul.
- `id_jenj_didik = '22'` dan `program_id = 'D3'`; `id_jenj_didik = '23'` dan `program_id = 'D4'`. Nilai `program_id` sama dengan `nm_jenj_didik` yang diisi `NomenklaturController`.
- `gelar` = inisial dari kolom Gelar R6 (mis. `T.`, `Kom.`, `Par.`), sama seperti format inisial di baris akademik.
- `status_prodi = "Dibuka"`. Surat R3 butir 3.a menyatakan D3 dan Sarjana Terapan tidak harus STEM, dan tidak ada daftar moratorium vokasi.
- `kode_prodi` = rumpun + sub + **"25" (D3) atau "26" (D4)** + urut. Ini kode internal usulan (lihat Bagian 10 butir 11).
- Kelompok rumpun mengikuti kelompok R6, dipetakan ke kelompok kode yang sudah dipakai tabel (Bagian 13.4). `rumpun_id` dan `is_kesehatan` mengikuti kelompok kode tersebut.
- Kolom tanda "*" pada sebagian baris R6 (63 baris D3/S.Tr) tidak dijelaskan di batang tubuh keputusan. Tandanya dicatat di CSV referensi tetapi tidak memengaruhi SQL.

### 13.4 Pemetaan kelompok R6 ke kelompok kode tabel

| Kelompok R6 | Kelompok kode tabel (`kode_rumpun`/`kode_sub_rumpun`) | Contoh prodi akademik di kelompok kode itu | D3 | D4 |
|---|---|---|---|---|
| 1 Seni | 100/04 | Antropologi Tari, Estetika Film, Etnomusikologi | 13 | 26 |
| 2 Linguistik | 100/02 | Bahasa Aceh, Bahasa Arab, Bahasa Bali | 11 | 6 |
| 3 Sosial | 200/04 | Agama dan Budaya, Antropologi, Antropologi Budaya | 2 | 4 |
| 4 Ekonomi | 200/01 | Ekonomi, Ekonomi Kependudukan dan Ketenagakerjaan, Ekonomi Koperasi | 0 | 3 |
| 6 Kimia | 300/07 | Biokimia, Ilmu Bahan/ Ilmu Material, Kimia | 3 | 3 |
| 7 Biologi | 300/03 | Biologi, Biologi Perkembangan Hewan, Biologi Reproduksi | 1 | 0 |
| 8 Komputer | 400/01 | Ilmu Komputer, Informatika, Kecerdasan Buatan | 6 | 11 |
| 9 Matematika | 400/03 | Ilmu Aktuaria, Matematika, Matematika Terapan | 5 | 0 |
| 10 Ilmu atau Sains Pertanian | 501/02 | Agribisnis, Agroekoteknologi, Agroforestri Tropis | 14 | 15 |
| 11 Peternakan | 501/03 | Biosains Hewan, Fisiologi Hewan, Nutrisi Ternak | 6 | 5 |
| 12 Ilmu atau Sains Perikanan | 501/01 | Ilmu Perikanan, Manajemen Sumber Daya Perairan, Pengelolaan Sumber Daya Perairan | 5 | 8 |
| 13 Arsitektur | 502/01 | Arsitektur, Arsitektur Lanskap | 2 | 1 |
| 14 Desain | 502/02 | Desain, Desain Interaktif, Desain Interior | 8 | 6 |
| 15 Akuntansi | 503/03 | Akuntansi, Ilmu Akuntansi, Sains Akuntansi | 1 | 4 |
| 16 Manajemen | 503/04 | Administrasi Pajak, Ilmu Manajemen, Manajemen | 10 | 8 |
| 17 Logistik | 503/05 | Logistik, Manajemen Logistik | 5 | 2 |
| 18 Administrasi Bisnis | 503/01 | Administrasi Bisnis | 3 | 1 |
| 19 Bisnis | 503/02 | Bisnis Digital, Bisnis Maritim, Bisnis Musik | 8 | 7 |
| 19A Bisnis Digital | 503/06 | Bisnis Digital | 0 | 2 |
| 20 Ilmu atau Sains Komunikasi | 504/01 | Hubungan Masyarakat, Ilmu Komunikasi, Jurnalistik | 6 | 2 |
| 21 Rekayasa | 506/01 | Manajemen Rekayasa, Rekayasa Aeronautika, Rekayasa Berkelanjutan | 79 | 64 |
| 22 Ilmu Lingkungan | 507/01 | Ilmu Lingkungan, Manajemen Daerah Aliran Sungai, Manajemen Lingkungan | 2 | 0 |
| 23 Kehutanan | 507/02 | Kehutanan, Manajemen Hutan, Pengelolaan Hutan | 6 | 1 |
| 24 Ilmu atau Sains Kedokteran | 508/02 | Ilmu Biomedis, Ilmu Kedokteran, Imunologi | 1 | 1 |
| 25 Ilmu atau Sains Veteriner | 508/04 | Entomologi Kesehatan, Entomologi Veteriner, Ilmu Biomedis Veteriner | 2 | 0 |
| 26 Ilmu atau Sains Farmasi | 508/05 | Farmasi, Farmasi Industri, Farmasi Klinis | 1 | 0 |
| 27 Ilmu atau Sains Gizi | 508/01 | Gizi, Gizi Masyarakat, Ilmu Gizi | 1 | 2 |
| 28 Kesehatan Masyarakat | 508/09 | Epidemiologi, Kesehatan Masyarakat | 1 | 0 |
| 29 Kebidanan | 508/06 | Kebidanan | 1 | 1 |
| 30 Keperawatan | 508/07 | Keperawatan | 1 | 1 |
| 31 Ilmu atau Sains Kesehatan | 508/08 | Administrasi Kesehatan, Administrasi Rumah Sakit, Fisioterapi | 20 | 15 |
| 32 Ilmu atau Sains Informasi | 509/01 | Ilmu Informasi, Perpustakaan dan Sains Informasi, Sains Informasi | 2 | 2 |
| 33 Hukum | 510/01 | Hukum, Hukum Agraria dan Pertanahan, Hukum Bisnis | 1 | 1 |
| 35 Urusan Publik | 512/01 | Administrasi Publik, Kebijakan Pendidikan, Kebijakan Publik | 1 | 8 |
| 36 Ilmu atau Sains Keolahragaan | 513/01 | Fisiologi Keolahragaan, Ilmu Keolahragaan, Manajemen Olahraga | 2 | 0 |
| 50 Pariwisata | 514/01 | Pariwisata | 8 | 6 |
| 51 Transportasi | 515/01 | Transportasi | 11 | 10 |
| O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin | 516/01 | Bioetika, Bioinformatika, Biokewirausahaan | 7 | 12 |
| **Jumlah** | | | **256** | **238** |

Kelompok 21 (Rekayasa) di R6 memiliki 24 subkelompok (Rekayasa Biomedis, Dirgantara, Elektro, Mesin, Sipil, dan lain-lain). Semuanya dipetakan ke 506/01, karena tabel juga menyimpan seluruh prodi rekayasa akademik di satu kelompok itu. Nama subkelompok tetap dicatat di CSV.
