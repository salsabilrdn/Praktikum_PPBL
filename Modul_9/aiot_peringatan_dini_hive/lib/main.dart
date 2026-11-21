import 'package:flutter/material.dart';

import 'app.dart';
import 'helpers/hive_helper.dart';
import 'helpers/pengaturan_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.instance.init();
  await PengaturanHelper.instance.init();
  runApp(const AiotApp());
}
