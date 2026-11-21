import 'package:flutter/material.dart';

import '../models/status_siaga.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});
  final StatusSiaga status;
  @override
  Widget build(BuildContext context) {
    final warna = switch (status) {
      StatusSiaga.belumAdaData => const Color(0xFF526675),
      StatusSiaga.aman => const Color(0xFF087F5B),
      StatusSiaga.waspada => const Color(0xFF915800),
      StatusSiaga.siaga => const Color(0xFFB3261E),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status == StatusSiaga.siaga
                ? Icons.warning_amber_rounded
                : Icons.shield_outlined,
            size: 17,
            color: warna,
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(color: warna, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
