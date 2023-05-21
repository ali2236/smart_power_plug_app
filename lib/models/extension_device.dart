import 'package:get_it/get_it.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

extension DeviceRPC on Device {
  Future<void> callRPC(data) => GetIt.I.get<ThingsboardClient>().post(
        '/api/plugins/rpc/oneway/${id?.id}',
        data: data,
      );

  Future<void> setPower(bool power) => callRPC({
        'method': 'setPower',
        'params': power,
      });

  Future<void> setSchedules(List<Map<String, dynamic>> schedules) => callRPC({
        'method': 'setSchedules',
        'params': schedules,
      });

  Future<void> setMaxCurrent(double maxCurrent) => callRPC({
    'method' : 'setMaxCurrent',
    'params' : maxCurrent,
  });
}
