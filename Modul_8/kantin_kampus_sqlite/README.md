# Kantin Kampus SQLite

Praktikum Pekan 8: menyimpan checkout ke SQLite dan menampilkan riwayat pesanan.

## Menjalankan aplikasi

Jalankan perintah berikut dari folder `kantin_kampus_sqlite`:

```powershell
flutter pub get
flutter run -d chrome --web-port 8080
```

Gunakan browser dan port yang sama saat menjalankan ulang agar riwayat web tetap
terbaca. Database web tersimpan di IndexedDB browser; penyimpanan Chrome, Edge,
dan aplikasi Windows terpisah.

Untuk menjalankan di Windows:

```powershell
flutter run -d windows
```

SQLite web menggunakan `databaseFactoryFfiWeb` dan membutuhkan
`web/sqlite3.wasm` serta `web/sqflite_sw.js`. Kedua berkas sudah disiapkan.
Setelah memperbarui paket SQLite, buat ulang berkas pendukung sebelum build web:

```powershell
dart run sqflite_common_ffi_web:setup --force
```

Setelah mengubah inisialisasi database atau dependensi, hentikan aplikasi lalu
jalankan ulang dengan `flutter run`.

## Pemeriksaan

```powershell
flutter analyze
flutter test
flutter build web
```

Widget test memeriksa checkout, tampilan riwayat, dan data setelah database dibuka
ulang menggunakan database sementara yang terpisah dari database aplikasi.
