-- =============================================================================
-- PEMBARUAN public.ms_nomenklatur (database "siaga", aplikasi SIARJUNA)
-- Disusun : 28 Oktober 2026 (dibantu Claude), dari dump ms_nomenklatur.sql 28/10/2026 11:23 (1.370 baris)
-- Dasar   : 1) Keputusan Dirjen Pendidikan Tinggi Kemdiktisaintek Nomor 96/B/KPT/2025 (9 September 2025),
--              Lampiran I - nama program studi akademik (S/M/Dr) dan inisial gelar.
--           2) Surat Direktur Kelembagaan Ditjen Dikti Nomor 1145/DST/B3/DT.03.02/2026 (14 Februari 2026),
--              lampiran program Sarjana "Dibuka/Moratorium" untuk usul pembukaan prodi melalui SIAGA.
--           3) Lampiran II Keputusan 96/B/KPT/2025 bagian I (Program Profesi), hanya profesi yang ada di UNESA:
--              Dokter, Dokter Gigi, Ners, Bidan (jenis_pendidikan_id 2, id_jenj_didik '25', program_id 'Profesi').
--           4) Keputusan Dirjen Pendidikan Vokasi Nomor 27/D/M/2022 (14 Maret 2022), Lampiran I - yang tercentang
--              D.Tiga (program_id 'D3', id_jenj_didik '22') dan S.Tr (program_id 'D4', id_jenj_didik '23'),
--              jenis_pendidikan_id 3 ("Pendidikan Vokasi" di ms_jns_pendidikan, ditambahkan bila belum ada).
-- Laporan : docs/nomenklatur/laporan-riset-nomenklatur-2026-10-28.md
--
-- SIFAT SKRIP
--   * Hanya UPDATE dan INSERT. Tidak membuat tabel apa pun (tanpa tabel cadangan atau tabel sementara),
--     tidak menghapus baris, tidak mengubah struktur, dan tidak mengubah kode_prodi yang sudah ada.
--   * Satu transaksi: bila ada perintah yang gagal, semuanya batal.
--   * Setiap UPDATE memuat nilai lama di WHERE. Nilai yang di server sudah berbeda dari dump dilewati
--     (UPDATE 0), tidak ditimpa.
--   * INSERT melewati kode_prodi yang sudah ada dan nama+program yang sudah ada. Baris D3/D4 hanya masuk
--     bila kode_pendidikan 3 di ms_jns_pendidikan adalah "Pendidikan Vokasi".
--   * Aman dijalankan ulang. gen_random_uuid() butuh PostgreSQL 13 atau lebih baru.
--   * Usulan penonaktifan (bagian 4) SENGAJA dikomentari.
--
-- CARA MENJALANKAN (uji dulu di salinan database):
--   psql -v ON_ERROR_STOP=1 -h <host> -U <user> -d siaga -f ms_nomenklatur_pembaruan_2026-10-28.sql
--   Hasil bila data server sama dengan dump: 57x "UPDATE 1", lalu "INSERT 0 1" (jenis Vokasi), lalu INSERT
--   per jenjang: S1 9, S2 12, S3 11, Profesi 4, D3 256, D4 238. Angka yang lebih kecil berarti baris itu dilewati.
-- PEMBATALAN: ms_nomenklatur_pembatalan_2026-10-28.sql (kebalikan skrip ini, juga tanpa tabel baru).
--   Cadangan penuh, bila diinginkan, dibuat sebagai berkas sebelum menjalankan, misalnya:
--   pg_dump -h <host> -U <user> -d siaga -t public.ms_nomenklatur -t public.ms_jns_pendidikan -f cadangan.sql
-- =============================================================================

BEGIN;

-- 1. Perubahan nilai: 57 nilai pada 52 baris (kode_prodi tidak berubah)

-- 1a. Nama disesuaikan dengan Kepdirjen 96/B/KPT/2025 (Bagian B): 5 nilai
UPDATE public.ms_nomenklatur SET name_prodi = 'Manajemen Retail', updated_at = now() WHERE kode_prodi = '5030416005' AND name_prodi = 'Manajemen Ritel';  -- S1; Kepdirjen 96/2025 Lamp. I #280; SIAGA 2026 no. 185 "Manajemen Retail"
UPDATE public.ms_nomenklatur SET name_prodi = 'Pendidikan Vokasional Desain Mode', updated_at = now() WHERE kode_prodi = '5050116073' AND name_prodi = 'Pendidikan Vokasional Desain Fashion';  -- S1; Kepdirjen 96/2025 Lamp. I #395; SIAGA 2026 no. 270 "Pendidikan Vokasional Desain Mode"
UPDATE public.ms_nomenklatur SET name_prodi = 'Rekayasa Pengindraan Jauh', updated_at = now() WHERE kode_prodi = '5060118017' AND name_prodi = 'Rekayasa Penginderaan Jauh';  -- S2; Kepdirjen 96/2025 Lamp. I #416
UPDATE public.ms_nomenklatur SET name_prodi = 'Teknik Pengindraan Jauh', updated_at = now() WHERE kode_prodi = '5060118062' AND name_prodi = 'Teknik Penginderaan Jauh';  -- S2; Kepdirjen 96/2025 Lamp. I #416 (Teknik = padanan Rekayasa, grup 34)
UPDATE public.ms_nomenklatur SET name_prodi = 'Pengindraan Jauh', updated_at = now() WHERE kode_prodi = '5160118019' AND name_prodi = 'Penginderaan Jauh';  -- S2; Kepdirjen 96/2025 Lamp. I #554

-- 1b. Perbaikan salah ketik/format nama: 16 nilai
UPDATE public.ms_nomenklatur SET name_prodi = 'Koreografi Inkuiri', updated_at = now() WHERE kode_prodi = '1000416016' AND name_prodi = 'KOREOGRAFI INKUIRI';  -- S1; Kepdirjen 96/2025 Lamp. I #10; SIAGA 2026 no. 17
UPDATE public.ms_nomenklatur SET name_prodi = 'Ilmu Bahan/Ilmu Material', updated_at = now() WHERE kode_prodi = '3000718001' AND name_prodi = 'Ilmu Bahan/ Ilmu Material';  -- S2; Kepdirjen 96/2025 Lamp. I #172
UPDATE public.ms_nomenklatur SET name_prodi = 'Sains Bahan/Sains Material', updated_at = now() WHERE kode_prodi = '3000718002' AND name_prodi = 'Sains Bahan/ Sains Material';  -- S2; Kepdirjen 96/2025 Lamp. I #172
UPDATE public.ms_nomenklatur SET name_prodi = 'Ilmu Bahan/Ilmu Material', updated_at = now() WHERE kode_prodi = '3000719001' AND name_prodi = 'Ilmu Bahan/ Ilmu Material';  -- S3; Kepdirjen 96/2025 Lamp. I #172
UPDATE public.ms_nomenklatur SET name_prodi = 'Sains Bahan/Sains Material', updated_at = now() WHERE kode_prodi = '3000719002' AND name_prodi = 'Sains Bahan/ Sains Material';  -- S3; Kepdirjen 96/2025 Lamp. I #172
UPDATE public.ms_nomenklatur SET name_prodi = 'Pendidikan Bahasa dan Sastra Aceh', updated_at = now() WHERE kode_prodi = '5050116076' AND name_prodi = 'Pendidikan Bahasa dan sastra Aceh';  -- S1; Kepdirjen 96/2025 Lamp. I #333
UPDATE public.ms_nomenklatur SET name_prodi = 'Rekayasa Perkeretaapian', updated_at = now() WHERE kode_prodi = '5060116044' AND name_prodi = 'Rekayasa Perkeretapian';  -- S1; Kepdirjen 96/2025 Lamp. I #450; SIAGA 2026 no. 316
UPDATE public.ms_nomenklatur SET name_prodi = 'Rekayasa Telekomunikasi', updated_at = now() WHERE kode_prodi = '5060116045' AND name_prodi = 'RekayasaTelekomunikasi';  -- S1; Kepdirjen 96/2025 Lamp. I #451; SIAGA 2026 no. 317
UPDATE public.ms_nomenklatur SET name_prodi = 'Teknik Perkeretaapian', updated_at = now() WHERE kode_prodi = '5060116090' AND name_prodi = 'Teknik Perkeretapian';  -- S1; Kepdirjen 96/2025 Lamp. I #450; SIAGA 2026 no. 316
UPDATE public.ms_nomenklatur SET name_prodi = 'Teknik Telekomunikasi', updated_at = now() WHERE kode_prodi = '5060116091' AND name_prodi = 'TeknikTelekomunikasi';  -- S1; Kepdirjen 96/2025 Lamp. I #451; SIAGA 2026 no. 317
UPDATE public.ms_nomenklatur SET name_prodi = 'Rekayasa Telekomunikasi', updated_at = now() WHERE kode_prodi = '5060118044' AND name_prodi = 'RekayasaTelekomunikasi';  -- S2; Kepdirjen 96/2025 Lamp. I #451
UPDATE public.ms_nomenklatur SET name_prodi = 'Teknik Telekomunikasi', updated_at = now() WHERE kode_prodi = '5060118088' AND name_prodi = 'TeknikTelekomunikasi';  -- S2; Kepdirjen 96/2025 Lamp. I #451
UPDATE public.ms_nomenklatur SET name_prodi = 'Rekayasa Telekomunikasi', updated_at = now() WHERE kode_prodi = '5060119036' AND name_prodi = 'RekayasaTelekomunikasi';  -- S3; Kepdirjen 96/2025 Lamp. I #451
UPDATE public.ms_nomenklatur SET name_prodi = 'Teknik Telekomunikasi', updated_at = now() WHERE kode_prodi = '5060119172' AND name_prodi = 'TeknikTelekomunikasi';  -- S3; Kepdirjen 96/2025 Lamp. I #451
UPDATE public.ms_nomenklatur SET name_prodi = 'Pengelolaan Sumber Daya Alam dan Lingkungan', updated_at = now() WHERE kode_prodi = '5070118013' AND name_prodi = 'Pengelolaan Sumberdaya Alam dan Lingkungan';  -- S2; Kepdirjen 96/2025 Lamp. I #458
UPDATE public.ms_nomenklatur SET name_prodi = 'Pembangunan dan Keuangan Berkelanjutan', updated_at = now() WHERE kode_prodi = '5160118034' AND name_prodi = 'Pembangunan dan Keuangan Berkelanjutan, Program Magister Universitas Udayana';  -- S2; Kepdirjen 96/2025 Lamp. I #576

-- 1c. Format inisial gelar: 11 nilai
UPDATE public.ms_nomenklatur SET gelar = 'Pd.', updated_at = now() WHERE kode_prodi = '1000216034' AND gelar = 'S.Pd';  -- S1; Kepdirjen 96/2025 Lamp. I #330
UPDATE public.ms_nomenklatur SET gelar = 'Sn.', updated_at = now() WHERE kode_prodi = '1000416016' AND gelar = 'Sn';  -- S1; Kepdirjen 96/2025 Lamp. I #10
UPDATE public.ms_nomenklatur SET gelar = 'Sn.', updated_at = now() WHERE kode_prodi = '1000416017' AND gelar = 'Sn';  -- S1; Kepdirjen 96/2025 Lamp. I #15
UPDATE public.ms_nomenklatur SET gelar = 'Pi.', updated_at = now() WHERE kode_prodi = '5010118007' AND gelar = 'M';  -- S2; Kepdirjen 96/2025 Lamp. I #249
UPDATE public.ms_nomenklatur SET gelar = 'Pi.', updated_at = now() WHERE kode_prodi = '5010118008' AND gelar = 'M';  -- S2; Kepdirjen 96/2025 Lamp. I #249
UPDATE public.ms_nomenklatur SET gelar = 'Ds.', updated_at = now() WHERE kode_prodi = '5020218003' AND gelar = 'M.Ds.';  -- S2; Kepdirjen 96/2025 Lamp. I #266
UPDATE public.ms_nomenklatur SET gelar = 'Ds.', updated_at = now() WHERE kode_prodi = '5020219003' AND gelar = 'Dr.';  -- S3; Kepdirjen 96/2025 Lamp. I #266
UPDATE public.ms_nomenklatur SET gelar = 'Bns.', updated_at = now() WHERE kode_prodi = '5030216010' AND gelar = 'S.E';  -- S1; Kepdirjen 96/2025 Lamp. I #288
UPDATE public.ms_nomenklatur SET gelar = 'M.', updated_at = now() WHERE kode_prodi = '5030416005' AND gelar = 'S.E';  -- S1; Kepdirjen 96/2025 Lamp. I #280
UPDATE public.ms_nomenklatur SET gelar = 'Pd.', updated_at = now() WHERE kode_prodi = '5050116076' AND gelar = 'sarjana pendidikan (SPd)';  -- S1; Kepdirjen 96/2025 Lamp. I #333
UPDATE public.ms_nomenklatur SET gelar = 'E.', updated_at = now() WHERE kode_prodi = '5160118034' AND gelar = 'E';  -- S2; Kepdirjen 96/2025 Lamp. I #576

-- 1d. Nama Inggris: 1 nilai
UPDATE public.ms_nomenklatur SET name_prodi_eng = 'Choreographic Inquiry', updated_at = now() WHERE kode_prodi = '1000416016' AND name_prodi_eng = 'INVESTIGATION OF CHOREOGRAPHY';  -- S1; Kepdirjen 96/2025 Lamp. I #10

-- 1e. Hapus spasi berlebih (isi nama tidak berubah): 24 nilai
UPDATE public.ms_nomenklatur SET name_prodi_eng = 'Islamic Economic', updated_at = now() WHERE kode_prodi = '2000119007' AND name_prodi_eng = 'Islamic Economic ';  -- S3
UPDATE public.ms_nomenklatur SET name_prodi = 'Teknologi Pangan dan Hasil Pertanian', updated_at = now() WHERE kode_prodi = '5010416006' AND name_prodi = 'Teknologi Pangan dan Hasil Pertanian ';  -- S1
UPDATE public.ms_nomenklatur SET name_prodi = 'Teknologi Pangan dan Hasil Pertanian', updated_at = now() WHERE kode_prodi = '5010418007' AND name_prodi = 'Teknologi Pangan dan Hasil Pertanian ';  -- S2
UPDATE public.ms_nomenklatur SET name_prodi = 'Teknologi Pangan dan Hasil Pertanian', updated_at = now() WHERE kode_prodi = '5010419007' AND name_prodi = 'Teknologi Pangan dan Hasil Pertanian ';  -- S3
UPDATE public.ms_nomenklatur SET name_prodi_eng = 'Maritime Business', updated_at = now() WHERE kode_prodi = '5030216005' AND name_prodi_eng = 'Maritime Business ';  -- S1
UPDATE public.ms_nomenklatur SET name_prodi_eng = 'Entrepreneurship', updated_at = now() WHERE kode_prodi = '5030216007' AND name_prodi_eng = 'Entrepreneurship ';  -- S1
UPDATE public.ms_nomenklatur SET name_prodi_eng = 'Digital Bussiness', updated_at = now() WHERE kode_prodi = '5030618001' AND name_prodi_eng = 'Digital Bussiness ';  -- S2
UPDATE public.ms_nomenklatur SET name_prodi_eng = 'Digital Bussiness', updated_at = now() WHERE kode_prodi = '5030619001' AND name_prodi_eng = 'Digital Bussiness ';  -- S3
UPDATE public.ms_nomenklatur SET name_prodi = 'Pendidikan Bahasa Makassar', updated_at = now() WHERE kode_prodi = '5050116024' AND name_prodi = 'Pendidikan Bahasa Makassar ';  -- S1
UPDATE public.ms_nomenklatur SET name_prodi = 'Pendidikan Bahasa dan Kebudayaan Sunda', updated_at = now() WHERE kode_prodi = '5050118023' AND name_prodi = 'Pendidikan Bahasa dan Kebudayaan  Sunda';  -- S2
UPDATE public.ms_nomenklatur SET name_prodi_eng = 'Electrical Power Engineering', updated_at = now() WHERE kode_prodi = '5060116009' AND name_prodi_eng = 'Electrical  Power Engineering';  -- S1
UPDATE public.ms_nomenklatur SET name_prodi = 'Rekayasa Minyak dan Gas', updated_at = now() WHERE kode_prodi = '5060116039' AND name_prodi = 'Rekayasa Minyak dan Gas ';  -- S1
UPDATE public.ms_nomenklatur SET name_prodi_eng = 'Electrical Power Engineering', updated_at = now() WHERE kode_prodi = '5060116056' AND name_prodi_eng = 'Electrical  Power Engineering';  -- S1
UPDATE public.ms_nomenklatur SET name_prodi = 'Teknik Minyak dan Gas', updated_at = now() WHERE kode_prodi = '5060116085' AND name_prodi = 'Teknik Minyak dan Gas ';  -- S1
UPDATE public.ms_nomenklatur SET name_prodi = 'Rekayasa Energi Panas Bumi', updated_at = now() WHERE kode_prodi = '5060118009' AND name_prodi = 'Rekayasa Energi Panas Bumi ';  -- S2
UPDATE public.ms_nomenklatur SET name_prodi_eng = 'Electrical Power Engineering', updated_at = now() WHERE kode_prodi = '5060118010' AND name_prodi_eng = 'Electrical  Power Engineering';  -- S2
UPDATE public.ms_nomenklatur SET name_prodi = 'Teknik Energi Panas Bumi', updated_at = now() WHERE kode_prodi = '5060118054' AND name_prodi = 'Teknik Energi Panas Bumi ';  -- S2
UPDATE public.ms_nomenklatur SET name_prodi_eng = 'Electrical Power Engineering', updated_at = now() WHERE kode_prodi = '5060118055' AND name_prodi_eng = 'Electrical  Power Engineering';  -- S2
UPDATE public.ms_nomenklatur SET name_prodi = 'Fisioterapi', updated_at = now() WHERE kode_prodi = '5080816003' AND name_prodi = 'Fisioterapi ';  -- S1
UPDATE public.ms_nomenklatur SET name_prodi = 'Fisioterapi', updated_at = now() WHERE kode_prodi = '5080818005' AND name_prodi = 'Fisioterapi ';  -- S2
UPDATE public.ms_nomenklatur SET name_prodi = 'Rekayasa Keolahragaan', updated_at = now() WHERE kode_prodi = '5130116003' AND name_prodi = 'Rekayasa Keolahragaan ';  -- S1
UPDATE public.ms_nomenklatur SET name_prodi = 'Rekayasa Tata Kelola Air Terpadu', updated_at = now() WHERE kode_prodi = '5160116017' AND name_prodi = 'Rekayasa Tata Kelola Air Terpadu ';  -- S1
UPDATE public.ms_nomenklatur SET name_prodi_eng = 'Coffee Economics', updated_at = now() WHERE kode_prodi = '5160118030' AND name_prodi_eng = 'Coffee Economics ';  -- S2
UPDATE public.ms_nomenklatur SET name_prodi = 'Konseling dan Psikoterapi', updated_at = now() WHERE kode_prodi = '5160119008' AND name_prodi = 'Konseling dan Psikoterapi ';  -- S3

