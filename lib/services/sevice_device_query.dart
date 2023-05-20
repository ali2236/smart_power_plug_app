import 'package:get_it/get_it.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class DeviceQuery {
  void query(Device device, String key) {
    final client = GetIt.I.get<ThingsboardClient>();
    client.getAttributeService().getTimeseries(
          device.id!,
          [key],
        );
  }
}
