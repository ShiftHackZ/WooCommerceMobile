import 'package:shared_preferences/shared_preferences.dart';

const _keyGridDisplayEnabled = 'key_grid_display_enabled';

class PreferencesManagerImpl extends PreferencesManager {
  @override
  setGridDisplayEnabled(bool value) => SharedPreferences
      .getInstance()
      .then((p) => p.setBool(_keyGridDisplayEnabled, value));

  @override
  Future<bool> getGridDisplayEnabled() => SharedPreferences
      .getInstance()
      .then((p) => p.getBool(_keyGridDisplayEnabled) ?? true);
}

abstract class PreferencesManager {
  setGridDisplayEnabled(bool value);
  Future<bool> getGridDisplayEnabled();
}
