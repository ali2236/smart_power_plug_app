import 'package:custom_smart_power_plug_app/models/timeseries_device_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class OutletTimeSeries extends StatefulWidget {
  final Device device;
  final Widget Function(BuildContext context, TimeSeriesOutletData data)
      builder;

  const OutletTimeSeries(
      {Key? key, required this.device, required this.builder})
      : super(key: key);

  @override
  State<OutletTimeSeries> createState() => _OutletTimeSeriesState();
}

class _OutletTimeSeriesState extends State<OutletTimeSeries> {
  late final TelemetrySubscriber subscriber1;
  late final TelemetrySubscriber subscriber2;
  late final TimeSeriesOutletData data;

  @override
  void initState() {
    super.initState();
    data = TimeSeriesOutletData(widget.device);
    final client = GetIt.I.get<ThingsboardClient>();
    subscriber1 = TelemetrySubscriber.createEntityAttributesSubscription(
      telemetryService: client.getTelemetryService(),
      entityId: widget.device.id!,
      attributeScope: AttributeScope.CLIENT_SCOPE.toShortString(),
    );
    subscriber2 = TelemetrySubscriber.createEntityAttributesSubscription(
      telemetryService: client.getTelemetryService(),
      entityId: widget.device.id!,
      attributeScope: LatestTelemetry.LATEST_TELEMETRY.toShortString(),
    );
    subscriber1.attributeDataStream.forEach((newData) {
      if (newData.isNotEmpty) {
        data.add(newData);
      }
    });
    subscriber2.attributeDataStream.forEach((newData) {
      if (newData.isNotEmpty) {
        data.add(newData);
      }
    });
    subscriber1.subscribe();
    subscriber2.subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, data);
  }

  @override
  void dispose() {
    subscriber1.unsubscribe();
    subscriber2.unsubscribe();
    super.dispose();
  }
}
