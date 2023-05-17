import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_device_telemetry.dart';
import 'package:flutter/material.dart';
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

  const OutletHomePage({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _selected = ValueNotifier(_DisplayData.watt);
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
      ),
      body: DeviceTelemetry(
        device: device,
        builder: (context, data) {
          final powerRaw = data.firstWhere((at) => at.key == 'power').value;
          final power = powerRaw == 'true';
          final watt = data.firstWhere((at) => at.key == 'wattage').value;
          final amp = data.firstWhere((at) => at.key == 'current').value;
          final volt = data.firstWhere((at) => at.key == 'voltage').value;
          final dataSelector = {
            _DisplayData.watt: watt,
            _DisplayData.amp: amp,
            _DisplayData.volt: volt,
          };
          return ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer),
                child: AnimatedBuilder(
                  animation: _selected,
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
                                dataSelector[_selected.value] +
                                    ' ${_selected.value.sign}',
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
                                  _selected.value == d
                                      ? Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: FilledButton(
                                            child: Text(d.name),
                                            onPressed: () =>
                                                _selected.value = d,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ElevatedButton(
                                            child: Text(d.name),
                                            onPressed: () =>
                                                _selected.value = d,
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
                value: power,
                onChanged: (bool value) {
                  // TODO: call rpc method
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
