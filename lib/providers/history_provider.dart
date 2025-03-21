import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_code_scanner/models/qr_model.dart';

class HistoryProvider extends ChangeNotifier {
  List<QRModel> _history = [];
  List<QRModel> get history => _history;
  Box<QRModel>? _historyBox;
  HistoryProvider() {
    _init();
  }
  void _init() async {
    _historyBox = await Hive.openBox('history');

    _history = _historyBox!.values.toList().reversed.toList();
    notifyListeners();
  }

  void addHistory(String value, String image) {
    final timestamp = DateTime.now();
    final newEntry = QRModel(value: value, image: image, timestamp: timestamp);
    _historyBox!.add(newEntry);
    _history.insert(0, newEntry);
    notifyListeners();
  }

  void deleteHistory(int index) {
    _historyBox!.deleteAt(index);
    _history.removeAt(index);
    notifyListeners();
  }
}
