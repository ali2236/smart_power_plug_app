import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// format: "{"power":true,"weekdays":"1001101","time":"22:30"}"
class OutletScheduledTask {
  final String name;
  final bool power;
  final int hour;
  final int minute;
  final WeekDays weekDays;

  const OutletScheduledTask({
    required this.name,
    required this.hour,
    required this.minute,
    required this.power,
    required this.weekDays,
  });

  factory OutletScheduledTask.fromJson(Map<String, dynamic> json) {
    return OutletScheduledTask(
      name: json['name'],
      hour: json['hour'],
      minute: json['minute'],
      power: json['power'],
      weekDays: WeekDays.parse(json['weekdays']),
    );
  }

  String get time =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'power': power,
      'weekdays': weekDays.toString(),
      "hour": hour,
      "minute": minute,
    };
  }
}

///
/// Starts from saturday
///
class WeekDays with ChangeNotifier {
  final List<bool> _days;

  WeekDays(this._days) : assert(_days.length == 7);

  factory WeekDays.none() {
    return WeekDays(List.generate(7, (i) => false));
  }

  factory WeekDays.parse(String weekDays) {
    return WeekDays(weekDays.characters.map((c) => c == '1').toList());
  }

  factory WeekDays.only(int weekday) {
    final days = WeekDays.none();
    days[weekday] = true;
    return days;
  }

  operator [](int day) => _days[day];

  operator []=(int day, bool state) {
    _days[day] = state;
    notifyListeners();
  }

  @override
  String toString() {
    return _days.map((e) => e ? '1' : '0').join();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekDays &&
          runtimeType == other.runtimeType &&
          listEquals(_days, other._days);

  @override
  int get hashCode => _days.hashCode;
}
