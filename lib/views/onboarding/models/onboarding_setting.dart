import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingSetting with ChangeNotifier {
  SharedPreferences? _preferences;
  bool _seenOnboard = false;
  bool get seenOnboard => _seenOnboard;
  void setSeenOnboard() {
    _seenOnboard = !_seenOnboard;
    _saveSettingsToPrefs();
    notifyListeners();
  }
  OnboardingSetting() {
    _loadSettingsFromPrefs();
  }

  _initializePrefs() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  _loadSettingsFromPrefs() async {
    await _initializePrefs();
    _seenOnboard = _preferences?.getBool('darkTheme') ?? false;
    notifyListeners();
  }

  _saveSettingsToPrefs() async {
    await _initializePrefs();
    _preferences?.setBool('darkTheme', _seenOnboard);
  }
}
