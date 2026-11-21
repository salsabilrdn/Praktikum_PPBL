import 'pembacaan_sensor.dart';
import '../helpers/pengaturan_helper.dart';

enum StatusSiaga {
  belumAdaData('Belum ada data'),
  aman('Aman'),
  waspada('Waspada'),
  siaga('Siaga');

  const StatusSiaga(this.label);
  final String label;

  static StatusSiaga untuk(PembacaanSensor data) {
    if (data.nilai >=
        PengaturanHelper.instance.ambang.value[data.jenisSensor]!.siaga) {
      return siaga;
    }
    if (data.nilai >=
        PengaturanHelper.instance.ambang.value[data.jenisSensor]!.waspada) {
      return waspada;
    }
    return aman;
  }

  static StatusSiaga dariPembacaan(List<PembacaanSensor> daftar) {
    final terbaru = <JenisSensor, PembacaanSensor>{};
    for (final data in daftar) {
      final lama = terbaru[data.jenisSensor];
      if (lama == null ||
          data.waktu.isAfter(lama.waktu) ||
          (data.waktu.isAtSameMomentAs(lama.waktu) &&
              data.id.compareTo(lama.id) > 0)) {
        terbaru[data.jenisSensor] = data;
      }
    }
    return terbaru.values.fold(belumAdaData, (status, data) {
      final hasil = untuk(data);
      return hasil.index > status.index ? hasil : status;
    });
  }
}