-- 2. Jenis pendidikan "Pendidikan Vokasi" (kode 3) untuk baris D3/D4; dilewati bila kode 3 sudah ada (INSERT 0 0)
INSERT INTO public.ms_jns_pendidikan (id_jns_pendidikan, nama_jns_pendidikan, kode_pendidikan, created_at, updated_at)
SELECT gen_random_uuid(), 'Pendidikan Vokasi', '3', now(), now()
 WHERE NOT EXISTS (SELECT 1 FROM public.ms_jns_pendidikan WHERE kode_pendidikan = '3');

-- 3. Penambahan nomenklatur (Bagian C). kode_prodi = kode_rumpun(3) + kode_sub_rumpun(2) + jenjang + urut(3):
--    jenjang 16/18/19 = S1/S2/S3 (pola tabel), 17 = Profesi, 25 = D3, 26 = D4 (usulan kode internal).

-- 3.1 S1: 9 baris. Sumber: Kepdirjen 96/2025 Lampiran I (centang S) + "Dibuka" di Surat 1145/2026; 4 S1 kesehatan UNESA dari Kepdirjen 96 saja
INSERT INTO public.ms_nomenklatur (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
       jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id,
       created_at, updated_at, deleted_at, id_updater, soft_delete, id_sms)
SELECT v.kode_prodi, v.name_prodi, v.name_prodi_eng, v.program_id, v.gelar, v.status_prodi_id, v.status_prodi,
       v.jenis_pendidikan_id, v.kode_sub_rumpun, v.is_kesehatan, v.id_jenj_didik, v.kode_rumpun, v.rumpun_id,
       now(), now(), NULL, NULL, '0', gen_random_uuid()::text
  FROM (VALUES
  ('5010116009', 'Akuakultur', 'Aquaculture', 'S1', 'Pi.', 2, 'Dibuka', 1, '01', '0', '30', '501', 'GV92'),  -- Kepdirjen 96/2025 Lamp. I #248 (S tercentang); Surat 1145/2026 no. 156 "Akuakultur" = Dibuka
  ('5010116010', 'Manajemen Sumber Daya Perairan', 'Water or Aquatic Resources Management', 'S1', 'Pi.', 1, 'STEM', 1, '01', '0', '30', '501', 'GV92'),  -- Kepdirjen 96/2025 Lamp. I #249 (S tercentang); Surat 1145/2026 no. 157 "Manajemen atau Pengelolaan Sumber Daya Perairan" = Dibuka
  ('5010116011', 'Pengelolaan Sumber Daya Perairan', 'Water or Aquatic Resources Management', 'S1', 'Pi.', 1, 'STEM', 1, '01', '0', '30', '501', 'GV92'),  -- Kepdirjen 96/2025 Lamp. I #249 (S tercentang); Surat 1145/2026 no. 157 "Manajemen atau Pengelolaan Sumber Daya Perairan" = Dibuka
  ('5020216006', 'Desain Mode', 'Fashion Design', 'S1', 'Ds.', 2, 'Dibuka', 1, '02', '0', '30', '502', 'JG29'),  -- Kepdirjen 96/2025 Lamp. I #267 (S tercentang); Surat 1145/2026 no. 172 "Desain Mode" = Dibuka
  ('5080816005', 'Kesehatan Lingkungan', 'Environmental Health', 'S1', 'K.M.', 1, 'STEM', 1, '08', '1', '30', '508', 'QL11'),  -- Kepdirjen 96/2025 Lamp. I #502 (S tercentang); Surat 1145/2026 no. 333 "Kesehatan Lingkungan" = Dibuka
  ('5080216003', 'Kedokteran', 'Medicine', 'S1', 'Ked.', 1, 'STEM', 1, '02', '1', '30', '508', 'PE84'),  -- Kepdirjen 96/2025 Lamp. I #482 (S tercentang); tidak tercantum di lampiran SIAGA 2026; ada di UNESA
  ('5080316001', 'Kedokteran Gigi', 'Dental Medicine', 'S1', 'K.G.', 1, 'STEM', 1, '03', '1', '30', '508', 'PR29'),  -- Kepdirjen 96/2025 Lamp. I #484 (S tercentang); tidak tercantum di lampiran SIAGA 2026; ada di UNESA
  ('5080616001', 'Kebidanan', 'Midwifery', 'S1', 'Keb.', 1, 'STEM', 1, '06', '1', '30', '508', 'QI95'),  -- Kepdirjen 96/2025 Lamp. I #504 (S tercentang); tidak tercantum di lampiran SIAGA 2026; ada di UNESA
  ('5080716001', 'Keperawatan', 'Nursing', 'S1', 'Kep.', 1, 'STEM', 1, '07', '1', '30', '508', 'QK58')   -- Kepdirjen 96/2025 Lamp. I #505 (S tercentang); tidak tercantum di lampiran SIAGA 2026; ada di UNESA
  ) AS v (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
         jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id)
 WHERE NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m WHERE m.kode_prodi = v.kode_prodi)
   AND NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m
                    WHERE lower(trim(m.name_prodi)) = lower(v.name_prodi) AND m.program_id = v.program_id);

-- 3.2 S2: 12 baris. Sumber: Kepdirjen 96/2025 Lampiran I (centang M)
INSERT INTO public.ms_nomenklatur (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
       jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id,
       created_at, updated_at, deleted_at, id_updater, soft_delete, id_sms)
SELECT v.kode_prodi, v.name_prodi, v.name_prodi_eng, v.program_id, v.gelar, v.status_prodi_id, v.status_prodi,
       v.jenis_pendidikan_id, v.kode_sub_rumpun, v.is_kesehatan, v.id_jenj_didik, v.kode_rumpun, v.rumpun_id,
       now(), now(), NULL, NULL, '0', gen_random_uuid()::text
  FROM (VALUES
  ('2000118011', 'Ekonomi Syariah', 'Islamic Economics', 'S2', 'E.', 2, 'Dibuka', 1, '01', '0', '35', '200', 'TRYU'),  -- Kepdirjen 96/2025 Lamp. I #148 (M tercentang)
  ('5010118009', 'Akuakultur', 'Aquaculture', 'S2', 'Pi.', 2, 'Dibuka', 1, '01', '0', '35', '501', 'GV92'),  -- Kepdirjen 96/2025 Lamp. I #248 (M tercentang)
  ('5020218006', 'Desain Mode', 'Fashion Design', 'S2', 'Ds.', 2, 'Dibuka', 1, '02', '0', '35', '502', 'JG29'),  -- Kepdirjen 96/2025 Lamp. I #267 (M tercentang)
  ('5050118067', 'Pendidikan Agama Islam', 'Islamic Religion Education', 'S2', 'Pd.', 2, 'Dibuka', 1, '01', '0', '35', '505', 'NA74'),  -- Kepdirjen 96/2025 Lamp. I #352 (M tercentang)
  ('5080818014', 'Sains Teknologi Laboratorium Medik', 'Medical Laboratory Technology Science', 'S2', 'Si.T.L.M.', 2, 'Dibuka', 1, '08', '1', '35', '508', 'QL11'),  -- Kepdirjen 96/2025 Lamp. I #516 (M tercentang)
  ('5100118011', 'Hukum Syariah', 'Syariah Law', 'S2', 'H.', 2, 'Dibuka', 1, '01', '0', '35', '510', 'RK96'),  -- Kepdirjen 96/2025 Lamp. I #527 (M tercentang)
  ('5100118012', 'Kenotariatan', 'Notary Law', 'S2', 'H.', 2, 'Dibuka', 1, '01', '0', '35', '510', 'RK96'),  -- Kepdirjen 96/2025 Lamp. I #529 (M tercentang)
  ('5160118035', 'Inovasi Sistem dan Teknologi', 'System and Technology Innovation', 'S2', 'I.S.T.', 2, 'Dibuka', 1, '01', '0', '35', '516', 'SQ79'),  -- Kepdirjen 96/2025 Lamp. I #559 (M tercentang)
  ('5160118036', 'Kajian Ketahanan Nasional', 'National Resillience Studies', 'S2', 'Si.', 2, 'Dibuka', 1, '01', '0', '35', '516', 'SQ79'),  -- Kepdirjen 96/2025 Lamp. I #560 (M tercentang)
  ('5160118037', 'Kajian Strategis dan Global', 'Strategic and Global Studies', 'S2', 'Si.', 2, 'Dibuka', 1, '01', '0', '35', '516', 'SQ79'),  -- Kepdirjen 96/2025 Lamp. I #561 (M tercentang)
  ('5160118038', 'Kajian Terorisme', 'Terrorism Studies', 'S2', 'Si.', 2, 'Dibuka', 1, '01', '0', '35', '516', 'SQ79'),  -- Kepdirjen 96/2025 Lamp. I #562 (M tercentang)
  ('5160118039', 'Ketahanan Nasional', 'National Resillience', 'S2', 'Si.', 2, 'Dibuka', 1, '01', '0', '35', '516', 'SQ79')   -- Kepdirjen 96/2025 Lamp. I #563 (M tercentang)
  ) AS v (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
         jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id)
 WHERE NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m WHERE m.kode_prodi = v.kode_prodi)
   AND NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m
                    WHERE lower(trim(m.name_prodi)) = lower(v.name_prodi) AND m.program_id = v.program_id);

-- 3.3 S3: 11 baris. Sumber: Kepdirjen 96/2025 Lampiran I (centang Dr)
INSERT INTO public.ms_nomenklatur (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
       jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id,
       created_at, updated_at, deleted_at, id_updater, soft_delete, id_sms)
SELECT v.kode_prodi, v.name_prodi, v.name_prodi_eng, v.program_id, v.gelar, v.status_prodi_id, v.status_prodi,
       v.jenis_pendidikan_id, v.kode_sub_rumpun, v.is_kesehatan, v.id_jenj_didik, v.kode_rumpun, v.rumpun_id,
       now(), now(), NULL, NULL, '0', gen_random_uuid()::text
  FROM (VALUES
  ('2000119008', 'Ekonomi Syariah', 'Islamic Economics', 'S3', 'E.', 2, 'Dibuka', 1, '01', '0', '40', '200', 'TRYU'),  -- Kepdirjen 96/2025 Lamp. I #148 (Dr tercentang)
  ('5010119005', 'Akuakultur', 'Aquaculture', 'S3', 'Pi.', 2, 'Dibuka', 1, '01', '0', '40', '501', 'GV92'),  -- Kepdirjen 96/2025 Lamp. I #248 (Dr tercentang)
  ('5010119006', 'Manajemen Sumber Daya Perairan', 'Water or Aquatic Resources Management', 'S3', 'Pi.', 1, 'STEM', 1, '01', '0', '40', '501', 'GV92'),  -- Kepdirjen 96/2025 Lamp. I #249 (Dr tercentang)
  ('5010119007', 'Pengelolaan Sumber Daya Perairan', 'Water or Aquatic Resources Management', 'S3', 'Pi.', 1, 'STEM', 1, '01', '0', '40', '501', 'GV92'),  -- Kepdirjen 96/2025 Lamp. I #249 (Dr tercentang)
  ('5020219006', 'Desain Mode', 'Fashion Design', 'S3', 'Ds.', 2, 'Dibuka', 1, '02', '0', '40', '502', 'JG29'),  -- Kepdirjen 96/2025 Lamp. I #267 (Dr tercentang)
  ('5050119050', 'Evaluasi Pendidikan', 'Education Evaluation', 'S3', 'Pd.', 2, 'Dibuka', 1, '01', '0', '40', '505', 'NA74'),  -- Kepdirjen 96/2025 Lamp. I #309 (Dr tercentang)
  ('5050119051', 'Pendidikan Agama Islam', 'Islamic Religion Education', 'S3', 'Pd.', 2, 'Dibuka', 1, '01', '0', '40', '505', 'NA74'),  -- Kepdirjen 96/2025 Lamp. I #352 (Dr tercentang)
  ('5160119014', 'Kajian Ketahanan Nasional', 'National Resillience Studies', 'S3', 'Si.', 2, 'Dibuka', 1, '01', '0', '40', '516', 'SQ79'),  -- Kepdirjen 96/2025 Lamp. I #560 (Dr tercentang)
  ('5160119015', 'Kajian Strategis dan Global', 'Strategic and Global Studies', 'S3', 'Si.', 2, 'Dibuka', 1, '01', '0', '40', '516', 'SQ79'),  -- Kepdirjen 96/2025 Lamp. I #561 (Dr tercentang)
  ('5160119016', 'Kajian Terorisme', 'Terrorism Studies', 'S3', 'Si.', 2, 'Dibuka', 1, '01', '0', '40', '516', 'SQ79'),  -- Kepdirjen 96/2025 Lamp. I #562 (Dr tercentang)
  ('5160119017', 'Ketahanan Nasional', 'National Resillience', 'S3', 'Si.', 2, 'Dibuka', 1, '01', '0', '40', '516', 'SQ79')   -- Kepdirjen 96/2025 Lamp. I #563 (Dr tercentang)
  ) AS v (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
         jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id)
 WHERE NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m WHERE m.kode_prodi = v.kode_prodi)
   AND NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m
                    WHERE lower(trim(m.name_prodi)) = lower(v.name_prodi) AND m.program_id = v.program_id);

-- 3.4 Profesi: 4 baris. Sumber: Kepdirjen 96/2025 Lampiran II bagian I; profesi yang ada di UNESA
INSERT INTO public.ms_nomenklatur (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
       jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id,
       created_at, updated_at, deleted_at, id_updater, soft_delete, id_sms)
SELECT v.kode_prodi, v.name_prodi, v.name_prodi_eng, v.program_id, v.gelar, v.status_prodi_id, v.status_prodi,
       v.jenis_pendidikan_id, v.kode_sub_rumpun, v.is_kesehatan, v.id_jenj_didik, v.kode_rumpun, v.rumpun_id,
       now(), now(), NULL, NULL, '0', gen_random_uuid()::text
  FROM (VALUES
  ('5080617001', 'Pendidikan Profesi Bidan', 'Midwife Profession Education', 'Profesi', 'Bdn.', 2, 'Dibuka', 2, '06', '1', '25', '508', 'QI95'),  -- Kepdirjen 96/2025 Lamp. II bag. I no. 10; ada di UNESA
  ('5080217001', 'Pendidikan Profesi Dokter', 'Medical Doctor Profession Education', 'Profesi', 'dr.', 2, 'Dibuka', 2, '02', '1', '25', '508', 'PE84'),  -- Kepdirjen 96/2025 Lamp. II bag. I no. 12; ada di UNESA
  ('5080317001', 'Pendidikan Profesi Dokter Gigi', 'Dentist Profession Education', 'Profesi', 'drg.', 2, 'Dibuka', 2, '03', '1', '25', '508', 'PR29'),  -- Kepdirjen 96/2025 Lamp. II bag. I no. 13; ada di UNESA
  ('5080717001', 'Pendidikan Profesi Ners', 'Nurse Profession Education', 'Profesi', 'Ners.', 2, 'Dibuka', 2, '07', '1', '25', '508', 'QK58')   -- Kepdirjen 96/2025 Lamp. II bag. I no. 16; ada di UNESA
  ) AS v (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
         jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id)
 WHERE NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m WHERE m.kode_prodi = v.kode_prodi)
   AND NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m
                    WHERE lower(trim(m.name_prodi)) = lower(v.name_prodi) AND m.program_id = v.program_id);

