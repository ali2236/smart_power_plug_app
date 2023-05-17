import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:custom_smart_power_plug_app/pages/page_outlet_scheduler_new.dart';
import 'package:custom_smart_power_plug_app/services/service_schedules.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_bar_loading.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_weekdays_edit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class OutletSchedulesPage extends StatelessWidget {
  final Device device;

  const OutletSchedulesPage({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final schedulesService = GetIt.I.get<SchedulesService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.schedules),
        bottom: const LoadingBar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => schedulesService.syncSchedules(device),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              final task = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return NewOutletSchedulePage(device: device);
              }));
              if (task != null) {
                schedulesService.addSchedule(device, task);
              }
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: schedulesService,
        builder: (context, _) {
          final schedules = schedulesService.getSchedules(device);
          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, i) {
              final schedule = schedules[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            schedule.name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Spacer(),
                          PopupMenuButton<void Function()>(
                            child: const Icon(Icons.more_horiz_rounded),
                            onSelected: (func) => func(),
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete_rounded),
                                      const SizedBox(width: 16),
                                      Text(context.strings.delete),
                                    ],
                                  ),
                                  value: () => schedulesService
                                      .removeSchedule(device, schedule),
                                ),
                              ];
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(schedule.time),
                          const Spacer(),
                          Text(
                            schedule.power
                                ? context.strings.on
                                : context.strings.off,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      WeekdaysEdit(
                        weekDays: schedule.weekDays,
                        onTap: (_, __) {},
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
