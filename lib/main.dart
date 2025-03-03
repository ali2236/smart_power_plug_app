import 'package:custom_smart_power_plug_app/app.dart';
import 'package:custom_smart_power_plug_app/services/service_devices.dart';
import 'package:custom_smart_power_plug_app/services/service_loading.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(null);

  getIt
    ..registerSingleton(ThingsboardClient('https://thingspod.com'))
    ..registerSingleton(LoadingService())
    ..registerSingleton(DevicesService());

  await getIt.get<ThingsboardClient>().login(
    LoginRequest(String.fromEnvironment("username"), String.fromEnvironment("password")),
  );
  await getIt.get<DevicesService>().init();

  runApp(const MyApp());
}

