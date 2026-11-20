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

class PembacaanSensor {
  const PembacaanSensor({
    this.id,
    required this.jenisSensor,
    required this.nilai,
    required this.lokasiPos,
    required this.waktu,
  });
  final int? id;
  final JenisSensor jenisSensor;
  final double nilai;
  final String lokasiPos;
  final DateTime waktu;

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'jenis_sensor': jenisSensor.kode,
    'nilai': nilai,
    'lokasi_pos': lokasiPos.trim(),
    'waktu': waktu.toUtc().millisecondsSinceEpoch,
  };
  factory PembacaanSensor.fromMap(Map<String, Object?> map) => PembacaanSensor(
    id: map['id'] as int,
    jenisSensor: JenisSensor.dariKode(map['jenis_sensor'] as String),
    nilai: (map['nilai'] as num).toDouble(),
    lokasiPos: map['lokasi_pos'] as String,
    waktu: DateTime.fromMillisecondsSinceEpoch(
      map['waktu'] as int,
      isUtc: true,
    ),
  );

  String get nilaiTampilan => nilai == nilai.roundToDouble()
      ? nilai.toInt().toString()
      : nilai.toString();
  String get waktuTampilan {
    final lokal = waktu.toLocal();
    String dua(int angka) => angka.toString().padLeft(2, '0');
    return '${dua(lokal.day)}/${dua(lokal.month)}/${lokal.year} '
        '${dua(lokal.hour)}:${dua(lokal.minute)}:${dua(lokal.second)}';
  }
}
