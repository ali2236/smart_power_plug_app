import 'package:custom_smart_power_plug_app/models/extension_device.dart';
import 'package:custom_smart_power_plug_app/models/scheduled_task.dart';
import 'package:custom_smart_power_plug_app/services/service_loading.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class SchedulesService with ChangeNotifier {
  late final Box<Map<String, dynamic>> _store;

  Future<void> init() async {
    _store = await Hive.openBox('schedules');
  }

  void addSchedule(Device device, OutletScheduledTask task) {
    _store.add(task.toJson());
    syncSchedules(device);
    notifyListeners();
  }

  List<OutletScheduledTask> get schedules =>
      _store.values.map(OutletScheduledTask.fromJson).toList();

  List<OutletScheduledTask> getSchedules(Device device) =>
      schedules.where((sch) => sch.deviceId == device.id?.id).toList();

  Future<void> removeSchedule(Device device, OutletScheduledTask task) async {
    final i = schedules.indexWhere((s) => s.id == task.id);
    _store.deleteAt(i);
    syncSchedules(device);
    notifyListeners();
  }

  void syncSchedules(Device device){
    GetIt.I.get<LoadingService>().addTask(
      task: _syncSchedules(device),
      onSuccess: (d) {},
      onFail: (err) {},
    );
  }

  Future<void> _syncSchedules(Device device) {
    final schedules =
        getSchedules(device).map((os) => os.toJson(forDevice: true)).toList();
    return device.setSchedules(schedules);
  }
}
