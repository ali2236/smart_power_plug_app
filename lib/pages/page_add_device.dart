import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:custom_smart_power_plug_app/services/service_devices.dart';
import 'package:custom_smart_power_plug_app/services/service_loading.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_error.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class AddDevicePage extends StatelessWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceId = TextEditingController(
      text: 'a3c4be60-deaa-11ed-871f-977f44fb0ae5',
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.newX(context.strings.powerOutlet)),
      ),
      body: ErrorNotificationHandler(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: deviceId,
                decoration: InputDecoration(
                  label: Text(context.strings.deviceId),
                  suffixText: context.strings.scan,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    onPressed: () async {
                      final qr = await Navigator.of(context).pushNamed('/qr');
                      if (qr != null && qr is String && qr.isNotEmpty) {
                        deviceId.text = qr;
                      }
                    },
                  ),
                ),
              ),
            ),
            Builder(builder: (context) {
              return FilledButton.icon(
                onPressed: () {
                  GetIt.I.get<LoadingService>().addTask<Device?>(
                        task: GetIt.I
                            .get<DevicesService>()
                            .checkDevice(deviceId.text),
                        onSuccess: (Device? device) {
                          if (device == null) {
                            ErrorNotification(context.strings.invalidDeviceId)
                                .dispatch(context);
                          } else {
                            GetIt.I.get<DevicesService>().addDevice(device);
                            Navigator.pop(context);
                          }
                        },
                        onFail: (String error) {
                          ErrorNotification(context.strings.invalidDeviceId)
                              .dispatch(context);
                        },
                      );
                },
                icon: const Icon(Icons.add_rounded),
                label: Text(context.strings.add),
              );
            })
          ],
        ),
      ),
    );
  }
}
