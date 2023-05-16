import 'package:thingsboard_client/thingsboard_client.dart';

void main() async {
  final client = ThingsboardClient('https://thingspod.com');
  final loginResponse = await client.login(
    LoginRequest('Ali.gh2236@gmail.com', '14La%0YSh4dg'),
  );
  print(loginResponse);

  final device = await client
      .getDeviceService()
      .getDevice('a3c4be60-deaa-11ed-871f-977f44fb0ae5');
  if (device != null) {
    // http(s)://host:port/api/plugins/telemetry/{entityType}/{entityId}/keys/timeseries
    final subscriber = TelemetrySubscriber.createEntityAttributesSubscription(
      telemetryService: client.getTelemetryService(),
      entityId: device.id!,
      attributeScope: LatestTelemetry.LATEST_TELEMETRY.toShortString(),
    );

    subscriber.attributeDataStream.forEach((ad){
      print(ad);
    });

    subscriber.dataStream.forEach((d) {
      print(d);
    });

    subscriber.subscribe();

    await Future.delayed(Duration(days: 1));
  }
}
