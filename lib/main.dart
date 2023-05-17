import 'package:custom_smart_power_plug_app/app.dart';
import 'package:custom_smart_power_plug_app/services/service_devices.dart';
import 'package:custom_smart_power_plug_app/services/service_loading.dart';
import 'package:custom_smart_power_plug_app/services/service_schedules.dart';
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
    ..registerSingleton(DevicesService())
    ..registerSingleton(SchedulesService());

  await getIt.get<ThingsboardClient>().login(
    LoginRequest('Ali.gh2236@gmail.com', '14La%0YSh4dg'),
  );
  await getIt.get<DevicesService>().init();
  await getIt.get<SchedulesService>().init();

  runApp(const MyApp());
}

