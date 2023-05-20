import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_device_telemetry.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_no_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class OutletChartsPage extends StatelessWidget {
  final Device device;

  const OutletChartsPage({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wattData = <FlSpot>[];
    final voltData = <FlSpot>[];
    final ampData = <FlSpot>[];
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.charts),
      ),
      body: DeviceTelemetry(
          device: device,
          builder: (context, lastData) {
            if(lastData.isEmpty) return const NoData();
            final watt = lastData.firstWhere((at) => at.key == 'wattage');
            final amp = lastData.firstWhere((at) => at.key == 'current');
            final volt = lastData.firstWhere((at) => at.key == 'voltage');
            final ts = DateTime.now().millisecond.toDouble();
            wattData
                .add(FlSpot(watt.lastUpdateTs?.toDouble() ?? ts, watt.value));
            voltData
                .add(FlSpot(volt.lastUpdateTs?.toDouble() ?? ts, volt.value));
            ampData.add(FlSpot(amp.lastUpdateTs?.toDouble() ?? ts, amp.value));
            return Column(
              children: [
                _OutletChart(data: wattData, name: context.strings.watt),
                _OutletChart(data: ampData, name: context.strings.current),
                _OutletChart(data: voltData, name: context.strings.voltage),
              ],
            );
          }),
    );
  }
}

class _OutletChart extends StatelessWidget {
  final String name;
  final List<FlSpot> data;

  const _OutletChart({Key? key, required this.data, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameWidget: Text(name),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: data,
            )
          ]),
    );
  }
}
