import 'pembacaan_sensor.dart';

enum StatusSiaga {
  belumAdaData('Belum ada data'),
  aman('Aman'),
  waspada('Waspada'),
  siaga('Siaga');

  const StatusSiaga(this.label);
  final String label;

  static StatusSiaga untuk(PembacaanSensor data) {
    if (data.nilai >= data.jenisSensor.batasSiaga) return siaga;
    if (data.nilai >= data.jenisSensor.batasWaspada) return waspada;
    return aman;
  }

  static StatusSiaga dariPembacaan(List<PembacaanSensor> daftar) {
    final terbaru = <JenisSensor, PembacaanSensor>{};
    for (final data in daftar) {
      final lama = terbaru[data.jenisSensor];
      if (lama == null ||
          data.waktu.isAfter(lama.waktu) ||
          (data.waktu.isAtSameMomentAs(lama.waktu) &&
              (data.id ?? 0) > (lama.id ?? 0))) {
        terbaru[data.jenisSensor] = data;
      }
    }
    return terbaru.values.fold(belumAdaData, (status, data) {
      final hasil = untuk(data);
      return hasil.index > status.index ? hasil : status;
    });
  }
}
