import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class DevicesService with ChangeNotifier {
  late final Box<Map<String, dynamic>> _store;

  Future<void> init() async {
    _store = await Hive.openBox('devices_v3');
  }

  Future<Device?> checkDevice(String deviceId) {
    return GetIt.I
        .get<ThingsboardClient>()
        .getDeviceService()
        .getDevice(deviceId);
  }

  void addDevice(Device device) {
    _store.add(device.toJson());
    notifyListeners();
  }

  List<Device> get devices => _store.values
      .map(Device.fromJson)
      .toList();

  Future<void> removeDevice(Device device) async {
    final i = devices.indexWhere((d) => d.id?.id == device.id?.id);
    _store.deleteAt(i);
    notifyListeners();
  }
}
