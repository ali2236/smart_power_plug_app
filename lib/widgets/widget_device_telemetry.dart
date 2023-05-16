import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class DeviceTelemetry extends StatefulWidget {
  final Device device;
  final Widget Function(BuildContext context, List<AttributeData> data) builder;

  const DeviceTelemetry({
    Key? key,
    required this.device,
    required this.builder,
  }) : super(key: key);

  @override
  State<DeviceTelemetry> createState() => _DeviceTelemetryState();
}

class _DeviceTelemetryState extends State<DeviceTelemetry> {
  late final TelemetrySubscriber subscriber;

  @override
  void initState() {
    super.initState();
    final client = GetIt.I.get<ThingsboardClient>();
    subscriber = TelemetrySubscriber.createEntityAttributesSubscription(
      telemetryService: client.getTelemetryService(),
      entityId: widget.device.id!,
      attributeScope: LatestTelemetry.LATEST_TELEMETRY.toShortString(),
    );
    subscriber.subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AttributeData>>(
      stream: subscriber.attributeDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.builder(context, snapshot.data!);
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void dispose() {
    subscriber.unsubscribe();
    super.dispose();
  }
}
