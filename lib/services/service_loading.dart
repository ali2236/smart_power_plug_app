import 'package:flutter/material.dart';

class LoadingService with ChangeNotifier{
  var _loading = false;

  bool get loading => _loading;

  Future addTask<T>({
    required Future<T> task,
    required void Function(T data) onSuccess,
    required void Function(String error) onFail,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final result = await task;
      onSuccess(result);
    } catch (e){
      onFail(e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
