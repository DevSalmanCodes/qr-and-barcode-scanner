import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/models/qr_model.dart';
import 'package:qr_code_scanner/providers/qr_scanner_provider.dart';
import 'package:qr_code_scanner/providers/settings_provider.dart';
import 'package:qr_code_scanner/views/qr_scanner_view.dart';

import 'providers/history_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(QRModelAdapter());
  await Hive.openBox<QRModel>('history');
  await Hive.openBox('settings');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QRCodeScannerProvider()),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (context) => SettingsProvider())
      ],
      child: GetMaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                iconTheme: IconThemeData(color: Colors.white)),
            scaffoldBackgroundColor: Colors.grey.shade900,
            checkboxTheme: CheckboxThemeData(
              fillColor: WidgetStateProperty.all(Colors.blue),
              checkColor: WidgetStateProperty.all(
                Colors.white,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const QRScannerScreen()),
    );
  }
}
