import 'package:custom_smart_power_plug_app/pages/page_add_device.dart';
import 'package:custom_smart_power_plug_app/pages/page_scan_qr.dart';
import 'package:custom_smart_power_plug_app/pages/page_devices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fa'), // Farsi
      ],
      locale: const Locale('en'),
      theme: ThemeData(
        useMaterial3: true,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        )
      ),
      initialRoute: '/',
      routes: {
        '/' : (c) => const DevicesPage(),
        '/add-device' : (c) => const AddDevicePage(),
        '/qr' : (c) => const ScanQRCodePage(),
      },
    );
  }
}