import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'pembacaan_sensor.g.dart';

enum JenisSensor {
  ketinggianAir('ketinggian_air', 'Ketinggian Air', 'cm', 100, 200),
  pergeseranTanah('pergeseran_tanah', 'Pergeseran Tanah', 'mm', 5, 10),
  curahHujan('curah_hujan', 'Curah Hujan', 'mm/jam', 50, 100);

  const JenisSensor(
    this.kode,
    this.label,
    this.satuan,
    this.batasWaspada,
    this.batasSiaga,
  );
  final String kode;
  final String label;
  final String satuan;
  final double batasWaspada;
  final double batasSiaga;
  static JenisSensor dariKode(String kode) =>
      values.firstWhere((jenis) => jenis.kode == kode);
}

@HiveType(typeId: 0)
class PembacaanSensor extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String jenisKode;
  @HiveField(2)
  double nilai;
  @HiveField(3)
  final String lokasiPos;
  @HiveField(4)
  final DateTime waktu;
  PembacaanSensor({
    String? id,
    JenisSensor? jenisSensor,
    String? jenisKode,
    required this.nilai,
    required this.lokasiPos,
    required this.waktu,
  }) : id = id ?? const Uuid().v4(),
       jenisKode = jenisKode ?? jenisSensor!.kode;
  PembacaanSensor.dariHive(
    this.id,
    this.jenisKode,
    this.nilai,
    this.lokasiPos,
    this.waktu,
  );
  JenisSensor get jenisSensor => JenisSensor.dariKode(jenisKode);
  String get nilaiTampilan => nilai == nilai.roundToDouble()
      ? nilai.toInt().toString()
      : nilai.toString();
  String get waktuTampilan {
    final t = waktu.toLocal();
    String dua(int x) => x.toString().padLeft(2, '0');
    return '${dua(t.day)}/${dua(t.month)}/${t.year} ${dua(t.hour)}:${dua(t.minute)}:${dua(t.second)}';
  }
}
