import 'package:flutter/material.dart';

class LoadingService with ChangeNotifier {
  var _loading = false;

  bool get loading => _loading;

  Future addTask<T>({
    required Future<T> task,
    void Function(T data)? onSuccess,
    void Function(String error)? onFail,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final result = await task;
      if(onSuccess != null) onSuccess(result);
    } catch (e) {
      if(onFail != null) onFail(e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
