import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:custom_smart_power_plug_app/models/extension_device.dart';
import 'package:custom_smart_power_plug_app/models/timeseries_device_data.dart';
import 'package:custom_smart_power_plug_app/services/service_loading.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_bar_loading.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_device_telemetry.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_no_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

enum _DisplayData {
  amp,
  watt,
  volt;

  String get sign {
    switch (this) {
      case _DisplayData.amp:
        return 'A';
      case _DisplayData.volt:
        return 'V';
      case _DisplayData.watt:
        return 'W';
    }
  }
}

class OutletHomePage extends StatelessWidget {
  final Device device;
  final TimeSeriesOutletData timeSeries;

  const OutletHomePage({
    Key? key,
    required this.device,
    required this.timeSeries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selected = ValueNotifier(_DisplayData.watt);
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        bottom: const LoadingBar(),
      ),
      body: AnimatedBuilder(
        animation: timeSeries,
        builder: (context, _) {
          if (!timeSeries.hasData) {
            return const NoData();
          }
          final dataSelector = {
            _DisplayData.watt: timeSeries.watt,
            _DisplayData.amp: timeSeries.current,
            _DisplayData.volt: timeSeries.voltage,
          };
          return ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer),
                child: AnimatedBuilder(
                  animation: selected,
                  builder: (context, _) {
                    return SizedBox(
                      height: 360,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              context.strings.realtime,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '${dataSelector[selected.value]} ${selected.value.sign}',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var d in _DisplayData.values)
                                  selected.value == d
                                      ? Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: FilledButton(
                                            child: Text(d.name),
                                            onPressed: () => selected.value = d,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ElevatedButton(
                                            child: Text(d.name),
                                            onPressed: () => selected.value = d,
                                          ),
                                        ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SwitchListTile(
                title: Text(context.strings.power),
                value: timeSeries.power,
                onChanged: (bool value) {
                  GetIt.I
                      .get<LoadingService>()
                      .addTask(task: device.setPower(value));
                },
              ),
              ListTile(
                title: Text(context.strings.maxCurrent),
              ),
            ],
          );
        },
      ),
    );
  }
}