-- 3.5 D3: 256 baris. Sumber: Kepdirjen Diksi 27/D/M/2022 Lampiran I (centang D.Tiga)
INSERT INTO public.ms_nomenklatur (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
       jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id,
       created_at, updated_at, deleted_at, id_updater, soft_delete, id_sms)
SELECT v.kode_prodi, v.name_prodi, v.name_prodi_eng, v.program_id, v.gelar, v.status_prodi_id, v.status_prodi,
       v.jenis_pendidikan_id, v.kode_sub_rumpun, v.is_kesehatan, v.id_jenj_didik, v.kode_rumpun, v.rumpun_id,
       now(), now(), NULL, NULL, '0', gen_random_uuid()::text
  FROM (VALUES
  ('1000425001', 'Fotografi', 'Photography', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 6, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425002', 'Kriya Batik', 'Batik Craft', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425003', 'Kriya Kain', 'Fabric Craft', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425004', 'Kriya Kayu', 'Wood Craft', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425005', 'Kriya Keramik', 'Ceramics Craft', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425006', 'Kriya Logam', 'Metal Craft', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425007', 'Kriya Tenun', 'Woven Craft', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425008', 'Musik', 'Music', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425009', 'Produksi Film dan Televisi', 'Film and Television Production', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425010', 'Seni Lukis', 'Painting', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425011', 'Seni Pertunjukan', 'Performing Arts', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425012', 'Seni Rupa', 'Visual Arts', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000425013', 'Teater Rakyat', 'Folk Art Theater', 'D3', 'Sn.', 2, 'Dibuka', 3, '04', '0', '22', '100', 'AO21'),  -- Diksi 27/2022 hlm. 8, kelompok 1 Seni, kolom D.Tiga tercentang
  ('1000225001', 'Bahasa Arab', 'Arabic Language', 'D3', 'Li.', 2, 'Dibuka', 3, '02', '0', '22', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom D.Tiga tercentang
  ('1000225002', 'Bahasa Bali', 'Bali Language', 'D3', 'Li.', 2, 'Dibuka', 3, '02', '0', '22', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom D.Tiga tercentang
  ('1000225003', 'Bahasa Belanda', 'Dutch Language', 'D3', 'Li.', 2, 'Dibuka', 3, '02', '0', '22', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom D.Tiga tercentang
  ('1000225004', 'Bahasa Indonesia', 'Indonesia Language', 'D3', 'Li.', 2, 'Dibuka', 3, '02', '0', '22', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom D.Tiga tercentang
  ('1000225005', 'Bahasa Inggris', 'English Language', 'D3', 'Li.', 2, 'Dibuka', 3, '02', '0', '22', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom D.Tiga tercentang
  ('1000225006', 'Bahasa Jawa', 'Java Language', 'D3', 'Li.', 2, 'Dibuka', 3, '02', '0', '22', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom D.Tiga tercentang
  ('1000225007', 'Bahasa Jepang', 'Japan Language', 'D3', 'Li.', 2, 'Dibuka', 3, '02', '0', '22', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom D.Tiga tercentang
  ('1000225008', 'Bahasa Jerman', 'German Language', 'D3', 'Li.', 2, 'Dibuka', 3, '02', '0', '22', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom D.Tiga tercentang
  ('1000225009', 'Bahasa Korea', 'Korea Language', 'D3', 'Li.', 2, 'Dibuka', 3, '02', '0', '22', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom D.Tiga tercentang
  ('1000225010', 'Bahasa Mandarin', 'China Language', 'D3', 'Li.', 2, 'Dibuka', 3, '02', '0', '22', '100', 'AF88'),  -- Diksi 27/2022 hlm. 9, kelompok 2 Linguistik, kolom D.Tiga tercentang
  ('1000225011', 'Bahasa Perancis', 'France Language', 'D3', 'Li.', 2, 'Dibuka', 3, '02', '0', '22', '100', 'AF88'),  -- Diksi 27/2022 hlm. 9, kelompok 2 Linguistik, kolom D.Tiga tercentang
  ('2000425001', 'Pembangunan Sosial', 'Social Development', 'D3', 'Sos.', 2, 'Dibuka', 3, '04', '0', '22', '200', 'BK35'),  -- Diksi 27/2022 hlm. 9, kelompok 3 Sosial, kolom D.Tiga tercentang
  ('2000425002', 'Sosiologi Pedesaan', 'Rural Sociology', 'D3', 'Sos.', 2, 'Dibuka', 3, '04', '0', '22', '200', 'BK35'),  -- Diksi 27/2022 hlm. 9, kelompok 3 Sosial, kolom D.Tiga tercentang
  ('3000725001', 'Analisis Kimia', 'Chemical Analysis', 'D3', 'Si.', 2, 'Dibuka', 3, '07', '0', '22', '300', 'FM10'),  -- Diksi 27/2022 hlm. 9, kelompok 6 Kimia, kolom D.Tiga tercentang
  ('3000725002', 'Pengolahan Limbah Industri Kimia', 'Chemical Industrial Waste Management', 'D3', 'Si.', 2, 'Dibuka', 3, '07', '0', '22', '300', 'FM10'),  -- Diksi 27/2022 hlm. 9, kelompok 6 Kimia, kolom D.Tiga tercentang
  ('3000725003', 'Penjaminan Mutu Industri Pangan', 'Food Industry Quality Assurance', 'D3', 'Si.', 2, 'Dibuka', 3, '07', '0', '22', '300', 'FM10'),  -- Diksi 27/2022 hlm. 9, kelompok 6 Kimia, kolom D.Tiga tercentang
  ('3000325001', 'Entomologi Permukiman', 'Urban Entomology', 'D3', 'Si.', 2, 'Dibuka', 3, '03', '0', '22', '300', 'CC22'),  -- Diksi 27/2022 hlm. 10, kelompok 7 Biologi, kolom D.Tiga tercentang
  ('4000125001', 'Perancangan Permainan', 'Game Design', 'D3', 'Kom.', 2, 'Dibuka', 3, '01', '0', '22', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom D.Tiga tercentang
  ('4000125002', 'Rekayasa Perangkat Lunak Aplikasi', 'Application Software Engineering', 'D3', 'Kom.', 2, 'Dibuka', 3, '01', '0', '22', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom D.Tiga tercentang
  ('4000125003', 'Sistem Informasi', 'Information Systems', 'D3', 'Kom.', 2, 'Dibuka', 3, '01', '0', '22', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom D.Tiga tercentang
  ('4000125004', 'Teknologi Informasi', 'Information Technology', 'D3', 'Kom.', 2, 'Dibuka', 3, '01', '0', '22', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom D.Tiga tercentang
  ('4000125005', 'Teknologi Komputer Grafis', 'Computer Graphics Technology', 'D3', 'Kom.', 2, 'Dibuka', 3, '01', '0', '22', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom D.Tiga tercentang
  ('4000125006', 'Teknologi Permainan', 'Game Technology', 'D3', 'Kom.', 2, 'Dibuka', 3, '01', '0', '22', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom D.Tiga tercentang
  ('4000325001', 'Asuransi Jiwa', 'Life Insurance', 'D3', 'Aktr.', 2, 'Dibuka', 3, '03', '0', '22', '400', 'GN60'),  -- Diksi 27/2022 hlm. 11, kelompok 9 Matematika, kolom D.Tiga tercentang
  ('4000325002', 'Asuransi Kerugian', 'Liability Insurance', 'D3', 'Aktr.', 2, 'Dibuka', 3, '03', '0', '22', '400', 'GN60'),  -- Diksi 27/2022 hlm. 11, kelompok 9 Matematika, kolom D.Tiga tercentang
  ('4000325003', 'Asuransi Kesehatan', 'Health Insurance', 'D3', 'Aktr.', 2, 'Dibuka', 3, '03', '0', '22', '400', 'GN60'),  -- Diksi 27/2022 hlm. 11, kelompok 9 Matematika, kolom D.Tiga tercentang
  ('4000325004', 'Statistika Bisnis', 'Business Statistics', 'D3', 'Stat.', 2, 'Dibuka', 3, '03', '0', '22', '400', 'GN60'),  -- Diksi 27/2022 hlm. 11, kelompok 9 Matematika, kolom D.Tiga tercentang
  ('4000325005', 'Statistika Terapan', 'Applied Statistics', 'D3', 'Stat.', 2, 'Dibuka', 3, '03', '0', '22', '400', 'GN60'),  -- Diksi 27/2022 hlm. 11, kelompok 9 Matematika, kolom D.Tiga tercentang
  ('5010225001', 'Agribisnis', 'Agribusiness', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225002', 'Budi Daya Kelapa Sawit', 'Palm Plantation', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225003', 'Budi Daya Pertanian Lahan Kering', 'Upland Farming', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225004', 'Budi Daya Tanaman Hortikultura', 'Horticulture Farming', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225005', 'Budi Daya Tanaman Pangan', 'Edible Plants Farming', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225006', 'Budi Daya Tanaman Perkebunan', 'Plantation Crop Farming', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225007', 'Pengelolaan Hasil Perkebunan', 'Plantation Crop Management', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225008', 'Pengelolaan Perkebunan Kelapa Sawit', 'Palm Plantation Management', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225009', 'Penyuluhan Kehutanan', 'Forestry Extension', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225010', 'Penyuluhan Perkebunan', 'Plantation Extension', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225011', 'Penyuluhan Pertanian', 'Agricultural Extension', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225012', 'Tata Air Pertanian', 'Agricultural Water Management', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225013', 'Teknologi Hasil Perkebunan', 'Plantation Crop Technology', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010225014', 'Teknologi Hasil Pertanian', 'Agricultural Crop Technology', 'D3', 'P.', 2, 'Dibuka', 3, '02', '0', '22', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom D.Tiga tercentang
  ('5010325001', 'Budi Daya Ternak', 'Livestock Breeding', 'D3', 'Pt.', 2, 'Dibuka', 3, '03', '0', '22', '501', 'HC98'),  -- Diksi 27/2022 hlm. 12, kelompok 11 Peternakan, kolom D.Tiga tercentang
  ('5010325002', 'Kesejahteraan Hewan', 'Animal Welfare', 'D3', 'Pt.', 2, 'Dibuka', 3, '03', '0', '22', '501', 'HC98'),  -- Diksi 27/2022 hlm. 12, kelompok 11 Peternakan, kolom D.Tiga tercentang
  ('5010325003', 'Nutrisi Ternak', 'Livestock Nutrition', 'D3', 'Pt.', 2, 'Dibuka', 3, '03', '0', '22', '501', 'HC98'),  -- Diksi 27/2022 hlm. 12, kelompok 11 Peternakan, kolom D.Tiga tercentang
  ('5010325004', 'Teknologi Pengolahan Hasil Ternak', 'livestock Product Processing Technology', 'D3', 'Pt.', 2, 'Dibuka', 3, '03', '0', '22', '501', 'HC98'),  -- Diksi 27/2022 hlm. 13, kelompok 11 Peternakan, kolom D.Tiga tercentang
  ('5010325005', 'Usaha Budi Daya Ternak', 'livestock Breeding Business', 'D3', 'Pt.', 2, 'Dibuka', 3, '03', '0', '22', '501', 'HC98'),  -- Diksi 27/2022 hlm. 13, kelompok 11 Peternakan, kolom D.Tiga tercentang
  ('5010325006', 'Usaha Budi Daya Unggas', 'Poultry Production Business', 'D3', 'Pt.', 2, 'Dibuka', 3, '03', '0', '22', '501', 'HC98'),  -- Diksi 27/2022 hlm. 13, kelompok 11 Peternakan, kolom D.Tiga tercentang
  ('5010125001', 'Budi Daya Ikan', 'Fish Farming', 'D3', 'Pi.', 2, 'Dibuka', 3, '01', '0', '22', '501', 'GV92'),  -- Diksi 27/2022 hlm. 13, kelompok 12 Ilmu atau Sains Perikanan, kolom D.Tiga tercentang
  ('5010125002', 'Pembenihan Ikan', 'Fish Hatchery', 'D3', 'Pi.', 2, 'Dibuka', 3, '01', '0', '22', '501', 'GV92'),  -- Diksi 27/2022 hlm. 13, kelompok 12 Ilmu atau Sains Perikanan, kolom D.Tiga tercentang
  ('5010125003', 'Pengolahan Hasil Laut atau Hasil Perikanan', 'Marine or Fisheries Product Processing', 'D3', 'Pi.', 2, 'Dibuka', 3, '01', '0', '22', '501', 'GV92'),  -- Diksi 27/2022 hlm. 13, kelompok 12 Ilmu atau Sains Perikanan, kolom D.Tiga tercentang
  ('5010125004', 'Perikanan Tangkap', 'Capture Fisheries', 'D3', 'Pi.', 2, 'Dibuka', 3, '01', '0', '22', '501', 'GV92'),  -- Diksi 27/2022 hlm. 14, kelompok 12 Ilmu atau Sains Perikanan, kolom D.Tiga tercentang
  ('5010125005', 'Usaha Budi Daya Ikan', 'Fish Farming Business', 'D3', 'Pi.', 2, 'Dibuka', 3, '01', '0', '22', '501', 'GV92'),  -- Diksi 27/2022 hlm. 14, kelompok 12 Ilmu atau Sains Perikanan, kolom D.Tiga tercentang
  ('5020125001', 'Gambar Arsitektur', 'Architectural Drafting', 'D3', 'Ars.', 2, 'Dibuka', 3, '01', '0', '22', '502', 'IP90'),  -- Diksi 27/2022 hlm. 14, kelompok 13 Arsitektur, kolom D.Tiga tercentang
  ('5020125002', 'Pertamanan', 'Landscape Management', 'D3', 'Arl.', 2, 'Dibuka', 3, '01', '0', '22', '502', 'IP90'),  -- Diksi 27/2022 hlm. 14, kelompok 13 Arsitektur, kolom D.Tiga tercentang
  ('5020225001', 'Desain Busana', 'Apparel Design', 'D3', 'Ds.', 2, 'Dibuka', 3, '02', '0', '22', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom D.Tiga tercentang
  ('5020225002', 'Desain Grafis', 'Graphic design', 'D3', 'Ds.', 2, 'Dibuka', 3, '02', '0', '22', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom D.Tiga tercentang
  ('5020225003', 'Desain Interior', 'Interior design', 'D3', 'Ds.', 2, 'Dibuka', 3, '02', '0', '22', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom D.Tiga tercentang
  ('5020225004', 'Desain Komunikasi Visual', 'Visual Communication Design', 'D3', 'Ds.', 2, 'Dibuka', 3, '02', '0', '22', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom D.Tiga tercentang
  ('5020225005', 'Desain Produk', 'Product Design', 'D3', 'Ds.', 2, 'Dibuka', 3, '02', '0', '22', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom D.Tiga tercentang
  ('5020225006', 'Desain Tekstil', 'Textile design', 'D3', 'Ds.', 2, 'Dibuka', 3, '02', '0', '22', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom D.Tiga tercentang
  ('5020225007', 'Multimedia', 'Multimedia', 'D3', 'Ds.', 2, 'Dibuka', 3, '02', '0', '22', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom D.Tiga tercentang
  ('5020225008', 'Teknologi Cetak', 'Printing Technology', 'D3', 'Ds.', 2, 'Dibuka', 3, '02', '0', '22', '502', 'JG29'),  -- Diksi 27/2022 hlm. 15, kelompok 14 Desain, kolom D.Tiga tercentang
  ('5030325001', 'Akuntansi', 'Accounting', 'D3', 'Ak.', 2, 'Dibuka', 3, '03', '0', '22', '503', 'KX47'),  -- Diksi 27/2022 hlm. 15, kelompok 15 Akuntansi, kolom D.Tiga tercentang
  ('5030425001', 'Administrasi Perpajakan', 'Tax Administration', 'D3', 'M.', 2, 'Dibuka', 3, '04', '0', '22', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom D.Tiga tercentang
  ('5030425002', 'Manajemen', 'Management', 'D3', 'M.', 2, 'Dibuka', 3, '04', '0', '22', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom D.Tiga tercentang
  ('5030425003', 'Manajemen Aset', 'Asset Management', 'D3', 'M.', 2, 'Dibuka', 3, '04', '0', '22', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom D.Tiga tercentang
  ('5030425004', 'Manajemen Industri', 'Industrial Management', 'D3', 'M.', 2, 'Dibuka', 3, '04', '0', '22', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom D.Tiga tercentang
  ('5030425005', 'Manajemen Keuangan', 'Financial Management', 'D3', 'M.', 2, 'Dibuka', 3, '04', '0', '22', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom D.Tiga tercentang
  ('5030425006', 'Manajemen Pajak', 'Tax Management', 'D3', 'M.', 2, 'Dibuka', 3, '04', '0', '22', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom D.Tiga tercentang
  ('5030425007', 'Manajemen Pemasaran', 'Marketing Management', 'D3', 'M.', 2, 'Dibuka', 3, '04', '0', '22', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom D.Tiga tercentang
  ('5030425008', 'Manajemen Pemasaran Industri Elektronika', 'Marketing Management in Electronic Industry', 'D3', 'M.', 2, 'Dibuka', 3, '04', '0', '22', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom D.Tiga tercentang
  ('5030425009', 'Manajemen Sumber Daya Manusia', 'Human Resources Management', 'D3', 'M.', 2, 'Dibuka', 3, '04', '0', '22', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom D.Tiga tercentang
  ('5030425010', 'Perbankan dan Keuangan', 'Banking and Finance', 'D3', 'M.', 2, 'Dibuka', 3, '04', '0', '22', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom D.Tiga tercentang
  ('5030525001', 'Logistik Pembekalan', 'Supplies Logistics', 'D3', 'Log.', 2, 'Dibuka', 3, '05', '0', '22', '503', 'LP65'),  -- Diksi 27/2022 hlm. 16, kelompok 17 Logistik, kolom D.Tiga tercentang
  ('5030525002', 'Manajemen Logistik', 'Logistics Management', 'D3', 'Log.', 2, 'Dibuka', 3, '05', '0', '22', '503', 'LP65'),  -- Diksi 27/2022 hlm. 16, kelompok 17 Logistik, kolom D.Tiga tercentang
  ('5030525003', 'Manajemen Logistik Industri Agro', 'Agro Industry Logistics Management', 'D3', 'Log.', 2, 'Dibuka', 3, '05', '0', '22', '503', 'LP65'),  -- Diksi 27/2022 hlm. 16, kelompok 17 Logistik, kolom D.Tiga tercentang
  ('5030525004', 'Manajemen Logistik Industri Elektronika', 'Electronic Industry Logistics Management', 'D3', 'Log.', 2, 'Dibuka', 3, '05', '0', '22', '503', 'LP65'),  -- Diksi 27/2022 hlm. 16, kelompok 17 Logistik, kolom D.Tiga tercentang
  ('5030525005', 'Manajemen Logistik Transportasi Udara', 'Air Transportation Logistics', 'D3', 'Log.', 2, 'Dibuka', 3, '05', '0', '22', '503', 'LP65'),  -- Diksi 27/2022 hlm. 16, kelompok 17 Logistik, kolom D.Tiga tercentang
  ('5030125001', 'Administrasi Bisnis', 'Business Administration', 'D3', 'A.B.', 2, 'Dibuka', 3, '01', '0', '22', '503', 'KQ12'),  -- Diksi 27/2022 hlm. 16, kelompok 18 Administrasi Bisnis, kolom D.Tiga tercentang
  ('5030125002', 'Administrasi Perkantoran', 'Office Administration', 'D3', 'A.B.', 2, 'Dibuka', 3, '01', '0', '22', '503', 'KQ12'),  -- Diksi 27/2022 hlm. 16, kelompok 18 Administrasi Bisnis, kolom D.Tiga tercentang
  ('5030125003', 'Administrasi Perkantoran Keimigrasian', 'Immigration Office Administration', 'D3', 'A.B.', 2, 'Dibuka', 3, '01', '0', '22', '503', 'KQ12'),  -- Diksi 27/2022 hlm. 16, kelompok 18 Administrasi Bisnis, kolom D.Tiga tercentang
  ('5030225001', 'Bisnis Internasional', 'International Business', 'D3', 'Bns.', 2, 'Dibuka', 3, '02', '0', '22', '503', 'KV17'),  -- Diksi 27/2022 hlm. 16, kelompok 19 Bisnis, kolom D.Tiga tercentang
  ('5030225002', 'Koperasi', 'Co-operation', 'D3', 'Bns.', 2, 'Dibuka', 3, '02', '0', '22', '503', 'KV17'),  -- Diksi 27/2022 hlm. 16, kelompok 19 Bisnis, kolom D.Tiga tercentang
  ('5030225003', 'Perdagangan Internasional', 'International Trade', 'D3', 'Bns.', 2, 'Dibuka', 3, '02', '0', '22', '503', 'KV17'),  -- Diksi 27/2022 hlm. 17, kelompok 19 Bisnis, kolom D.Tiga tercentang
  ('5030225004', 'Perdagangan Internasional Wilayah ASEAN dan RRT', 'International Trade on ASEAN and China', 'D3', 'Bns.', 2, 'Dibuka', 3, '02', '0', '22', '503', 'KV17'),  -- Diksi 27/2022 hlm. 17, kelompok 19 Bisnis, kolom D.Tiga tercentang
  ('5030225005', 'Perdagangan Mode', 'Fashion Trade', 'D3', 'Bns.', 2, 'Dibuka', 3, '02', '0', '22', '503', 'KV17'),  -- Diksi 27/2022 hlm. 17, kelompok 19 Bisnis, kolom D.Tiga tercentang
  ('5030225006', 'Perdagangan Tekstil', 'Textile Trade', 'D3', 'Bns.', 2, 'Dibuka', 3, '02', '0', '22', '503', 'KV17'),  -- Diksi 27/2022 hlm. 17, kelompok 19 Bisnis, kolom D.Tiga tercentang
  ('5030225007', 'Tata Rias', 'Cosmetology', 'D3', 'Bns.', 2, 'Dibuka', 3, '02', '0', '22', '503', 'KV17'),  -- Diksi 27/2022 hlm. 17, kelompok 19 Bisnis, kolom D.Tiga tercentang
  ('5030225008', 'Teknologi Pengolahan Produk Kulit', 'Leather Product Processing Technology', 'D3', 'Bns.', 2, 'Dibuka', 3, '02', '0', '22', '503', 'KV17'),  -- Diksi 27/2022 hlm. 17, kelompok 19 Bisnis, kolom D.Tiga tercentang
  ('5040125001', 'Hubungan Masyarakat', 'Public Relations', 'D3', 'I.Kom.', 2, 'Dibuka', 3, '01', '0', '22', '504', 'MO24'),  -- Diksi 27/2022 hlm. 17, kelompok 20 Ilmu atau Sains Komunikasi, kolom D.Tiga tercentang
  ('5040125002', 'Jurnalistik', 'Journalism', 'D3', 'I.Kom.', 2, 'Dibuka', 3, '01', '0', '22', '504', 'MO24'),  -- Diksi 27/2022 hlm. 17, kelompok 20 Ilmu atau Sains Komunikasi, kolom D.Tiga tercentang
  ('5040125003', 'Komunikasi Massa', 'Mass communication', 'D3', 'I.Kom.', 2, 'Dibuka', 3, '01', '0', '22', '504', 'MO24'),  -- Diksi 27/2022 hlm. 17, kelompok 20 Ilmu atau Sains Komunikasi, kolom D.Tiga tercentang
  ('5040125004', 'Penerbitan', 'Publishing', 'D3', 'I.Kom.', 2, 'Dibuka', 3, '01', '0', '22', '504', 'MO24'),  -- Diksi 27/2022 hlm. 17, kelompok 20 Ilmu atau Sains Komunikasi, kolom D.Tiga tercentang
  ('5040125005', 'Penyiaran', 'Broadcast journalism', 'D3', 'I.Kom.', 2, 'Dibuka', 3, '01', '0', '22', '504', 'MO24'),  -- Diksi 27/2022 hlm. 17, kelompok 20 Ilmu atau Sains Komunikasi, kolom D.Tiga tercentang
  ('5040125006', 'Periklanan', 'Advertising', 'D3', 'I.Kom.', 2, 'Dibuka', 3, '01', '0', '22', '504', 'MO24'),  -- Diksi 27/2022 hlm. 17, kelompok 20 Ilmu atau Sains Komunikasi, kolom D.Tiga tercentang
  ('5060125001', 'Teknologi Elektro-medis', 'Medical Electronics Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 17, kelompok 21 Rekayasa (Rekayasa Biomedis), kolom D.Tiga tercentang
  ('5060125002', 'Teknologi Mekanisasi Pertanian', 'Agricultural Mechanization Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Biosistem), kolom D.Tiga tercentang
  ('5060125003', 'Teknologi Rekayasa Mesin Pertanian', 'Agricultural Mechanical Engineering Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Biosistem), kolom D.Tiga tercentang
  ('5060125004', 'Aeronautika', 'Aeronautics', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom D.Tiga tercentang
  ('5060125005', 'Motor Pesawat', 'Aerospace Engine', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom D.Tiga tercentang
  ('5060125006', 'Sistem Elektronika Pesawat', 'Avionics System', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom D.Tiga tercentang
  ('5060125007', 'Teknologi Bandar Udara', 'Airport Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom D.Tiga tercentang
  ('5060125008', 'Teknologi Navigasi Udara', 'Air Navigation Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom D.Tiga tercentang
  ('5060125009', 'Teknologi Pemeliharaan Pesawat Udara', 'Aircraft Maintenance Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom D.Tiga tercentang
  ('5060125010', 'Teknologi Sistem Kedirgantaraan', 'Aerospace Systems Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom D.Tiga tercentang
  ('5060125011', 'Teknologi Elektro Perkeretaapian', 'Railways Electrical Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Elektro), kolom D.Tiga tercentang
  ('5060125012', 'Teknologi Elektronika', 'Electronics Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Elektro), kolom D.Tiga tercentang
  ('5060125013', 'Teknologi Listrik', 'Electrical Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Elektro), kolom D.Tiga tercentang
  ('5060125014', 'Teknologi Listrik Industri Logam', 'Electrical Technology in Metal Industry', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Elektro), kolom D.Tiga tercentang
  ('5060125015', 'Teknologi Otomasi', 'Automation Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Elektro), kolom D.Tiga tercentang
  ('5060125016', 'Intrumentasi dan Metrologi', 'Instrumentation and Metrology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Fisika), kolom D.Tiga tercentang
  ('5060125017', 'Teknologi Instrumentasi', 'Instrumentation Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Fisika), kolom D.Tiga tercentang
  ('5060125018', 'Teknologi Instrumentasi Industri Petrokimia', 'Instrumentation Technology in Petrochemical Industry', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Fisika), kolom D.Tiga tercentang
  ('5060125019', 'Survei dan Pemetaan', 'Surveying and Mapping', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Geomatika), kolom D.Tiga tercentang
  ('5060125020', 'Teknologi Geomatika', 'Geomatics Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Geomatika), kolom D.Tiga tercentang
  ('5060125021', 'Teknologi Penginderaan Jauh', 'Remote Sensing Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Geomatika), kolom D.Tiga tercentang
  ('5060125022', 'Teknologi Geologi', 'Geological Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Geologi), kolom D.Tiga tercentang
  ('5060125023', 'Teknologi Industri', 'Industrial Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Industri), kolom D.Tiga tercentang
  ('5060125024', 'Agroindustri', 'Agroindustry', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Industri Pertanian), kolom D.Tiga tercentang
  ('5060125025', 'Teknologi Kimia', 'Chemical Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom D.Tiga tercentang
  ('5060125026', 'Teknologi Kimia Bahan Nabati', 'Phytochemistry Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom D.Tiga tercentang
  ('5060125027', 'Teknologi Manufaktur Industri Agro', 'Agroindustrial Manufacturing Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom D.Tiga tercentang
  ('5060125028', 'Teknologi Mineral', 'Mineral Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom D.Tiga tercentang
  ('5060125029', 'Teknologi Pengolahan Gula', 'Sugar Process Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom D.Tiga tercentang
  ('5060125030', 'Teknologi Pengolahan Kelapa Sawit', 'Palm Process Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom D.Tiga tercentang
  ('5060125031', 'Teknologi Pengolahan Minyak dan Gas', 'Oil and Gas Refining Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom D.Tiga tercentang
  ('5060125032', 'Teknologi Pengolahan Minyak Kelapa Sawit', 'Palm Oil Process Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom D.Tiga tercentang
  ('5060125033', 'Teknologi Proses Industri Petrokimia', 'Process Technology in Petrochemical Industry', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom D.Tiga tercentang
  ('5060125034', 'Teknologi Pulp dan Kertas', 'Pulp and Paper Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom D.Tiga tercentang
  ('5060125035', 'Teknologi Komputer', 'Computer Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Komputer), kolom D.Tiga tercentang
  ('5060125036', 'Teknologi Lingkungan', 'Environmental Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Lingkungan), kolom D.Tiga tercentang
  ('5060125037', 'Teknologi Metalurgi', 'Metallurgical Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Material), kolom D.Tiga tercentang
  ('5060125038', 'Teknologi Metalurgi Industri Logam', 'Metal Industry Metallurgy Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Material), kolom D.Tiga tercentang
  ('5060125039', 'Teknologi Pengecoran Logam', 'Metal Foundry Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Material), kolom D.Tiga tercentang
  ('5060125040', 'Teknologi Pengelasan Logam', 'Metal Welding Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Material), kolom D.Tiga tercentang
  ('5060125041', 'Teknologi Pengolahan Karet dan Plastik', 'Rubber and Plastic Processing Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Material), kolom D.Tiga tercentang
  ('5060125042', 'Teknologi Pengolahan Kulit', 'Leather Processing Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Material), kolom D.Tiga tercentang
  ('5060125043', 'Pemeliharaan Mesin', 'Mechanical Maintenance', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 23, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125044', 'Pemeliharaan Mesin Otomotif', 'Automotive Maintenance Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 23, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125045', 'Mekatronika', 'Mechatronics', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 23, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125046', 'Otomasi Sistem Permesinan', 'Automated Mechanical System', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 23, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125047', 'Pemeliharaan Alat Berat', 'Heavy Equipment Maintenance', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 23, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125048', 'Pemeliharaan Mesin Industri Logam', 'Metal Industry Mechanical Maintenance', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 23, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125049', 'Teknologi Alat Berat', 'Heavy Equipment Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125050', 'Teknologi Konversi Energi', 'Energy Conversion Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125051', 'Teknologi Manufaktur', 'Manufacturing Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125052', 'Teknologi Manufaktur Elektronik', 'Electronics Manufacturing Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125053', 'Teknologi Mekanika Otomotif', 'Automotive Mechanical Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125054', 'Teknologi Mekanika Perkeretaapian', 'Railways Mechanical Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125055', 'Teknologi Mesin', 'Mechanical Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125056', 'Teknologi Mesin Industri Petrokimia', 'Mechanical Technology in Petrochemical Industry', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125057', 'Teknologi Otomotif', 'Automotive Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125058', 'Teknologi Pembuatan Mesin Perkakas', 'Mechanical Tools Manufacturing Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125059', 'Teknologi Pembuatan Perkakas Presisi', 'Precision Tools Manufacturing Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125060', 'Teknologi Pendingin dan Tata Udara', 'Refrigeration and Air-Conditioning Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125061', 'Teknologi Perancangan Mekanik', 'Mechanical Design Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125062', 'Teknologi Perancangan Mesin Perkakas', 'Mechanical Tools Design Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125063', 'Teknologi Perancangan Perkakas Presisi', 'Precision Tools Design Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom D.Tiga tercentang
  ('5060125064', 'Teknologi Perminyakan', 'Petroleum Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 25, kelompok 21 Rekayasa (Rekayasa Perminyakan), kolom D.Tiga tercentang
  ('5060125065', 'Teknologi Eksplorasi Minyak dan Gas', 'Oil and Gas Drilling Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 25, kelompok 21 Rekayasa (Rekayasa Pertambangan), kolom D.Tiga tercentang
  ('5060125066', 'Teknologi Pertambangan', 'Mining Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 25, kelompok 21 Rekayasa (Rekayasa Pertambangan), kolom D.Tiga tercentang
  ('5060125067', 'Teknologi Pertambangan Batubara', 'Coal Mining Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 25, kelompok 21 Rekayasa (Rekayasa Pertambangan), kolom D.Tiga tercentang
  ('5060125068', 'Teknologi Pertambangan Mineral', 'Mineral Mining Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 25, kelompok 21 Rekayasa (Rekayasa Pertambangan), kolom D.Tiga tercentang
  ('5060125069', 'Teknologi Bangunan dan Jalur Perkeretaapian', 'Construction and Railways Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom D.Tiga tercentang
  ('5060125070', 'Teknologi Konstruksi Bangunan Air', 'Waterworks Construction Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom D.Tiga tercentang
  ('5060125071', 'Teknologi Konstruksi Bangunan Gedung', 'Building Construction Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom D.Tiga tercentang
  ('5060125072', 'Teknologi Konstruksi Jalan dan Jembatan', 'Road and Bridge Construction Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom D.Tiga tercentang
  ('5060125073', 'Teknologi Sipil', 'Civil Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom D.Tiga tercentang
  ('5060125074', 'Teknologi Telekomunikasi', 'Telecommunications Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Telekomunikasi), kolom D.Tiga tercentang
  ('5060125075', 'Teknologi Kelautan', 'Marine Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Kelautan), kolom D.Tiga tercentang
  ('5060125076', 'Permesinan Kapal', 'Ship Machinery', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Sistem Perkapalan), kolom D.Tiga tercentang
  ('5060125077', 'Sistem Kelistrikan Kapal', 'Ship Electrical System', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Sistem Perkapalan), kolom D.Tiga tercentang
  ('5060125078', 'Teknologi Konstruksi Bangunan Kapal', 'Ship Construction Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Sistem Perkapalan), kolom D.Tiga tercentang
  ('5060125079', 'Teknologi Perancangan dan Konstruksi Kapal', 'Ship Design and Construction Technology', 'D3', 'T.', 2, 'Dibuka', 3, '01', '0', '22', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Sistem Perkapalan), kolom D.Tiga tercentang
  ('5070125001', 'Pengelolaan Lingkungan', 'Environmental Management', 'D3', 'Ling.', 2, 'Dibuka', 3, '01', '0', '22', '507', 'NU66'),  -- Diksi 27/2022 hlm. 27, kelompok 22 Ilmu Lingkungan, kolom D.Tiga tercentang
  ('5070125002', 'Pengelolaan Sumber Daya Lahan', 'Land Resource Management', 'D3', 'Ling.', 2, 'Dibuka', 3, '01', '0', '22', '507', 'NU66'),  -- Diksi 27/2022 hlm. 27, kelompok 22 Ilmu Lingkungan, kolom D.Tiga tercentang
  ('5070225001', 'Budi Daya Tanaman Hutan', 'Forest Plantation', 'D3', 'Hut.', 2, 'Dibuka', 3, '02', '0', '22', '507', 'NY14'),  -- Diksi 27/2022 hlm. 28, kelompok 23 Kehutanan, kolom D.Tiga tercentang
  ('5070225002', 'Pengelolaan Hasil Hutan', 'Forestry Product Management', 'D3', 'Hut.', 2, 'Dibuka', 3, '02', '0', '22', '507', 'NY14'),  -- Diksi 27/2022 hlm. 28, kelompok 23 Kehutanan, kolom D.Tiga tercentang
  ('5070225003', 'Pengelolaan Hutan', 'Forestry Management', 'D3', 'Hut.', 2, 'Dibuka', 3, '02', '0', '22', '507', 'NY14'),  -- Diksi 27/2022 hlm. 28, kelompok 23 Kehutanan, kolom D.Tiga tercentang
  ('5070225004', 'Pengelolaan Hutan Alam Produksi', 'Natural Forest Production Management', 'D3', 'Hut.', 2, 'Dibuka', 3, '02', '0', '22', '507', 'NY14'),  -- Diksi 27/2022 hlm. 28, kelompok 23 Kehutanan, kolom D.Tiga tercentang
  ('5070225005', 'Pengolahan Hasil Hutan', 'Forest Product Processing Technology', 'D3', 'Hut.', 2, 'Dibuka', 3, '02', '0', '22', '507', 'NY14'),  -- Diksi 27/2022 hlm. 28, kelompok 23 Kehutanan, kolom D.Tiga tercentang
  ('5070225006', 'Teknologi Produk Kayu', 'Wood Product Technology', 'D3', 'Hut.', 2, 'Dibuka', 3, '02', '0', '22', '507', 'NY14'),  -- Diksi 27/2022 hlm. 28, kelompok 23 Kehutanan, kolom D.Tiga tercentang
  ('5080225001', 'Akupuntur', 'Acupuncture', 'D3', 'Akup.', 2, 'Dibuka', 3, '02', '1', '22', '508', 'PE84'),  -- Diksi 27/2022 hlm. 28, kelompok 24 Ilmu atau Sains Kedokteran, kolom D.Tiga tercentang
  ('5080425001', 'Kesehatan Masyarakat Veteriner', 'Veterinary Public Health', 'D3', 'Vet.', 2, 'Dibuka', 3, '04', '1', '22', '508', 'PR79'),  -- Diksi 27/2022 hlm. 28, kelompok 25 Ilmu atau Sains Veteriner, kolom D.Tiga tercentang
  ('5080425002', 'Kesehatan Hewan', 'Animal Health', 'D3', 'Vet.', 2, 'Dibuka', 3, '04', '1', '22', '508', 'PR79'),  -- Diksi 27/2022 hlm. 28, kelompok 25 Ilmu atau Sains Veteriner, kolom D.Tiga tercentang
  ('5080525001', 'Farmasi', 'Pharmacy', 'D3', 'Farm.', 2, 'Dibuka', 3, '05', '1', '22', '508', 'PS16'),  -- Diksi 27/2022 hlm. 28, kelompok 26 Ilmu atau Sains Farmasi, kolom D.Tiga tercentang
  ('5080125001', 'Gizi', 'Nutrition', 'D3', 'Gz.', 2, 'Dibuka', 3, '01', '1', '22', '508', 'NZ82'),  -- Diksi 27/2022 hlm. 28, kelompok 27 Ilmu atau Sains Gizi, kolom D.Tiga tercentang
  ('5080925001', 'Pengawasan Epidemiologi', 'Epidemiologic Surveillance', 'D3', 'K.M.', 2, 'Dibuka', 3, '09', '1', '22', '508', 'QO39'),  -- Diksi 27/2022 hlm. 28, kelompok 28 Kesehatan Masyarakat, kolom D.Tiga tercentang
  ('5080625001', 'Kebidanan', 'Midwifery', 'D3', 'Keb.', 2, 'Dibuka', 3, '06', '1', '22', '508', 'QI95'),  -- Diksi 27/2022 hlm. 28, kelompok 29 Kebidanan, kolom D.Tiga tercentang
  ('5080725001', 'Keperawatan', 'Nursing', 'D3', 'Kep.', 2, 'Dibuka', 3, '07', '1', '22', '508', 'QK58'),  -- Diksi 27/2022 hlm. 28, kelompok 30 Keperawatan, kolom D.Tiga tercentang
  ('5080825001', 'Administrasi Layanan Kesehatan', 'Healthcare Administration', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825002', 'Administrasi Rumah Sakit', 'Hospital Administration', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825003', 'Analisis Farmasi dan Makanan', 'Food and Pharmaceutical Analyses', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825004', 'Audiologi', 'Audiology', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825005', 'Fisioterapi', 'Physiotherapy', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825006', 'Jamu', 'Indonesia Traditional Herbals', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825007', 'Kesehatan Gigi', 'Dental Hygiene', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825008', 'Optometri', 'Optometry', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825009', 'Ortotik dan Prostetik', 'Orthotics and Prosthetics', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825010', 'Pengobatan Tradisional', 'Traditional Medicine', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825011', 'Pengobatan Tradisional Tiongkok', 'China Traditional Medicine', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825012', 'Radiologi', 'Radiology', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825013', 'Rekam Medis dan Informasi Kesehatan', 'Medical Records and Health information', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825014', 'Sanitasi', 'Sanitation', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825015', 'Teknologi Bank Darah', 'Blood Bank Technology', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825016', 'Teknologi Gigi', 'Dental Technology', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825017', 'Teknologi Kardiovaskular', 'Cardiovascular Technology', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825018', 'Teknologi Laboratorium Medis', 'Medical Laboratory Technology', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 30, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825019', 'Terapi Okupasi', 'Occupational Therapy', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 30, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5080825020', 'Terapi Wicara', 'Speech Therapy', 'D3', 'Kes.', 2, 'Dibuka', 3, '08', '1', '22', '508', 'QL11'),  -- Diksi 27/2022 hlm. 30, kelompok 31 Ilmu atau Sains Kesehatan, kolom D.Tiga tercentang
  ('5090125001', 'Kearsipan', 'Archival Science', 'D3', 'S.I.', 2, 'Dibuka', 3, '01', '0', '22', '509', 'RE16'),  -- Diksi 27/2022 hlm. 30, kelompok 32 Ilmu atau Sains Informasi, kolom D.Tiga tercentang
  ('5090125002', 'Perpustakaan', 'Library', 'D3', 'S.I.', 2, 'Dibuka', 3, '01', '0', '22', '509', 'RE16'),  -- Diksi 27/2022 hlm. 30, kelompok 32 Ilmu atau Sains Informasi, kolom D.Tiga tercentang
  ('5100125001', 'Paralegal', 'Paralegal', 'D3', 'H.', 2, 'Dibuka', 3, '01', '0', '22', '510', 'RK96'),  -- Diksi 27/2022 hlm. 30, kelompok 33 Hukum, kolom D.Tiga tercentang
  ('5120125001', 'Administrasi Publik', 'Public Administration', 'D3', 'A.P.', 2, 'Dibuka', 3, '01', '0', '22', '512', 'RO36'),  -- Diksi 27/2022 hlm. 30, kelompok 35 Urusan Publik, kolom D.Tiga tercentang
  ('5130125001', 'Kepelatihan Olahraga', 'Sport Coaching', 'D3', 'O.R.', 2, 'Dibuka', 3, '01', '0', '22', '513', 'RW74'),  -- Diksi 27/2022 hlm. 31, kelompok 36 Ilmu atau Sains Keolahragaan, kolom D.Tiga tercentang
  ('5130125002', 'Pencak Silat', 'Pencak Silat', 'D3', 'O.R.', 2, 'Dibuka', 3, '01', '0', '22', '513', 'RW74'),  -- Diksi 27/2022 hlm. 31, kelompok 36 Ilmu atau Sains Keolahragaan, kolom D.Tiga tercentang
  ('5140125001', 'Divisi Kamar', 'Rooms Division', 'D3', 'Par.', 2, 'Dibuka', 3, '01', '0', '22', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom D.Tiga tercentang
  ('5140125002', 'Ekowisata', 'Ecotourism', 'D3', 'Par.', 2, 'Dibuka', 3, '01', '0', '22', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom D.Tiga tercentang
  ('5140125003', 'Ekowisata Laut', 'Marine Ecotourism', 'D3', 'Par.', 2, 'Dibuka', 3, '01', '0', '22', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom D.Tiga tercentang
  ('5140125004', 'Perhotelan', 'Hotel Operations', 'D3', 'Par.', 2, 'Dibuka', 3, '01', '0', '22', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom D.Tiga tercentang
  ('5140125005', 'Perjalanan Wisata', 'Tour and Travel Operations', 'D3', 'Par.', 2, 'Dibuka', 3, '01', '0', '22', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom D.Tiga tercentang
  ('5140125006', 'Seni Kuliner', 'Culinary Arts', 'D3', 'Par.', 2, 'Dibuka', 3, '01', '0', '22', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom D.Tiga tercentang
  ('5140125007', 'Seni Pengolahan Patiseri', 'Baking and Pastry Arts', 'D3', 'Par.', 2, 'Dibuka', 3, '01', '0', '22', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom D.Tiga tercentang
  ('5140125008', 'Tata Hidang', 'Food and Beverage Service', 'D3', 'Par.', 2, 'Dibuka', 3, '01', '0', '22', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom D.Tiga tercentang
  ('5150125001', 'Manajemen Bandar Udara', 'Airport Management', 'D3', 'Tra.', 2, 'Dibuka', 3, '01', '0', '22', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom D.Tiga tercentang
  ('5150125002', 'Manajemen Lalu Lintas Udara', 'Air Traffic Management', 'D3', 'Tra.', 2, 'Dibuka', 3, '01', '0', '22', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom D.Tiga tercentang
  ('5150125003', 'Manajemen Pelabuhan', 'Port Management', 'D3', 'Tra.', 2, 'Dibuka', 3, '01', '0', '22', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom D.Tiga tercentang
  ('5150125004', 'Manajemen Transportasi Jalan', 'Road Transportation Management', 'D3', 'Tra.', 2, 'Dibuka', 3, '01', '0', '22', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom D.Tiga tercentang
  ('5150125005', 'Manajemen Transportasi Laut', 'Marine Transportation Management', 'D3', 'Tra.', 2, 'Dibuka', 3, '01', '0', '22', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom D.Tiga tercentang
  ('5150125006', 'Manajemen Transportasi Perairan Daratan', 'In-land Water Transportation Management', 'D3', 'Tra.', 2, 'Dibuka', 3, '01', '0', '22', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom D.Tiga tercentang
  ('5150125007', 'Manajemen Transportasi Perkeretaapian', 'Railways Transportation Management', 'D3', 'Tra.', 2, 'Dibuka', 3, '01', '0', '22', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom D.Tiga tercentang
  ('5150125008', 'Manajemen Transportasi Udara', 'Air Transportation Management', 'D3', 'Tra.', 2, 'Dibuka', 3, '01', '0', '22', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom D.Tiga tercentang
  ('5150125009', 'Penyelamatan dan Pemadam Kebakaran Penerbangan', 'Aviation Fire & Rescue', 'D3', 'Tra.', 2, 'Dibuka', 3, '01', '0', '22', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom D.Tiga tercentang
  ('5150125010', 'Studi Aviasi', 'Aviation Studies', 'D3', 'Tra.', 2, 'Dibuka', 3, '01', '0', '22', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom D.Tiga tercentang
  ('5150125011', 'Studi Nautika', 'Nautical Studies', 'D3', 'Tra.', 2, 'Dibuka', 3, '01', '0', '22', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom D.Tiga tercentang
  ('5160125001', 'Konservasi Sumber Daya Hutan', 'Forest Resources Conservation', 'D3', 'Ksv.', 2, 'Dibuka', 3, '01', '0', '22', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom D.Tiga tercentang
  ('5160125002', 'Penanganan Krisis Kebencanaan', 'Crisis Management on Disaster', 'D3', 'M.B.', 2, 'Dibuka', 3, '01', '0', '22', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom D.Tiga tercentang
  ('5160125003', 'Sistem Informasi Akuntansi', 'Information System in Accounting', 'D3', 'S.I.Ak.', 2, 'Dibuka', 3, '01', '0', '22', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom D.Tiga tercentang
  ('5160125004', 'Sistem Informasi Geografis', 'Geographic Information System', 'D3', 'S.I.G.', 2, 'Dibuka', 3, '01', '0', '22', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom D.Tiga tercentang
  ('5160125005', 'Teknologi Cetak dan Grafis', 'Graphic and Printing Technology', 'D3', 'C.G.', 2, 'Dibuka', 3, '01', '0', '22', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 34, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom D.Tiga tercentang
  ('5160125006', 'Teknologi Pangan', 'Food Technology', 'D3', 'T.P.', 2, 'Dibuka', 3, '01', '0', '22', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 34, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom D.Tiga tercentang
  ('5160125007', 'Teknologi Pengemasan', 'Packaging Techniques', 'D3', 'Ps.', 2, 'Dibuka', 3, '01', '0', '22', '516', 'SQ79')   -- Diksi 27/2022 hlm. 34, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom D.Tiga tercentang
  ) AS v (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
         jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id)
 WHERE NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m WHERE m.kode_prodi = v.kode_prodi)
   AND NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m
                    WHERE lower(trim(m.name_prodi)) = lower(v.name_prodi) AND m.program_id = v.program_id)
   AND EXISTS (SELECT 1 FROM public.ms_jns_pendidikan j
                WHERE j.kode_pendidikan = '3' AND j.nama_jns_pendidikan ILIKE '%vokasi%');

-- 3.6 D4: 238 baris. Sumber: Kepdirjen Diksi 27/D/M/2022 Lampiran I (centang S.Tr)
INSERT INTO public.ms_nomenklatur (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
       jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id,
       created_at, updated_at, deleted_at, id_updater, soft_delete, id_sms)
SELECT v.kode_prodi, v.name_prodi, v.name_prodi_eng, v.program_id, v.gelar, v.status_prodi_id, v.status_prodi,
       v.jenis_pendidikan_id, v.kode_sub_rumpun, v.is_kesehatan, v.id_jenj_didik, v.kode_rumpun, v.rumpun_id,
       now(), now(), NULL, NULL, '0', gen_random_uuid()::text
  FROM (VALUES
  ('1000426001', 'Angklung dan Musik Bambu', 'Angklung and Bamboo Music', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 6, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426002', 'Desain Mode Kriya Batik', 'Batik Craft Fashion Design', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 6, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426003', 'Karawitan Aceh', 'Aceh Karawitan', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 6, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426004', 'Karawitan Bali', 'Bali Karawitan', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 6, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426005', 'Karawitan Jawa', 'Java Karawitan', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 6, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426006', 'Karawitan Melayu', 'Malay Karawitan', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 6, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426007', 'Karawitan Minang', 'Minang Karawitan', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426008', 'Karawitan Sunda', 'Sunda Karawitan', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426009', 'Musik Film', 'Film Scoring', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426010', 'Musik Nusantara', 'Indonesian Traditional Music', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426011', 'Produksi Film dan Televisi', 'Film and Television Production', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426012', 'Seni Pedalangan Bali', 'Bali Pedalangan Arts', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426013', 'Seni Pedalangan Jawa', 'Java Pedalangan Arts', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426014', 'Seni Pedalangan Sunda', 'Sunda Pedalangan Arts', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426015', 'Seni Pertunjukan', 'Performing Arts', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426016', 'Senjata Tradisional Keris', 'Keris Traditional Weapon', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426017', 'Senjata Tradisional Mandau', 'Mandau Traditional Weapon', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426018', 'Senjata Tradisional Rencong', 'Rencong Traditional Weapon', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 7, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426019', 'Tari Aceh', 'Aceh Dance', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 8, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426020', 'Tari Bali', 'Bali Dance', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 8, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426021', 'Tari Jawa', 'Java Dance', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 8, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426022', 'Tari Melayu', 'Malay Dance', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 8, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426023', 'Tari Minang', 'Minang Dance', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 8, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426024', 'Tari Sunda', 'Sunda Dance', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 8, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426025', 'Tata Kelola Seni', 'Arts Management', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 8, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000426026', 'Teater Musikal', 'Musical Theater', 'D4', 'Sn.', 2, 'Dibuka', 3, '04', '0', '23', '100', 'AO21'),  -- Diksi 27/2022 hlm. 8, kelompok 1 Seni, kolom S.Tr tercentang
  ('1000226001', 'Bahasa Inggris untuk Industri Pariwisata', 'English for Tourism Industry', 'D4', 'Li.', 2, 'Dibuka', 3, '02', '0', '23', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom S.Tr tercentang
  ('1000226002', 'Bahasa Inggris untuk Komunikasi Bisnis dan Profesional', 'English for Business and Professional Communication', 'D4', 'Li.', 2, 'Dibuka', 3, '02', '0', '23', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom S.Tr tercentang
  ('1000226003', 'Bahasa Jepang untuk Komunikasi Bisnis dan Profesional', 'Japan Language for Business and Professional Communication', 'D4', 'Li.', 2, 'Dibuka', 3, '02', '0', '23', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom S.Tr tercentang
  ('1000226004', 'Bahasa Korea untuk Komunikasi Bisnis dan Profesional', 'Korea Language for Business and Professional Communication', 'D4', 'Li.', 2, 'Dibuka', 3, '02', '0', '23', '100', 'AF88'),  -- Diksi 27/2022 hlm. 8, kelompok 2 Linguistik, kolom S.Tr tercentang
  ('1000226005', 'Bahasa Mandarin untuk Komunikasi Bisnis dan Profesional', 'China Language for Business and Professional Communication', 'D4', 'Li.', 2, 'Dibuka', 3, '02', '0', '23', '100', 'AF88'),  -- Diksi 27/2022 hlm. 9, kelompok 2 Linguistik, kolom S.Tr tercentang
  ('1000226006', 'Bahasa Perancis untuk Komunikasi Bisnis dan Profesional', 'French Language for Business and Professional Communication', 'D4', 'Li.', 2, 'Dibuka', 3, '02', '0', '23', '100', 'AF88'),  -- Diksi 27/2022 hlm. 9, kelompok 2 Linguistik, kolom S.Tr tercentang
  ('2000426001', 'Pembangunan Pedesaan dan Ekonomi Masyarakat', 'Community Economic and Rural Development', 'D4', 'Sos.', 2, 'Dibuka', 3, '04', '0', '23', '200', 'BK35'),  -- Diksi 27/2022 hlm. 9, kelompok 3 Sosial, kolom S.Tr tercentang
  ('2000426002', 'Politik Indonesia Terapan', 'Applied Indonesian Politics', 'D4', 'Sos.', 2, 'Dibuka', 3, '04', '0', '23', '200', 'BK35'),  -- Diksi 27/2022 hlm. 9, kelompok 3 Sosial, kolom S.Tr tercentang
  ('2000426003', 'Studi Kebijakan Publik', 'Public Policy Studies', 'D4', 'Sos.', 2, 'Dibuka', 3, '04', '0', '23', '200', 'BK35'),  -- Diksi 27/2022 hlm. 9, kelompok 3 Sosial, kolom S.Tr tercentang
  ('2000426004', 'Studi Kependudukan dan Pencatatan Sipil', 'Demography and Civil Registration Studies', 'D4', 'Sos.', 2, 'Dibuka', 3, '04', '0', '23', '200', 'BK35'),  -- Diksi 27/2022 hlm. 9, kelompok 3 Sosial, kolom S.Tr tercentang
  ('2000126001', 'Analisis Keuangan', 'Financial Analysis', 'D4', 'E.', 2, 'Dibuka', 3, '01', '0', '23', '200', 'TRYU'),  -- Diksi 27/2022 hlm. 9, kelompok 4 Ekonomi, kolom S.Tr tercentang
  ('2000126002', 'Keuangan Publik', 'Public Finance', 'D4', 'E.', 2, 'Dibuka', 3, '01', '0', '23', '200', 'TRYU'),  -- Diksi 27/2022 hlm. 9, kelompok 4 Ekonomi, kolom S.Tr tercentang
  ('2000126003', 'Pembangunan Ekonomi Kewilayahan', 'Regional Economic Development', 'D4', 'E.', 2, 'Dibuka', 3, '01', '0', '23', '200', 'TRYU'),  -- Diksi 27/2022 hlm. 9, kelompok 4 Ekonomi, kolom S.Tr tercentang
  ('3000726001', 'Kimia Industri', 'Industrial Chemistry', 'D4', 'Si.', 2, 'Dibuka', 3, '07', '0', '23', '300', 'FM10'),  -- Diksi 27/2022 hlm. 9, kelompok 6 Kimia, kolom S.Tr tercentang
  ('3000726002', 'Kimia Tekstil', 'Textile Chemistry', 'D4', 'Si.', 2, 'Dibuka', 3, '07', '0', '23', '300', 'FM10'),  -- Diksi 27/2022 hlm. 9, kelompok 6 Kimia, kolom S.Tr tercentang
  ('3000726003', 'Kimia Terapan', 'Applied Chemistry', 'D4', 'Si.', 2, 'Dibuka', 3, '07', '0', '23', '300', 'FM10'),  -- Diksi 27/2022 hlm. 9, kelompok 6 Kimia, kolom S.Tr tercentang
  ('4000126001', 'Keamanan Sistem Informasi', 'Information Systems Security', 'D4', 'Kom.', 2, 'Dibuka', 3, '01', '0', '23', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom S.Tr tercentang
  ('4000126002', 'Keamanan Sistem Informasi Keimigrasian', 'Immigration Information Systems Security', 'D4', 'Kom.', 2, 'Dibuka', 3, '01', '0', '23', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom S.Tr tercentang
  ('4000126003', 'Kecerdasan Buatan dan Robotik', 'Artificial Intelligence and Robotics', 'D4', 'Kom.', 2, 'Dibuka', 3, '01', '0', '23', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom S.Tr tercentang
  ('4000126004', 'Rekayasa Keamanan Siber', 'Cyber Security Engineering', 'D4', 'Kom.', 2, 'Dibuka', 3, '01', '0', '23', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom S.Tr tercentang
  ('4000126005', 'Sistem Informasi Industri Otomotif', 'Automotive Industry Information Systems', 'D4', 'Kom.', 2, 'Dibuka', 3, '01', '0', '23', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom S.Tr tercentang
  ('4000126006', 'Sistem Informasi Kota Cerdas', 'Smart City Information Management', 'D4', 'Kom.', 2, 'Dibuka', 3, '01', '0', '23', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom S.Tr tercentang
  ('4000126007', 'Teknologi Permainan', 'Game Technology', 'D4', 'Kom.', 2, 'Dibuka', 3, '01', '0', '23', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom S.Tr tercentang
  ('4000126008', 'Teknologi Rekayasa Komputer Grafis', 'Computer Graphics Engineering Technology', 'D4', 'Kom.', 2, 'Dibuka', 3, '01', '0', '23', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom S.Tr tercentang
  ('4000126009', 'Teknologi Rekayasa Multimedia', 'Multimedia Engineering Technology', 'D4', 'Kom.', 2, 'Dibuka', 3, '01', '0', '23', '400', 'FX91'),  -- Diksi 27/2022 hlm. 10, kelompok 8 Komputer, kolom S.Tr tercentang
  ('4000126010', 'Teknologi Rekayasa Multimedia Grafis', 'Multimedia Graphics Engineering Technology', 'D4', 'Kom.', 2, 'Dibuka', 3, '01', '0', '23', '400', 'FX91'),  -- Diksi 27/2022 hlm. 11, kelompok 8 Komputer, kolom S.Tr tercentang
  ('4000126011', 'Teknologi Rekayasa Perangkat Lunak', 'Software Engineering Technology', 'D4', 'Kom.', 2, 'Dibuka', 3, '01', '0', '23', '400', 'FX91'),  -- Diksi 27/2022 hlm. 11, kelompok 8 Komputer, kolom S.Tr tercentang
  ('5010226001', 'Agribisnis Hortikultura', 'Horticulture Agribusiness', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226002', 'Agribisnis Pangan', 'Food Agribusiness', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226003', 'Agroindustri Kopi', 'Coffee Agroindustry', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226004', 'Pengelolaan Agribisnis', 'Agribusiness Management', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226005', 'Pengelolaan Agribisnis Perkebunan', 'Plantation Agribusiness Management', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226006', 'Pengelolaan Perkebunan', 'Plantation Management', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 11, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226007', 'Pengelolaan Perkebunan Kopi', 'Coffee Plantation Management', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226008', 'Pengelolaan Pertanian Lahan Kering', 'Upland Farming Management', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226009', 'Penyuluhan Perkebunan Presisi', 'Precision Plantation Extension', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226010', 'Penyuluhan Pertanian Berkelanjutan', 'Sustainable Agricultural Extension', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226011', 'Penyuluhan Pertanian Lahan Kering', 'Upland Agricultural Extension', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226012', 'Teknologi Benih', 'Seed Technology', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226013', 'Teknologi Produksi Tanaman Hortikultura', 'Horticulture Production Technology', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226014', 'Teknologi Produksi Tanaman Pangan', 'Edible Plants Production Technology', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010226015', 'Teknologi Produksi Tanaman Perkebunan', 'Plantation Crop Production Technology', 'D4', 'P.', 2, 'Dibuka', 3, '02', '0', '23', '501', 'HB25'),  -- Diksi 27/2022 hlm. 12, kelompok 10 Ilmu atau Sains Pertanian, kolom S.Tr tercentang
  ('5010326001', 'Agribisnis Peternakan', 'Husbandry Agribusiness', 'D4', 'Pt.', 2, 'Dibuka', 3, '03', '0', '23', '501', 'HC98'),  -- Diksi 27/2022 hlm. 12, kelompok 11 Peternakan, kolom S.Tr tercentang
  ('5010326002', 'Agribisnis Unggas', 'Poultry Agribusiness', 'D4', 'Pt.', 2, 'Dibuka', 3, '03', '0', '23', '501', 'HC98'),  -- Diksi 27/2022 hlm. 12, kelompok 11 Peternakan, kolom S.Tr tercentang
  ('5010326003', 'Penyuluhan Peternakan dan Kesejahteraan Hewan', 'Animal Husbandry and Animal Welfare Extension', 'D4', 'Pt.', 2, 'Dibuka', 3, '03', '0', '23', '501', 'HC98'),  -- Diksi 27/2022 hlm. 13, kelompok 11 Peternakan, kolom S.Tr tercentang
  ('5010326004', 'Teknologi Pakan Ternak', 'Livestock Feed Technology', 'D4', 'Pt.', 2, 'Dibuka', 3, '03', '0', '23', '501', 'HC98'),  -- Diksi 27/2022 hlm. 13, kelompok 11 Peternakan, kolom S.Tr tercentang
  ('5010326005', 'Teknologi Produksi Ternak', 'livestock Production Technology', 'D4', 'Pt.', 2, 'Dibuka', 3, '03', '0', '23', '501', 'HC98'),  -- Diksi 27/2022 hlm. 13, kelompok 11 Peternakan, kolom S.Tr tercentang
  ('5010126001', 'Agribisnis Perikanan', 'Fisheries Agribusiness', 'D4', 'Pi.', 2, 'Dibuka', 3, '01', '0', '23', '501', 'GV92'),  -- Diksi 27/2022 hlm. 13, kelompok 12 Ilmu atau Sains Perikanan, kolom S.Tr tercentang
  ('5010126002', 'Bioteknologi Perikanan', 'Fisheries Biotechnology', 'D4', 'Pi.', 2, 'Dibuka', 3, '01', '0', '23', '501', 'GV92'),  -- Diksi 27/2022 hlm. 13, kelompok 12 Ilmu atau Sains Perikanan, kolom S.Tr tercentang
  ('5010126003', 'Budidaya Perikanan Presisi', 'Precision Fish Farming', 'D4', 'Pi.', 2, 'Dibuka', 3, '01', '0', '23', '501', 'GV92'),  -- Diksi 27/2022 hlm. 13, kelompok 12 Ilmu atau Sains Perikanan, kolom S.Tr tercentang
  ('5010126004', 'Budidaya Perikanan Terpadu', 'Integrated Aquaculture', 'D4', 'Pi.', 2, 'Dibuka', 3, '01', '0', '23', '501', 'GV92'),  -- Diksi 27/2022 hlm. 13, kelompok 12 Ilmu atau Sains Perikanan, kolom S.Tr tercentang
  ('5010126005', 'Pengolahan dan Penyimpanan Hasil Perikanan', 'Aquatic Product Processing and Storage', 'D4', 'Pi.', 2, 'Dibuka', 3, '01', '0', '23', '501', 'GV92'),  -- Diksi 27/2022 hlm. 13, kelompok 12 Ilmu atau Sains Perikanan, kolom S.Tr tercentang
  ('5010126006', 'Teknologi Budi Daya Perikanan/Teknologi Akuakultur', 'Aquaculture Technology', 'D4', 'Pi.', 2, 'Dibuka', 3, '01', '0', '23', '501', 'GV92'),  -- Diksi 27/2022 hlm. 14, kelompok 12 Ilmu atau Sains Perikanan, kolom S.Tr tercentang
  ('5010126007', 'Teknologi Cerdas Penangkapan Ikan', 'Smart Fishing Technology', 'D4', 'Pi.', 2, 'Dibuka', 3, '01', '0', '23', '501', 'GV92'),  -- Diksi 27/2022 hlm. 14, kelompok 12 Ilmu atau Sains Perikanan, kolom S.Tr tercentang
  ('5010126008', 'Teknologi Pembenihan Ikan', 'Fish Hatchery Technology', 'D4', 'Pi.', 2, 'Dibuka', 3, '01', '0', '23', '501', 'GV92'),  -- Diksi 27/2022 hlm. 14, kelompok 12 Ilmu atau Sains Perikanan, kolom S.Tr tercentang
  ('5020126001', 'Arsitektur Bangunan Gedung', 'Building Architecture', 'D4', 'Ars.', 2, 'Dibuka', 3, '01', '0', '23', '502', 'IP90'),  -- Diksi 27/2022 hlm. 14, kelompok 13 Arsitektur, kolom S.Tr tercentang
  ('5020226001', 'Desain Mode', 'Fashion design', 'D4', 'Ds.', 2, 'Dibuka', 3, '02', '0', '23', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom S.Tr tercentang
  ('5020226002', 'Desain Mode Batik', 'Batik Fashion Design', 'D4', 'Ds.', 2, 'Dibuka', 3, '02', '0', '23', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom S.Tr tercentang
  ('5020226003', 'Desain Mode Tenun', 'Woven Fashion Design', 'D4', 'Ds.', 2, 'Dibuka', 3, '02', '0', '23', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom S.Tr tercentang
  ('5020226004', 'Desain Panggung', 'Stage design', 'D4', 'Ds.', 2, 'Dibuka', 3, '02', '0', '23', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom S.Tr tercentang
  ('5020226005', 'Desain Produk Kayu dan Serat', 'Wood and Fiber Product Design', 'D4', 'Ds.', 2, 'Dibuka', 3, '02', '0', '23', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom S.Tr tercentang
  ('5020226006', 'Desain Produk Kulit, Karet, dan Plastik', 'Leather, Rubber and Plastic Product Design', 'D4', 'Ds.', 2, 'Dibuka', 3, '02', '0', '23', '502', 'JG29'),  -- Diksi 27/2022 hlm. 14, kelompok 14 Desain, kolom S.Tr tercentang
  ('5030326001', 'Akuntansi Bisnis Digital', 'Digital Business Accounting', 'D4', 'Ak.', 2, 'Dibuka', 3, '03', '0', '23', '503', 'KX47'),  -- Diksi 27/2022 hlm. 15, kelompok 15 Akuntansi, kolom S.Tr tercentang
  ('5030326002', 'Akuntansi Lembaga Keuangan Syariah', 'Syariah Accounting', 'D4', 'Ak.', 2, 'Dibuka', 3, '03', '0', '23', '503', 'KX47'),  -- Diksi 27/2022 hlm. 15, kelompok 15 Akuntansi, kolom S.Tr tercentang
  ('5030326003', 'Akuntansi Perpajakan', 'Tax Accounting', 'D4', 'Ak.', 2, 'Dibuka', 3, '03', '0', '23', '503', 'KX47'),  -- Diksi 27/2022 hlm. 15, kelompok 15 Akuntansi, kolom S.Tr tercentang
  ('5030326004', 'Akuntansi Sektor Publik', 'Public Sector Accounting', 'D4', 'Ak.', 2, 'Dibuka', 3, '03', '0', '23', '503', 'KX47'),  -- Diksi 27/2022 hlm. 15, kelompok 15 Akuntansi, kolom S.Tr tercentang
  ('5030426001', 'Kebijakan dan Manajemen Pajak', 'Taxation Policy and Management', 'D4', 'M.', 2, 'Dibuka', 3, '04', '0', '23', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom S.Tr tercentang
  ('5030426002', 'Manajemen Agribisnis', 'Agribusiness Management', 'D4', 'M.', 2, 'Dibuka', 3, '04', '0', '23', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom S.Tr tercentang
  ('5030426003', 'Manajemen Aset Sektor Publik', 'Public Asset Management', 'D4', 'M.', 2, 'Dibuka', 3, '04', '0', '23', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom S.Tr tercentang
  ('5030426004', 'Manajemen Keuangan Sektor Publik', 'Public Financial Management', 'D4', 'M.', 2, 'Dibuka', 3, '04', '0', '23', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom S.Tr tercentang
  ('5030426005', 'Manajemen Pemasaran Internasional', 'International Marketing Management', 'D4', 'M.', 2, 'Dibuka', 3, '04', '0', '23', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom S.Tr tercentang
  ('5030426006', 'Manajemen Sumber Daya Manusia Sektor Publik', 'Public Sector-Human Resources Management', 'D4', 'M.', 2, 'Dibuka', 3, '04', '0', '23', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom S.Tr tercentang
  ('5030426007', 'Perbankan dan Keuangan Digital', 'Banking and Digital Finance', 'D4', 'M.', 2, 'Dibuka', 3, '04', '0', '23', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom S.Tr tercentang
  ('5030426008', 'Relasi Industri', 'Industrial Relations', 'D4', 'M.', 2, 'Dibuka', 3, '04', '0', '23', '503', 'LC42'),  -- Diksi 27/2022 hlm. 15, kelompok 16 Manajemen, kolom S.Tr tercentang
  ('5030526001', 'Logistik Niaga-El', 'E-Commerce Logistics', 'D4', 'Log.', 2, 'Dibuka', 3, '05', '0', '23', '503', 'LP65'),  -- Diksi 27/2022 hlm. 16, kelompok 17 Logistik, kolom S.Tr tercentang
  ('5030526002', 'Logistik Perdagangan Internasional', 'International Trade Logistics', 'D4', 'Log.', 2, 'Dibuka', 3, '05', '0', '23', '503', 'LP65'),  -- Diksi 27/2022 hlm. 16, kelompok 17 Logistik, kolom S.Tr tercentang
  ('5030126001', 'Administrasi Bisnis Otomotif', 'Automotive Business Administration', 'D4', 'A.B.', 2, 'Dibuka', 3, '01', '0', '23', '503', 'KQ12'),  -- Diksi 27/2022 hlm. 16, kelompok 18 Administrasi Bisnis, kolom S.Tr tercentang
  ('5030226001', 'Bisnis dan Logistik Maritim', 'Maritime Business and Logistics', 'D4', 'Bns.', 2, 'Dibuka', 3, '02', '0', '23', '503', 'KV17'),  -- Diksi 27/2022 hlm. 16, kelompok 19 Bisnis, kolom S.Tr tercentang
  ('5030226002', 'Bisnis dan Manajemen Ritel', 'Retail Business and Management', 'D4', 'Bns.', 2, 'Dibuka', 3, '02', '0', '23', '503', 'KV17'),  -- Diksi 27/2022 hlm. 16, kelompok 19 Bisnis, kolom S.Tr tercentang
  ('5030226003', 'Bisnis Jasa Makanan', 'Food Service Industry', 'D4', 'Bns.', 2, 'Dibuka', 3, '02', '0', '23', '503', 'KV17'),  -- Diksi 27/2022 hlm. 16, kelompok 19 Bisnis, kolom S.Tr tercentang
  ('5030226004', 'Bisnis Kreatif', 'Creative Business', 'D4', 'Bns.', 2, 'Dibuka', 3, '02', '0', '23', '503', 'KV17'),  -- Diksi 27/2022 hlm. 16, kelompok 19 Bisnis, kolom S.Tr tercentang
  ('5030226005', 'Bisnis Maritim Internasional', 'International Maritime Business', 'D4', 'Bns.', 2, 'Dibuka', 3, '02', '0', '23', '503', 'KV17'),  -- Diksi 27/2022 hlm. 16, kelompok 19 Bisnis, kolom S.Tr tercentang
  ('5030226006', 'Bisnis Musik', 'Music Business', 'D4', 'Bns.', 2, 'Dibuka', 3, '02', '0', '23', '503', 'KV17'),  -- Diksi 27/2022 hlm. 16, kelompok 19 Bisnis, kolom S.Tr tercentang
  ('5030226007', 'Produksi Garmen', 'Garment Production', 'D4', 'Bns.', 2, 'Dibuka', 3, '02', '0', '23', '503', 'KV17'),  -- Diksi 27/2022 hlm. 17, kelompok 19 Bisnis, kolom S.Tr tercentang
  ('5030626001', 'Bisnis Digital', 'Digital Business', 'D4', 'Bns.', 2, 'Dibuka', 3, '06', '0', '23', '503', 'MF45'),  -- Diksi 27/2022 hlm. 17, kelompok 19A Bisnis Digital, kolom S.Tr tercentang
  ('5030626002', 'Bisnis Digital Pariwisata', 'Tourism Digital Business', 'D4', 'Bns.', 2, 'Dibuka', 3, '06', '0', '23', '503', 'MF45'),  -- Diksi 27/2022 hlm. 17, kelompok 19A Bisnis Digital, kolom S.Tr tercentang
  ('5040126001', 'Jurnalistik Mode', 'Fashion Journalism', 'D4', 'I.Kom.', 2, 'Dibuka', 3, '01', '0', '23', '504', 'MO24'),  -- Diksi 27/2022 hlm. 17, kelompok 20 Ilmu atau Sains Komunikasi, kolom S.Tr tercentang
  ('5040126002', 'Produksi Media', 'Media Production', 'D4', 'I.Kom.', 2, 'Dibuka', 3, '01', '0', '23', '504', 'MO24'),  -- Diksi 27/2022 hlm. 17, kelompok 20 Ilmu atau Sains Komunikasi, kolom S.Tr tercentang
  ('5060126001', 'Teknologi Rekayasa Elektro-medis', 'Medical Electronics Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 17, kelompok 21 Rekayasa (Rekayasa Biomedis), kolom S.Tr tercentang
  ('5060126002', 'Teknologi Rekayasa Aeronautika', 'Aeronautics Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom S.Tr tercentang
  ('5060126003', 'Teknologi Rekayasa Bandar Udara', 'Airport Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom S.Tr tercentang
  ('5060126004', 'Teknologi Rekayasa Navigasi Udara', 'Air Navigation Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom S.Tr tercentang
  ('5060126005', 'Teknologi Rekayasa Pemeliharaan Pesawat Udara', 'Aircraft Maintenance Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom S.Tr tercentang
  ('5060126006', 'Teknologi Rekayasa Sistem Kedirgantaraan', 'Aerospace Systems Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 18, kelompok 21 Rekayasa (Rekayasa Dirgantara), kolom S.Tr tercentang
  ('5060126007', 'Teknologi Rekayasa Elektronika', 'Electronics Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Elektro), kolom S.Tr tercentang
  ('5060126008', 'Teknologi Rekayasa Instalasi Listrik', 'Electrical Installation Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Elektro), kolom S.Tr tercentang
  ('5060126009', 'Teknologi Rekayasa Otomasi', 'Automation Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Elektro), kolom S.Tr tercentang
  ('5060126010', 'Teknologi Rekayasa Pembangkit Energi', 'Power Plant Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Elektro), kolom S.Tr tercentang
  ('5060126011', 'Teknologi Rekayasa Sistem Elektronika', 'Electronic Systems Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Elektro), kolom S.Tr tercentang
  ('5060126012', 'Teknologi Rekayasa Energi Berkelanjutan', 'Sustainable Energy Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Energi Terbarukan), kolom S.Tr tercentang
  ('5060126013', 'Teknologi Rekayasa Energi Terbarukan', 'Renewable Energy Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Energi Terbarukan), kolom S.Tr tercentang
  ('5060126014', 'Teknologi Rekayasa Instrumentasi', 'Instrumentation Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 19, kelompok 21 Rekayasa (Rekayasa Fisika), kolom S.Tr tercentang
  ('5060126015', 'Teknologi Rekayasa Instrumentasi dan Kontrol', 'Instrumentation and Control Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Fisika), kolom S.Tr tercentang
  ('5060126016', 'Teknologi Rekayasa Robotika', 'Robotics Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Fisika), kolom S.Tr tercentang
  ('5060126017', 'Teknologi Rekayasa Geometika dan Survei', 'Surveying and Geomatics Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Geomatika), kolom S.Tr tercentang
  ('5060126018', 'Teknologi Rekayasa Penginderaan Jauh', 'Remote Sensing Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Geomatika), kolom S.Tr tercentang
  ('5060126019', 'Teknologi Rekayasa Industri Otomotif', 'Automotive Industrial Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Industri), kolom S.Tr tercentang
  ('5060126020', 'Teknologi Rekayasa Logistik', 'Logistic Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Industri), kolom S.Tr tercentang
  ('5060126021', 'Pengembangan Produk Agroindustri', 'Agroindustry Product Development', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Industri Pertanian), kolom S.Tr tercentang
  ('5060126022', 'Teknologi Rekayasa Keselamatan', 'Safety Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 20, kelompok 21 Rekayasa (Rekayasa Keselamatan), kolom S.Tr tercentang
  ('5060126023', 'Teknologi Rekayasa Keselamatan Kebakaran', 'Fire Safety Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Keselamatan), kolom S.Tr tercentang
  ('5060126024', 'Teknologi Rekayasa Keselamatan Kelautan', 'Marine Safety Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Keselamatan), kolom S.Tr tercentang
  ('5060126025', 'Teknologi Rekayasa Bersih', 'Clean Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom S.Tr tercentang
  ('5060126026', 'Teknologi Rekayasa Bioproses Energi Terbarukan', 'Renewable Energy Bioprocess Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom S.Tr tercentang
  ('5060126027', 'Teknologi Rekayasa Kimia Industri', 'Industrial Chemical Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom S.Tr tercentang
  ('5060126028', 'Teknologi Rekayasa Kimia Polimer', 'Polymeric Chemistry Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 21, kelompok 21 Rekayasa (Rekayasa Kimia), kolom S.Tr tercentang
  ('5060126029', 'Teknologi Rekayasa Jaringan', 'Computer Network Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Komputer), kolom S.Tr tercentang
  ('5060126030', 'Teknologi Rekayasa Informatika Industri', 'Industrial Informatics Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Komputer), kolom S.Tr tercentang
  ('5060126031', 'Teknologi Rekayasa Komputer', 'Computer Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Komputer), kolom S.Tr tercentang
  ('5060126032', 'Teknologi Rekayasa Pengendalian Pencemaran Lingkungan', 'Environmental Pollution Control Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Lingkungan), kolom S.Tr tercentang
  ('5060126033', 'Teknologi Rekayasa Material Maju', 'Advanced Material Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Material), kolom S.Tr tercentang
  ('5060126034', 'Teknologi Rekayasa Metalurgi', 'Metallurgical Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Material), kolom S.Tr tercentang
  ('5060126035', 'Teknologi Rekayasa Pengolahan Karet dan Plastik', 'Rubber and Plastic Processing Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Material), kolom S.Tr tercentang
  ('5060126036', 'Teknologi Rekayasa Pengolahan Kulit', 'Leather Processing Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 22, kelompok 21 Rekayasa (Rekayasa Material), kolom S.Tr tercentang
  ('5060126037', 'Teknologi Rekayasa Pengelasan dan Fabrikasi', 'Welding and Fabrication Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 23, kelompok 21 Rekayasa (Rekayasa Mesin), kolom S.Tr tercentang
  ('5060126038', 'Rekayasa Perancangan Mekanik', 'Mechanical Design Engineering', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 23, kelompok 21 Rekayasa (Rekayasa Mesin), kolom S.Tr tercentang
  ('5060126039', 'Teknologi Rekayasa Elektrikal Mekanik', 'Mechanical Electrical engineering technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom S.Tr tercentang
  ('5060126040', 'Teknologi Rekayasa Manufaktur', 'Manufacturing Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom S.Tr tercentang
  ('5060126041', 'Teknologi Rekayasa Mekatronika', 'Mechatronics Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom S.Tr tercentang
  ('5060126042', 'Teknologi Rekayasa Otomotif', 'Automotive Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom S.Tr tercentang
  ('5060126043', 'Teknologi Rekayasa Pemeliharaan Alat Berat', 'Heavy Equipment Maintenance Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom S.Tr tercentang
  ('5060126044', 'Teknologi Rekayasa Perancangan Manufaktur', 'Manufacturing Design Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 24, kelompok 21 Rekayasa (Rekayasa Mesin), kolom S.Tr tercentang
  ('5060126045', 'Teknologi Rekayasa Konversi Energi', 'Energy Conversion Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 25, kelompok 21 Rekayasa (Rekayasa Mesin), kolom S.Tr tercentang
  ('5060126046', 'Manajemen Konstruksi', 'Construction Management', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 25, kelompok 21 Rekayasa (Rekayasa Sipil), kolom S.Tr tercentang
  ('5060126047', 'Teknologi Rekayasa Konstruksi Bangunan Air', 'Waterworks Construction Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom S.Tr tercentang
  ('5060126048', 'Teknologi Rekayasa Konstruksi Bangunan Gedung', 'Building Construction Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom S.Tr tercentang
  ('5060126049', 'Teknologi Rekayasa Konstruksi Bangunan Rawa', 'Swamp Construction Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom S.Tr tercentang
  ('5060126050', 'Teknologi Rekayasa Konstruksi Jalan dan Jembatan', 'Road and Bridge Construction Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom S.Tr tercentang
  ('5060126051', 'Teknologi Rekayasa Pengelolaan dan Pemeliharaan Bangunan Sipil', 'Civil Building Management and Maintenance Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom S.Tr tercentang
  ('5060126052', 'Teknologi Rekayasa Perpipaan', 'Piping Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom S.Tr tercentang
  ('5060126053', 'Teknologi Rekayasa Sumber Daya Tanah dan Air', 'Soil and Water Resources Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom S.Tr tercentang
  ('5060126054', 'Teknologi Rekayasa Transportasi', 'Transportation Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 26, kelompok 21 Rekayasa (Rekayasa Sipil), kolom S.Tr tercentang
  ('5060126055', 'Teknologi Rekayasa Internet', 'Internet Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Telekomunikasi), kolom S.Tr tercentang
  ('5060126056', 'Teknologi Rekayasa Jaringan Telekomunikasi', 'Telecommunication Network Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Telekomunikasi), kolom S.Tr tercentang
  ('5060126057', 'Teknologi Rekayasa Telekomunikasi', 'Telecommunications Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Telekomunikasi), kolom S.Tr tercentang
  ('5060126058', 'Teknologi Rekayasa Kelautan', 'Marine Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Kelautan), kolom S.Tr tercentang
  ('5060126059', 'Teknologi Rekayasa Arsitektur Perkapalan', 'Naval Architecture Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Sistem Perkapalan), kolom S.Tr tercentang
  ('5060126060', 'Teknologi Rekayasa Kelistrikan Kapal', 'Marine Electrical Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Sistem Perkapalan), kolom S.Tr tercentang
  ('5060126061', 'Teknologi Rekayasa Konstruksi Perkapalan', 'Naval Construction Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Sistem Perkapalan), kolom S.Tr tercentang
  ('5060126062', 'Teknologi Rekayasa Permesinan Kapal', 'Marine Mechanical Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Sistem Perkapalan), kolom S.Tr tercentang
  ('5060126063', 'Teknologi Rekayasa Tekstil', 'Textile Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Rekayasa Tekstil), kolom S.Tr tercentang
  ('5060126064', 'Manajemen Teknologi Rekayasa', 'Engineering Technology Management', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '506', 'NR26'),  -- Diksi 27/2022 hlm. 27, kelompok 21 Rekayasa (Manajemen Rekayasa), kolom S.Tr tercentang
  ('5070226001', 'Rekayasa Kayu', 'Wood Engineering', 'D4', 'Hut.', 2, 'Dibuka', 3, '02', '0', '23', '507', 'NY14'),  -- Diksi 27/2022 hlm. 28, kelompok 23 Kehutanan, kolom S.Tr tercentang
  ('5080226001', 'Akupuntur dan Pengobatan Herbal', 'Acupuncture and Herbal Medicine', 'D4', 'Akup.', 2, 'Dibuka', 3, '02', '1', '23', '508', 'PE84'),  -- Diksi 27/2022 hlm. 28, kelompok 24 Ilmu atau Sains Kedokteran, kolom S.Tr tercentang
  ('5080126001', 'Gizi dan Dietetika', 'Nutrition and Dietetics', 'D4', 'Gz.', 2, 'Dibuka', 3, '01', '1', '23', '508', 'NZ82'),  -- Diksi 27/2022 hlm. 28, kelompok 27 Ilmu atau Sains Gizi, kolom S.Tr tercentang
  ('5080126002', 'Gizi Klinis', 'Clinical Nutrition', 'D4', 'Gz.', 2, 'Dibuka', 3, '01', '1', '23', '508', 'NZ82'),  -- Diksi 27/2022 hlm. 28, kelompok 27 Ilmu atau Sains Gizi, kolom S.Tr tercentang
  ('5080626001', 'Kebidanan', 'Midwifery', 'D4', 'Keb.', 2, 'Dibuka', 3, '06', '1', '23', '508', 'QI95'),  -- Diksi 27/2022 hlm. 28, kelompok 29 Kebidanan, kolom S.Tr tercentang
  ('5080726001', 'Keperawatan', 'Nursing', 'D4', 'Kep.', 2, 'Dibuka', 3, '07', '1', '23', '508', 'QK58'),  -- Diksi 27/2022 hlm. 28, kelompok 30 Keperawatan, kolom S.Tr tercentang
  ('5080826001', 'Fisioterapi', 'Physiotherapy', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826002', 'Keperawatan Anestesiologi', 'Nurse Anesthesiology', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826003', 'Keselamatan dan Kesehatan Kerja', 'Occupational Health and Safety', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826004', 'Manajemen Informasi Kesehatan', 'Health information Management', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826005', 'Nutrasetikal', 'Nutraceuticals', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826006', 'Ortotik dan Prostetik', 'Orthotics and Prosthetics', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826007', 'Pengobatan Tradisional Indonesia', 'Indonesia Traditional Medicine', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826008', 'Pengobatan Tradisional Tiongkok', 'China Traditional Medicine', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826009', 'Promosi Kesehatan', 'Health Promotion', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826010', 'Sanitasi Lingkungan', 'Environmental Sanitation', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 29, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826011', 'Teknologi Laboratorium Medis', 'Medical Laboratory Technology', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 30, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826012', 'Teknologi Radiologi Pencitraan', 'Radiologic Imaging Technology', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 30, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826013', 'Terapi Gigi', 'Dental Therapy', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 30, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826014', 'Terapi Okupasi', 'Occupational Therapy', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 30, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5080826015', 'Terapi Wicara dan Bahasa', 'Speech and Language Therapy', 'D4', 'Kes.', 2, 'Dibuka', 3, '08', '1', '23', '508', 'QL11'),  -- Diksi 27/2022 hlm. 30, kelompok 31 Ilmu atau Sains Kesehatan, kolom S.Tr tercentang
  ('5090126001', 'Pengelolaan Arsip dan Rekaman Informasi', 'Archives and Records Management', 'D4', 'S.I.', 2, 'Dibuka', 3, '01', '0', '23', '509', 'RE16'),  -- Diksi 27/2022 hlm. 30, kelompok 32 Ilmu atau Sains Informasi, kolom S.Tr tercentang
  ('5090126002', 'Perpustakaan Digital', 'Digital Library', 'D4', 'S.I.', 2, 'Dibuka', 3, '01', '0', '23', '509', 'RE16'),  -- Diksi 27/2022 hlm. 30, kelompok 32 Ilmu atau Sains Informasi, kolom S.Tr tercentang
  ('5100126001', 'Peradilan Pidana', 'Criminal Justice', 'D4', 'H.', 2, 'Dibuka', 3, '01', '0', '23', '510', 'RK96'),  -- Diksi 27/2022 hlm. 30, kelompok 33 Hukum, kolom S.Tr tercentang
  ('5120126001', 'Administrasi Pemerintahan Daerah', 'Local Government Administration', 'D4', 'A.P.', 2, 'Dibuka', 3, '01', '0', '23', '512', 'RO36'),  -- Diksi 27/2022 hlm. 30, kelompok 35 Urusan Publik, kolom S.Tr tercentang
  ('5120126002', 'Manajemen Keamanan dan Keselamatan Publik', 'Public Safety and Emergency Management', 'D4', 'A.P.', 2, 'Dibuka', 3, '01', '0', '23', '512', 'RO36'),  -- Diksi 27/2022 hlm. 30, kelompok 35 Urusan Publik, kolom S.Tr tercentang
  ('5120126003', 'Manajemen Kontrak Pemerintah', 'Government Contract Management', 'D4', 'A.P.', 2, 'Dibuka', 3, '01', '0', '23', '512', 'RO36'),  -- Diksi 27/2022 hlm. 30, kelompok 35 Urusan Publik, kolom S.Tr tercentang
  ('5120126004', 'Pekerjaan Sosial', 'Social Works', 'D4', 'Sos.', 2, 'Dibuka', 3, '01', '0', '23', '512', 'RO36'),  -- Diksi 27/2022 hlm. 30, kelompok 35 Urusan Publik, kolom S.Tr tercentang
  ('5120126005', 'Layanan Publik', 'Public Services', 'D4', 'A.P.', 2, 'Dibuka', 3, '01', '0', '23', '512', 'RO36'),  -- Diksi 27/2022 hlm. 30, kelompok 35 Urusan Publik, kolom S.Tr tercentang
  ('5120126006', 'Layanan Publik Keimigrasian', 'Public Immigration Services', 'D4', 'A.P.', 2, 'Dibuka', 3, '01', '0', '23', '512', 'RO36'),  -- Diksi 27/2022 hlm. 30, kelompok 35 Urusan Publik, kolom S.Tr tercentang
  ('5120126007', 'Perlindungan dan Pemberdayaan Sosial', 'Social Protection and Empowerment', 'D4', 'Sos.', 2, 'Dibuka', 3, '01', '0', '23', '512', 'RO36'),  -- Diksi 27/2022 hlm. 30, kelompok 35 Urusan Publik, kolom S.Tr tercentang
  ('5120126008', 'Rahabilitasi Sosial', 'Social Rehabilitation', 'D4', 'Sos.', 2, 'Dibuka', 3, '01', '0', '23', '512', 'RO36'),  -- Diksi 27/2022 hlm. 30, kelompok 35 Urusan Publik, kolom S.Tr tercentang
  ('5140126001', 'Destinasi Pariwisata', 'Tourism Destination', 'D4', 'Par.', 2, 'Dibuka', 3, '01', '0', '23', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom S.Tr tercentang
  ('5140126002', 'Pariwisata Bahari', 'Marine Tourism', 'D4', 'Par.', 2, 'Dibuka', 3, '01', '0', '23', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom S.Tr tercentang
  ('5140126003', 'Pengelolaan Konvensi dan Acara', 'Convention and Event Management', 'D4', 'Par.', 2, 'Dibuka', 3, '01', '0', '23', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom S.Tr tercentang
  ('5140126004', 'Pengelolaan Perhotelan', 'Hotel Management', 'D4', 'Par.', 2, 'Dibuka', 3, '01', '0', '23', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom S.Tr tercentang
  ('5140126005', 'Pengelolaan Usaha Rekreasi', 'Sport, Recreation & Leisure Management', 'D4', 'Par.', 2, 'Dibuka', 3, '01', '0', '23', '514', 'SO20'),  -- Diksi 27/2022 hlm. 31, kelompok 50 Pariwisata, kolom S.Tr tercentang
  ('5140126006', 'Usaha Perjalanan Wisata', 'Tour and Travel Business', 'D4', 'Par.', 2, 'Dibuka', 3, '01', '0', '23', '514', 'SO20'),  -- Diksi 27/2022 hlm. 32, kelompok 50 Pariwisata, kolom S.Tr tercentang
  ('5150126001', 'Manajemen Pelabuhan dan Logistik Maritim', 'Maritime Logistic and Port Management', 'D4', 'Tra.', 2, 'Dibuka', 3, '01', '0', '23', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom S.Tr tercentang
  ('5150126002', 'Manajemen Pelabuhan Perikanan', 'Fishing Port Management', 'D4', 'Tra.', 2, 'Dibuka', 3, '01', '0', '23', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom S.Tr tercentang
  ('5150126003', 'Manajemen Pemanduan Lalu Lintas Udara', 'Air Traffic Control Management', 'D4', 'Tra.', 2, 'Dibuka', 3, '01', '0', '23', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom S.Tr tercentang
  ('5150126004', 'Rekayasa Sistem Transportasi Jalan', 'Road Transportation System Engineering', 'D4', 'Tra.', 2, 'Dibuka', 3, '01', '0', '23', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom S.Tr tercentang
  ('5150126005', 'Rekayasa Sistem Transportasi Perkeretaapian', 'Railways Transportation System Engineering', 'D4', 'Tra.', 2, 'Dibuka', 3, '01', '0', '23', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom S.Tr tercentang
  ('5150126006', 'Studi Aeronautika', 'Aeronautical Studies', 'D4', 'Tra.', 2, 'Dibuka', 3, '01', '0', '23', '515', 'SP52'),  -- Diksi 27/2022 hlm. 32, kelompok 51 Transportasi, kolom S.Tr tercentang
  ('5150126007', 'Teknologi Rekayasa Operasi Kapal', 'Ship Operation Engineering Technology', 'D4', 'Tra.', 2, 'Dibuka', 3, '01', '0', '23', '515', 'SP52'),  -- Diksi 27/2022 hlm. 33, kelompok 51 Transportasi, kolom S.Tr tercentang
  ('5150126008', 'Transportasi Darat', 'Land Transportation', 'D4', 'Tra.', 2, 'Dibuka', 3, '01', '0', '23', '515', 'SP52'),  -- Diksi 27/2022 hlm. 33, kelompok 51 Transportasi, kolom S.Tr tercentang
  ('5150126009', 'Transportasi Laut', 'Marine Transportation', 'D4', 'Tra.', 2, 'Dibuka', 3, '01', '0', '23', '515', 'SP52'),  -- Diksi 27/2022 hlm. 33, kelompok 51 Transportasi, kolom S.Tr tercentang
  ('5150126010', 'Transportasi Udara', 'Air Transportation', 'D4', 'Tra.', 2, 'Dibuka', 3, '01', '0', '23', '515', 'SP52'),  -- Diksi 27/2022 hlm. 33, kelompok 51 Transportasi, kolom S.Tr tercentang
  ('5160126001', 'Animasi', 'Animation', 'D4', 'Anim.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ('5160126002', 'Desain Media', 'Media Design', 'D4', 'Ds.M.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ('5160126003', 'Manajemen Penanggulangan Bencana dan Kegawatdaruratan', 'Emergency and Disaster Management', 'D4', 'M.B.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ('5160126004', 'Nanoteknologi Pangan', 'Food Nanotechnology', 'D4', 'N.P.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ('5160126005', 'Penginderaan Jauh dan Sistem Informasi Geografis', 'Remote Sensing and Geographic Information System', 'D4', 'S.I.G.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ('5160126006', 'Penyelamatan dan Bantuan Internasional', 'International Rescue and Relief', 'D4', 'M.B.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ('5160126007', 'Sains Data Terapan', 'Applied Data Science', 'D4', 'S.D.T.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ('5160126008', 'Sistem Informasi Bisnis', 'Business Information System', 'D4', 'S.I.B.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ('5160126009', 'Sistem Siber-Fisik', 'Physical-Cyber System', 'D4', 'S.S.F.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 33, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ('5160126010', 'Teknologi Rekayasa Cetak dan Grafis 3 Dimensi', '3D Graphic and Printing Engineering Technology', 'D4', 'C.G.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 34, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ('5160126011', 'Teknologi Rekayasa Pangan', 'Food Engineering Technology', 'D4', 'T.P.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79'),  -- Diksi 27/2022 hlm. 34, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ('5160126012', 'Teknologi Rekayasa Utilitas', 'Utility Engineering Technology', 'D4', 'T.', 2, 'Dibuka', 3, '01', '0', '23', '516', 'SQ79')   -- Diksi 27/2022 hlm. 34, kelompok O Jejaring Keilmuan Multi-, Inter-, atau Transdisiplin, kolom S.Tr tercentang
  ) AS v (kode_prodi, name_prodi, name_prodi_eng, program_id, gelar, status_prodi_id, status_prodi,
         jenis_pendidikan_id, kode_sub_rumpun, is_kesehatan, id_jenj_didik, kode_rumpun, rumpun_id)
 WHERE NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m WHERE m.kode_prodi = v.kode_prodi)
   AND NOT EXISTS (SELECT 1 FROM public.ms_nomenklatur m
                    WHERE lower(trim(m.name_prodi)) = lower(v.name_prodi) AND m.program_id = v.program_id)
   AND EXISTS (SELECT 1 FROM public.ms_jns_pendidikan j
                WHERE j.kode_pendidikan = '3' AND j.nama_jns_pendidikan ILIKE '%vokasi%');

-- 4. Bagian D - USULAN PENONAKTIFAN (dikomentari; jalankan hanya setelah disetujui DAN setelah aplikasi
--    menyaring deleted_at, mis. Fungsi::pilihan_nomenklatur() dan halaman Data Master Nomenklatur).
--    Tidak menghapus baris, sehingga ajuan lama tetap bisa menampilkan nomenklaturnya.
-- 5030418012 S1 Manajemen Ritel: Duplikat "Manajemen Ritel" S1 (kode berpola S2 "18"); padanan resminya 5030416005 yang diganti menjadi "Manajemen Retail"
-- 5130116004 S1 Manajemen Olahraga: S1 Manajemen Olahraga berstatus Moratorium di lampiran SIAGA 2026 no. 347
-- 5160116016 S1 Manajemen Bencana: S1 Manajemen Bencana berstatus Moratorium di lampiran SIAGA 2026 no. 364
-- 5050118029 S2 Pengajaran Fisika: S2 Pengajaran Fisika tidak tercantum di Lampiran I 96/B/KPT/2025 (yang ada: Pengajaran Kimia, Pengajaran Matematika)
-- 5080818001 S2 Sains Laboratorium Klinis: S2 Sains Laboratorium Klinis tidak tercantum di Lampiran I; kemungkinan digantikan "Sains Teknologi Laboratorium Medik" (#516) - belum ada bukti eksplisit
-- 5080818002 S2 Sains Laboratorium Medis: S2 Sains Laboratorium Medis tidak tercantum di Lampiran I; kemungkinan digantikan "Sains Teknologi Laboratorium Medik" (#516) - belum ada bukti eksplisit
-- UPDATE public.ms_nomenklatur SET deleted_at = now(), soft_delete = '1', updated_at = now()
--  WHERE kode_prodi IN ('5030418012', '5130116004', '5160116016', '5050118029', '5080818001', '5080818002')
--    AND kode_prodi NOT IN (SELECT kode_prodi FROM public.tr_ajuan WHERE kode_prodi IS NOT NULL);

COMMIT;

-- 5. Pemeriksaan setelah COMMIT (hanya membaca); angka bila data server sama dengan dump:
-- SELECT count(*) FROM public.ms_nomenklatur;  -- 1900
-- SELECT jenis_pendidikan_id, program_id, id_jenj_didik, count(*) FROM public.ms_nomenklatur GROUP BY 1, 2, 3 ORDER BY 1, 2;
--   -- 1 S1 30: 388 | 1 S2 35: 598 | 1 S3 40: 416 | 2 Profesi 25: 4 | 3 D3 22: 256 | 3 D4 23: 238
-- SELECT kode_pendidikan, nama_jns_pendidikan FROM public.ms_jns_pendidikan ORDER BY 1;  -- 1, 2, dan 3 = Pendidikan Vokasi
-- SELECT lower(trim(name_prodi)), program_id FROM public.ms_nomenklatur GROUP BY 1, 2 HAVING count(*) > 1;  -- tidak ada baris
