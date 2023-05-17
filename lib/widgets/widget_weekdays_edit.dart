import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:custom_smart_power_plug_app/models/scheduled_task.dart';
import 'package:flutter/material.dart';

class WeekdaysEdit extends StatelessWidget {
  final WeekDays weekDays;
  final void Function(int day, bool state) onTap;

  const WeekdaysEdit({
    Key? key,
    required this.weekDays,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final names = [
      context.strings.weekday_1_short,
      context.strings.weekday_2_short,
      context.strings.weekday_3_short,
      context.strings.weekday_4_short,
      context.strings.weekday_5_short,
      context.strings.weekday_6_short,
      context.strings.weekday_7_short,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < 7; i++)
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: () => onTap(i, !weekDays[i]),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: weekDays[i]
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    names[i],
                    style: TextStyle(
                      fontSize: 14,
                      color: weekDays[i]
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
