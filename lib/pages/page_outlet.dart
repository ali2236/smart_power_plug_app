import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:custom_smart_power_plug_app/pages/page_outlet_charts.dart';
import 'package:custom_smart_power_plug_app/pages/page_outlet_home.dart';
import 'package:custom_smart_power_plug_app/pages/page_outlet_info.dart';
import 'package:custom_smart_power_plug_app/pages/page_outlet_schedules.dart';
import 'package:flutter/material.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

class OutletPage extends StatefulWidget {
  final Device device;

  const OutletPage({Key? key, required this.device}) : super(key: key);

  @override
  State<OutletPage> createState() => _OutletPageState();
}

class _OutletPageState extends State<OutletPage> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        (ctx) => OutletHomePage(device: widget.device),
        (ctx) => OutletChartsPage(device: widget.device),
        (ctx) => OutletSchedulesPage(device: widget.device),
        (ctx) => OutletInfoPage(device: widget.device),
      ][_index](context),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (newIndex) {
          setState(() {
            _index = newIndex;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_rounded),
            label: context.strings.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_rounded),
            label: context.strings.charts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.alarm_rounded),
            label: context.strings.schedules,
          ),
          NavigationDestination(
            icon: const Icon(Icons.info_outline),
            label: context.strings.info,
          ),
        ],
      ),
    );
  }
}
