import 'package:flutter/material.dart';

class ErrorNotification extends Notification {
  final String msg;

  const ErrorNotification(this.msg);
}

class ErrorNotificationHandler extends StatelessWidget {
  final Widget child;

  const ErrorNotificationHandler({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ErrorNotification>(
      child: child,
      onNotification: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.msg),
          ),
        );
        return true;
      },
    );
  }
}
