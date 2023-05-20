import 'package:custom_smart_power_plug_app/l10n/strings.dart';
import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.strings.noData),
    );
  }
}
