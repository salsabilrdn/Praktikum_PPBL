import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HalamanKantor extends StatefulWidget {
  const HalamanKantor({super.key});

  @override
  State<HalamanKantor> createState() => _HalamanKantorState();
}

class _HalamanKantorState extends State<HalamanKantor> {
  static const Color navy = Color(0xFF172B4D);

  // Posisi awal peta di Kota Bandung
  static const LatLng posisiAwal = LatLng(-6.9175, 107.6191);

  // Menyiapkan tiga penanda lokasi kantor
  final Set<Marker> penandaKantor = {
    const Marker(
      markerId: MarkerId('kantor1'),
      position: LatLng(-6.9175, 107.6191),
      infoWindow: InfoWindow(
        title: 'Kantor Layanan Pusat',
        snippet: 'Pusat informasi layanan warga',
      ),
    ),
    const Marker(
      markerId: MarkerId('kantor2'),
      position: LatLng(-6.9147, 107.6098),
      infoWindow: InfoWindow(
        title: 'Kantor Layanan Utara',
        snippet: 'Informasi dan pengaduan warga',
      ),
    ),
    const Marker(
      markerId: MarkerId('kantor3'),
      position: LatLng(-6.9300, 107.6100),
      infoWindow: InfoWindow(
        title: 'Kantor Layanan Selatan',
        snippet: 'Pusat bantuan layanan masyarakat',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Kantor'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Temukan lokasi kantor layanan warga di Kota Bandung. '
              'Ketuk penanda pada peta untuk melihat informasi kantor.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: posisiAwal,
                zoom: 12,
              ),
              markers: penandaKantor,
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
