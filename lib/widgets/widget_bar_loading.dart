import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:custom_smart_power_plug_app/services/service_loading.dart';

class LoadingBar extends StatelessWidget implements PreferredSizeWidget {
  const LoadingBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ls = GetIt.I.get<LoadingService>();
    return AnimatedBuilder(
        animation: ls,
        builder: (context, _) {
          if (ls.loading) {
            return const LinearProgressIndicator();
          } else {
            return Container();
          }
        });
  }

  @override
  Size get preferredSize => const Size.fromHeight(8);
}
