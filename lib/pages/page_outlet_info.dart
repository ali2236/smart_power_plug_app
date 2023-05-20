import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class OutletInfoPage extends StatelessWidget {
  final Device device;
  const OutletInfoPage({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.information),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Device ID'),
            subtitle: Text(device.id?.id ?? '???'),
          ),
          ListTile(
            title: Text(context.strings.name),
            subtitle: Text(device.name),
            trailing: const Icon(Icons.edit_rounded),
          ),
          ListTile(
            title: const Text('Type'),
            subtitle: Text(device.type),
          ),
          ListTile(
            title: const Text('Tenant ID'),
            subtitle: Text(device.tenantId?.id ?? '-'),
          ),
          ListTile(
            title: const Text('Customer ID'),
            subtitle: Text(device.customerId?.id ?? '-'),
          ),
        ],
      ),
    );
  }
}
