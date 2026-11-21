# Siaga Nusantara Modul 9

Soal 1: riwayat pembacaan sensor memakai Hive, ambang Waspada/Siaga memakai SharedPreferences. Soal 2 tidak dikerjakan sesuai lingkup tugas.

Navigasi bawah memiliki empat tab: **Sensor, Pantauan, Riwayat, dan Pengaturan**. Pantauan menyediakan formulir untuk menyimpan pembacaan langsung ke Hive. IndexedStack mempertahankan draf ketika berpindah tab. Tombol Back dari tab lain kembali ke Sensor.

Revisi navigasi diuji di Chrome dan test widget. APK revisi siap dipasang pada A56. Bukti uji A56 sebelumnya berasal dari versi sebelum penambahan navigasi bawah.

Tambah Pembacaan menerima input manual; Tambah Data Simulasi menyimpan satu pembacaan acak. Riwayat diurutkan terbaru, ikon pensil mengoreksi nilai, geser ke kiri lalu konfirmasi untuk menghapus satu catatan. UUID digunakan sebagai key stabil. Status mengambil tingkat tertinggi dari pembacaan terbaru setiap jenis sensor.

Pengaturan menyediakan enam nilai ambang. Nilai harus hingga, tidak negatif, dan Siaga lebih besar dari Waspada. Enam nilai disimpan sebagai JSON dalam satu key `ambang_batas_v1`; notifier baru diperbarui setelah penulisan berhasil. Reset ambang tidak menghapus riwayat. Angka awal 100/200 cm, 5/10 mm, dan 50/100 mm/jam adalah contoh praktikum.

ID Android: `com.example.aiot_peringatan_dini_hive` (terpisah dari versi SQLite Modul 8).

## Menjalankan

Buka terminal PowerShell di folder proyek yang memuat `pubspec.yaml`.

```powershell
flutter pub get
flutter run -d chrome --web-port 8083
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
