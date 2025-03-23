import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsProvider extends ChangeNotifier {
  Box? _settingsBox;
  SettingsProvider() {
    _init();
  }
  bool? _beep;
  bool? _vibrate;
  bool? get beep => _beep;
  bool? get vibrate => _vibrate;
  void _init() async {
    _settingsBox = await Hive.openBox('settings');
    _beep = _settingsBox?.get('beep') ?? true;
    _vibrate = _settingsBox?.get('vibrate') ?? true;
    notifyListeners();
  }

  void toggleBeep(bool? value) {
    if (value == null) return;
    _putValue('beep', value);
    _beep = value;
    notifyListeners();
  }

  void toggleVibrate(bool? value) {
    if (value == null) return;
    _putValue('vibrate', value);

    _vibrate = value;
    notifyListeners();
  }

  void _putValue(String key, bool value) async {
    await _settingsBox?.put(key, value);
  }
}
