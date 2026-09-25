import 'package:flutter/material.dart';

class PenghitungSuka extends StatefulWidget {
  const PenghitungSuka({super.key});

  @override
  State<PenghitungSuka> createState() => _PenghitungSukaState();
}

class _PenghitungSukaState extends State<PenghitungSuka> {
  int _jumlahSuka = 0;
  bool _disukai = false;

  void _tambahSuka() {
    setState(() {
      _jumlahSuka++;
      _disukai = true;
    });
  }

  void _reset() {
    setState(() {
      _jumlahSuka = 0;
      _disukai = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              _disukai ? Icons.favorite : Icons.favorite_border,
              size: 40,
              color: Colors.red,
            ),
            const SizedBox(height: 8),
            Text(
              '$_jumlahSuka Suka',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _tambahSuka,
                  child: const Text('Suka'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
