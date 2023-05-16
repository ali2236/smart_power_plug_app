import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:custom_smart_power_plug_app/pages/page_outlet.dart';
import 'package:custom_smart_power_plug_app/services/service_devices.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devicesService = GetIt.I.get<DevicesService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.powerOutlets),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.pushNamed(context, '/add-device'),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: devicesService,
        builder: (context, _) {
          final devices = devicesService.devices;
          return ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, i) {
                final device = devices[i];
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text(device.id?.id ?? ''),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return OutletPage(device: device);
                    }));
                  },
                  trailing: PopupMenuButton<void Function()>(
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
                          value: () => devicesService.removeDevice(device),
                        ),
                      ];
                    },
                  ),
                );
              });
        },
      ),
    );
  }
}
