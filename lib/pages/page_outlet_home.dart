import 'package:custom_smart_power_plug_app/widgets/widget_device_telemetry.dart';
import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class OutletHomePage extends StatelessWidget {
  final Device device;
  const OutletHomePage({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DeviceTelemetry(
        device: device,
        builder: (context, data) => ListView(
          children: [
            for (var attr in data)
              ListTile(
                title: Text(attr.key),
                trailing: Text(attr.value.toString()),
              ),
          ],
        ),
      ),
    );
  }
}
