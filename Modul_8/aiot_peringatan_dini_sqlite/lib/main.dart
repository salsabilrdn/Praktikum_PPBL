import 'package:flutter/material.dart';

import 'app.dart';
import 'db/database_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inisialisasiDatabase();
  runApp(const AiotApp());
}
