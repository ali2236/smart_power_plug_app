import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:custom_smart_power_plug_app/models/timeseries_device_data.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_device_telemetry.dart';
import 'package:custom_smart_power_plug_app/widgets/widget_no_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class OutletChartsPage extends StatelessWidget {
  final Device device;
  final TimeSeriesOutletData timeSeries;

  const OutletChartsPage({
    Key? key,
    required this.device,
    required this.timeSeries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.charts),
      ),
      body: AnimatedBuilder(
          animation: timeSeries,
          builder: (context, _) {
            if (!timeSeries.hasData) return const NoData();
            return ListView(
              children: [
                _OutletChart(
                  data: timeSeries.wattTimeSeries,
                  name: context.strings.watt,
                  minY: 0.0,
                  maxY: 3000,
                ),
                _OutletChart(
                  data: timeSeries.currentTimeSeries,
                  name: context.strings.current,
                  minY: 0.0,
                  maxY: 20.0,
                ),
                _OutletChart(
                  data: timeSeries.voltTimeSeries,
                  name: context.strings.voltage,
                  minY: 0.0,
                  maxY: 250.0,
                ),
              ],
            );
          }),
    );
  }
}

class _OutletChart extends StatelessWidget {
  final String name;
  final double? minY, maxY;
  final List<FlSpot> data;

  const _OutletChart({
    Key? key,
    required this.data,
    required this.name,
    this.minY,
    this.maxY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(name, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    axisNameWidget: const Text(''),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text(''),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    color: Theme.of(context).colorScheme.primary,
                    spots: data,
                  )
                ],
              ),
              swapAnimationDuration: Duration.zero,
            ),
          ),
        ],
      ),
    );
  }
}
