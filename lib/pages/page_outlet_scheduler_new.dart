import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:custom_smart_power_plug_app/models/scheduled_task.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_weekdays_edit.dart';
import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';
import 'package:uuid/uuid.dart';

class NewOutletSchedulePage extends StatefulWidget {
  final Device device;

  const NewOutletSchedulePage({Key? key, required this.device})
      : super(key: key);

  @override
  State<NewOutletSchedulePage> createState() => _NewOutletSchedulePageState();
}

class _NewOutletSchedulePageState extends State<NewOutletSchedulePage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  var power = false;
  var time = TimeOfDay.now();
  var weekDays = WeekDays.none();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.newX(context.strings.schedule)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: name,
                decoration: InputDecoration(label: Text(context.strings.name)),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return context.strings.required_field;
                  }
                  return null;
                },
              ),
            ),
            SwitchListTile(
              title: Text(context.strings.power),
              value: power,
              onChanged: (value) {
                setState(() {
                  power = value;
                });
              },
            ),
            ListTile(
              title: Text(context.strings.time),
              subtitle: Text(time.format(context)),
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: time,
                ).then((newTime) {
                  if (newTime != null) {
                    setState(() {
                      time = newTime;
                    });
                  }
                });
              },
            ),
            const SizedBox(height: 8),
            WeekdaysEdit(
              weekDays: weekDays,
              onTap: (int day, bool state) {
                setState(() {
                  weekDays[day] = state;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        label: Text(context.strings.add),
        onPressed: () {
          if (formKey.currentState?.validate() ?? false) {
            Navigator.of(context).pop(
              OutletScheduledTask(
                id: const Uuid().v4(),
                deviceId: widget.device.id!.id!,
                name: name.text,
                hour: time.hour,
                minute: time.minute,
                power: power,
                weekDays: weekDays,
              ),
            );
          }
        },
      ),
    );
  }
}
