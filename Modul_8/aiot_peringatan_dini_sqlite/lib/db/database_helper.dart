import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/pembacaan_sensor.dart';

class DatabaseHelper {
  DatabaseHelper._({this._factory, this._path});
  static final DatabaseHelper instance = DatabaseHelper._();
  factory DatabaseHelper.untukPengujian(DatabaseFactory factory, String path) =>
      DatabaseHelper._(factory: factory, path: path);
  final DatabaseFactory? _factory;
  final String? _path;
  Future<Database>? _database;
  Future<Database> get database => _database ??= _bukaDatabase();

  Future<Database> _bukaDatabase() async {
    try {
      final factory = _factory ?? databaseFactory;
      final path =
          _path ?? p.join(await factory.getDatabasesPath(), 'aiot_sensor.db');
      return await factory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
            CREATE TABLE pembacaan_sensor (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              jenis_sensor TEXT NOT NULL CHECK (jenis_sensor IN
                ('ketinggian_air', 'pergeseran_tanah', 'curah_hujan')),
              nilai REAL NOT NULL CHECK (nilai >= 0),
              lokasi_pos TEXT NOT NULL CHECK (length(trim(lokasi_pos)) > 0),
              waktu INTEGER NOT NULL
            )
          ''');
            await db.execute(
              'CREATE INDEX idx_sensor_waktu '
              'ON pembacaan_sensor (jenis_sensor, waktu DESC, id DESC)',
            );
          },
        ),
      );
    } catch (_) {
      _database = null;
      rethrow;
    }
  }

  void _validasiNilai(double nilai) {
    if (!nilai.isFinite || nilai < 0) {
      throw ArgumentError('Nilai harus berupa angka hingga dan tidak negatif.');
    }
  }

  Future<int> tambahPembacaan(PembacaanSensor data) async {
    _validasiNilai(data.nilai);
    if (data.id != null) {
      throw ArgumentError('Pembacaan baru belum memiliki ID.');
    }
    if (data.lokasiPos.trim().isEmpty) {
      throw ArgumentError('Lokasi wajib diisi.');
    }
    final db = await database;
    return db.insert('pembacaan_sensor', data.toMap());
  }

  Future<List<PembacaanSensor>> ambilSemuaPembacaan() async {
    final db = await database;
    final rows = await db.query(
      'pembacaan_sensor',
      orderBy: 'waktu DESC, id DESC',
    );
    return rows.map(PembacaanSensor.fromMap).toList();
  }

  Future<List<PembacaanSensor>> ambilPembacaanTerbaru() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT a.* FROM pembacaan_sensor a
      WHERE NOT EXISTS (
        SELECT 1 FROM pembacaan_sensor b
        WHERE b.jenis_sensor = a.jenis_sensor
          AND (b.waktu > a.waktu OR (b.waktu = a.waktu AND b.id > a.id))
      ) ORDER BY a.waktu DESC, a.id DESC
    ''');
    return rows.map(PembacaanSensor.fromMap).toList();
  }

  Future<int> jumlahPembacaan() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM pembacaan_sensor'),
        ) ??
        0;
  }

  Future<int> ubahNilai(int id, double nilai) async {
    _validasiNilai(nilai);
    final db = await database;
    return db.update(
      'pembacaan_sensor',
      {'nilai': nilai},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> hapusPembacaan(int id) async {
    final db = await database;
    return db.delete('pembacaan_sensor', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> tutup() async {
    final pending = _database;
    _database = null;
    if (pending != null) await (await pending).close();
  }
}
