import 'dart:convert';

import 'package:custom_smart_power_plug_app/models/device_data.dart';
import 'package:custom_smart_power_plug_app/models/scheduled_task.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class TimeSeriesOutletData with ChangeNotifier implements OutletData {
  final Device device;
  final List<OutletData> _data = [];
  bool _power = false;
  double _maxCurrent = 10.0;
  List<OutletScheduledTask> _schedules = [];

  TimeSeriesOutletData(this.device);

  void add(List<AttributeData> newData) {
    final labels = newData.map((ad) => ad.key);
    // client attr
    if (labels.contains('max_current')) {
      final maxCurrentRaw =
          newData.firstWhere((at) => at.key == "max_current").value;
      _maxCurrent = double.parse(maxCurrentRaw);
    }
    if (labels.contains('schedules')) {
      final schedulesRaw =
          newData.firstWhere((at) => at.key == "schedules").value;
      final schedulesJson =
          jsonDecode(schedulesRaw) as List;
      _schedules = schedulesJson.cast<Map<String, dynamic>>().map(OutletScheduledTask.fromJson).toList();
    }
    if (labels.contains('power')) {
      final powerRaw = newData
          .firstWhere(
            (at) => at.key == 'power',
            orElse: () => AttributeData(
                key: 'power', value: hasData ? this.power.toString() : 'false'),
          )
          .value;
      final power = powerRaw == 'true';
      _power = power;
    }

    if (labels.contains('current')) {
      final watt =
          double.parse(newData.firstWhere((at) => at.key == 'wattage').value);
      final amp =
          double.parse(newData.firstWhere((at) => at.key == 'current').value);
      final volt =
          double.parse(newData.firstWhere((at) => at.key == 'voltage').value);
      final ts = newData.firstWhere((at) => at.key == 'current').lastUpdateTs!;
      _data.add(OutletData(ts, watt, amp, volt));
      while (_data.length > 80) {
        _data.removeAt(0);
      }
      _data.sort((a,b) => a.ts.compareTo(b.ts));
    }

    notifyListeners();
  }

  bool get hasData => _data.isNotEmpty;

  OutletData get last => _data.last;

  bool get power => _power;

  double get maxCurrent => _maxCurrent;

  List<OutletScheduledTask> get schedules => List.unmodifiable(_schedules);

  @override
  double get current => last.current;

  @override
  double get voltage => last.voltage;

  @override
  double get watt => last.watt;

  @override
  int get ts => last.ts;

  List<FlSpot> get wattTimeSeries =>
      _data.map((e) => FlSpot(e.ts.toDouble(), e.watt)).toList();

  List<FlSpot> get voltTimeSeries =>
      _data.map((e) => FlSpot(e.ts.toDouble(), e.voltage)).toList();

  List<FlSpot> get currentTimeSeries =>
      _data.map((e) => FlSpot(e.ts.toDouble(), e.current)).toList();
}
