# Panduan Tugas Praktikum Modul 8 Soal 1

Proyek sudah berisi seluruh kode. Pelajari file sesuai urutan di bawah, kemudian
jalankan skenario pengujian dan bandingkan hasilnya dengan laporan.

## 1 Persiapan proyek

Untuk membuat ulang dari awal:

```powershell
flutter create aiot_peringatan_dini_sqlite
cd aiot_peringatan_dini_sqlite
flutter pub add flutter_bloc sqflite path sqflite_common_ffi sqflite_common_ffi_web path_provider
```

Paket FFI mendukung Windows dan Chrome. Android memakai sqflite native. Buat
folder models, db, cubit, pages, theme, dan widgets di dalam lib seperti README.

## 2 Model dan tabel

`lib/models/pembacaan_sensor.dart` memuat enum `JenisSensor` serta model
`PembacaanSensor` dengan id, jenisSensor, nilai, lokasiPos, dan waktu.
`toMap()` menyiapkan baris untuk SQLite; `fromMap()` membentuk objek hasil query.

```sql
CREATE TABLE pembacaan_sensor (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  jenis_sensor TEXT NOT NULL CHECK (jenis_sensor IN
    ('ketinggian_air', 'pergeseran_tanah', 'curah_hujan')),
  nilai REAL NOT NULL CHECK (nilai >= 0),
  lokasi_pos TEXT NOT NULL CHECK (length(trim(lokasi_pos)) > 0),
  waktu INTEGER NOT NULL
);
```

REAL mendukung desimal. Waktu adalah timestamp UTC dalam milidetik. ID membedakan
setiap pembacaan, termasuk data dari jenis atau pos yang sama.

## 3 DatabaseHelper singleton

`lib/db/database_helper.dart` memakai konstruktor privat dan satu instance
produksi `DatabaseHelper.instance`. Future koneksi disimpan agar pemanggilan
awal yang bersamaan menunggu pembukaan yang sama. `onCreate` membuat tabel
ketika database pertama dibuka. Konstruktor `untukPengujian` hanya memisahkan
database test dari data aplikasi.

## 4 Operasi CRUD

Empat operasi utama berada pada helper yang sama:

```dart
// Create
return db.insert('pembacaan_sensor', data.toMap());
// Read
final rows = await db.query('pembacaan_sensor', orderBy: 'waktu DESC, id DESC');
// Update
return db.update('pembacaan_sensor', {'nilai': nilai},
  where: 'id = ?', whereArgs: [id]);
// Delete
return db.delete('pembacaan_sensor', where: 'id = ?', whereArgs: [id]);
```

`where` membatasi operasi ke satu ID. Tanpanya, update/delete dapat mengenai
semua baris. `whereArgs` mengikat nilai parameter tanpa merangkainya ke SQL.
Cubit memeriksa jumlah baris yang berubah atau terhapus harus tepat satu.

## 5 Cubit dan alur penyimpanan

`lib/cubit/sensor_cubit.dart` menyimpan data ke SQLite dahulu, kemudian membaca
ulang data terbaru dan jumlah catatan untuk dashboard. `BlocBuilder` merespons
state yang baru. State Cubit merupakan salinan sementara; saat aplikasi dibuka
ulang, data dimuat kembali dari SQLite. Gagal insert tidak menghasilkan data
semu di tampilan. Tombol simulasi juga melalui alur penyimpanan yang sama.

## 6 Tema dan widget custom

`theme/app_theme.dart` mengatur tampilan terpusat. `ThemeCubit` mengganti mode
terang dan gelap. `SensorCard` menampilkan data terbaru, `StatusBadge` menampilkan
status, dan `FormPembacaan` memvalidasi input. Nilai harus hingga dan tidak
negatif; lokasi wajib diisi. Input desimal berkoma seperti 80,5 diterima.
`app.dart` memasang provider database, kedua Cubit, dan tema pada MaterialApp.

## 7 Riwayat, koreksi, dan hapus

`pages/halaman_riwayat_sensor.dart` memakai FutureBuilder dan ListView.builder
untuk menampilkan pembacaan dari yang terbaru. Ikon pensil membuka
`DialogKoreksi`. Geser satu kartu ke kiri, lalu konfirmasi Hapus untuk menghapus
ID tersebut. Setelah perubahan, dashboard dan riwayat membaca ulang SQLite.
Nilai boleh dikoreksi tanpa mengubah jenis, lokasi, atau waktu pengukuran.

## 8 Indikator dari SQLite

`models/status_siaga.dart` memilih pembacaan terbaru per jenis berdasarkan waktu,
lalu ID jika waktunya sama. Setiap nilai dibandingkan dengan ambang simulasi pada
README. Status gabungan mengambil tingkat tertinggi. Riwayat lama tetap bisa
dilihat, tetapi tidak dianggap sebagai nilai terkini.

## 9 Urutan pengujian dan screenshot

| Tahap | Tindakan | Hasil yang diharapkan |
| --- | --- | --- |
| Awal | Buka dashboard baru | 0 catatan, Belum ada data |
| Create | Air 80 cm, Pos Dayeuhkolot | 1 catatan, Aman |
| Create | Hujan 60 mm/jam, Pos Baleendah | 2 catatan, Waspada |
| Create | Tanah 12 mm, Pos Bojongsoang | 3 catatan, Siaga |
| Read | Buka Riwayat Sensor | Tanah, hujan, air; AppBar Siaga |
| Update | Koreksi tanah menjadi 4 mm | Tetap 3 catatan; Waspada |
| Delete | Geser dan hapus hujan | 2 catatan; Aman |
| Persistensi | Matikan jaringan, tutup paksa, buka ulang | Tanah 4 mm dan air 80 cm tetap ada |

Screenshot pengujian disimpan di docs/bukti. Untuk menguji pada HP, jalankan
flutter devices dan pilih ID HP. Tutup paksa aplikasi berbeda dengan menghapus
data aplikasi. Pengujian ini harus mempertahankan penyimpanan aplikasi.

## 10 Bentuk laprak

Pertahankan cover dan praktikum Kantin Kampus. Setelahnya tambahkan G Tugas
Praktikum dengan urutan tujuan, struktur proyek, model/tabel, singleton dan CRUD,
integrasi Cubit, dashboard/riwayat, indikator, serta hasil pengujian. Lanjutkan
analisis singleton, where/whereArgs, Cubit versus SQLite, dan persistensi offline,
kemudian kesimpulan serta lampiran repositori.

Nama pengumpulan: Modul8_707012400067_Salsabila Rahmadina.pdf.
Repositori: https://github.com/salsabilrdn/Praktikum_PPBL.
Tujuan folder kode: Modul_8/aiot_peringatan_dini_sqlite.
