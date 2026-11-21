# Kantin Kampus Modul 9

Lanjutan Modul 8: favorit dan catatan disimpan pada Hive, nama pelanggan dan tema pada SharedPreferences, sedangkan checkout/riwayat pesanan tetap memakai SQLite. Empat tab: Produk, Keranjang, Favorit, Pengaturan.

Tekan hati untuk menyimpan favorit, buka Favorit untuk mengedit catatan, lalu geser kartu ke kiri untuk menghapus satu favorit. Menekan hati berulang tidak menggandakan favorit atau mengosongkan catatan. Reset Pengaturan hanya mereset nama dan tema.

ID Android: `com.example.kantin_kampus_modul9` (terpisah dari aplikasi Modul 8).

## Menjalankan

Buka terminal PowerShell di folder proyek yang memuat `pubspec.yaml`.

```powershell
flutter pub get
flutter run -d chrome --web-port 8082
```

Untuk A56, sambungkan USB debugging lalu:

```powershell
flutter devices
flutter run -d RRGYB005FAR
```

Adapter `.g.dart` sudah disertakan. Jika mengubah anotasi model, jalankan:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Paket generator yang sudah diuji: hive_generator 2.0.1 dan build_runner 2.4.13 (lihat pubspec.lock). Generator dapat menampilkan peringatan analyzer lebih lama daripada Dart SDK; generasi adapter tetap berhasil. Tidak perlu mengubah berkas `.g.dart` secara manual.

## Pemeriksaan

```powershell
flutter analyze
flutter test
flutter build apk --release --target-platform android-arm64
flutter build web --no-web-resources-cdn
```

Diuji dengan Flutter 3.47.7 / Dart 3.13.5, Chrome, dan Samsung A56 SM-A566B Android 16. Hasil terperinci ada di `docs/bukti/hasil_chrome.json` dan `hasil_a56.json`; gambar kode ada di `docs/kode`.

Hive Android tersimpan pada direktori aplikasi; Hive web memakai IndexedDB. SharedPreferences web memakai penyimpanan browser. Gunakan browser, profil, dan port yang sama ketika membuktikan persistensi; data Chrome dan data HP memang terpisah. Force-stop atau reload tidak menghapus data. Menghapus data aplikasi, penyimpanan situs, atau uninstall akan menghapus penyimpanan lokal.
