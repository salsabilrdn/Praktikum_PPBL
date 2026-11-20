# Siaga Nusantara

Tugas Praktikum Modul 8, Soal 1. Aplikasi Flutter menyimpan pembacaan sensor AIoT
ke SQLite, membaca riwayat, mengoreksi nilai, dan menghapus satu pembacaan.
Data praktikum dapat dimasukkan manual atau dibuat dengan tombol simulasi.

## Menjalankan

Jalankan terminal di folder proyek ini:

```powershell
flutter pub get
flutter devices
flutter run -d emulator-5554
```

Sesuaikan ID perangkat dengan keluaran `flutter devices`. Untuk Windows gunakan
`flutter run -d windows`. Untuk Chrome gunakan:

```powershell
flutter run -d chrome --web-port 8081
```

Gunakan port dan profil browser yang sama supaya penyimpanan web tetap terbaca.
Android memakai berkas SQLite native; web memakai SQLite WebAssembly dengan
IndexedDB. Penyimpanan antarplatform terpisah. Android dapat menjalankan seluruh
CRUD tanpa internet setelah aplikasi terpasang.

## Struktur kode

```text
lib/
  main.dart                         titik masuk dan inisialisasi platform
  app.dart                          provider database, Cubit, MaterialApp
  models/
    pembacaan_sensor.dart           enum sensor, model, toMap, fromMap
    status_siaga.dart               status dari data terbaru per jenis
  db/
    database_config.dart            factory SQLite Android, Windows, web
    database_helper.dart            singleton, CREATE TABLE, seluruh CRUD
  cubit/
    sensor_cubit.dart               pembaruan dashboard setelah penyimpanan
    theme_cubit.dart                pergantian tema terang dan gelap
  pages/
    halaman_dashboard.dart          pemantauan terbaru dan input data
    halaman_riwayat_sensor.dart      FutureBuilder, ListView, edit, Dismissible
  theme/app_theme.dart              tema terpusat
  widgets/
    sensor_card.dart                 kartu pemantauan
    status_badge.dart                indikator status
    theme_toggle_button.dart         tombol tema
    form_pembacaan.dart              input dan validasi pembacaan baru
    dialog_koreksi.dart              validasi koreksi nilai
test/
  database_test.dart                 CRUD, ID, urutan, persistensi, status
  widget_test.dart                   validasi, input desimal, tema, riwayat
docs/
  PANDUAN_PRAKTIKUM.md               urutan pembuatan dan penjelasan kode
  bukti/                            screenshot pengujian emulator
```

## Aturan status praktikum

| Jenis | Aman | Waspada | Siaga |
| --- | --- | --- | --- |
| Ketinggian air | < 100 cm | 100 sampai < 200 cm | >= 200 cm |
| Pergeseran tanah | < 5 mm | 5 sampai < 10 mm | >= 10 mm |
| Curah hujan | < 50 mm/jam | 50 sampai < 100 mm/jam | >= 100 mm/jam |

Ambang adalah contoh simulasi praktikum. Status AppBar Riwayat memakai nilai
terbaru per jenis sensor dari query SQLite, lalu mengambil tingkat tertinggi.
Pembacaan lama yang lebih berbahaya tidak mengalahkan pembacaan terbaru untuk
jenis yang sama. Database kosong ditandai `Belum ada data`.

Waktu disimpan sebagai timestamp UTC dalam milidetik. Riwayat diurutkan dengan
`waktu DESC, id DESC`; tampilan waktu mengikuti zona perangkat. Koreksi hanya
mengubah nilai, sehingga ID, jenis, pos, dan waktu pengukuran tetap sama.

## Pengujian

```powershell
flutter analyze
flutter test
flutter build apk --debug
flutter build web
```

Database test menggunakan folder sementara yang terpisah dari database aplikasi.
Saat menguji persistensi, tutup paksa lalu buka ulang tanpa menghapus data aplikasi.
SQLite web membutuhkan `web/sqflite_sw.js` dan `web/sqlite3.wasm`, yang sudah tersedia.
Sesudah memperbarui dependensi SQLite, buat ulang kedua berkas dengan:

```powershell
dart run sqflite_common_ffi_web:setup --force
```

## Referensi

- [sqflite](https://pub.dev/packages/sqflite)
- [SQLite web](https://pub.dev/packages/sqflite_common_ffi_web)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
