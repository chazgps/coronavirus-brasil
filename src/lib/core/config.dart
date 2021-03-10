import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static Config _instance = Config._internal();
  static SharedPreferences _prefs;
  static String SINCRONIZAR = 'S';

  factory Config() {
    return _instance;
  }

  Config._internal();

  void _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> getBool(String key) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    bool valor = _prefs.getBool(key);
    valor ??= true;

    return valor;
  }

  void salvarConfiguracao(String key, dynamic value) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      _prefs.setBool(key, value);
    } else if (value is String) {
      _prefs.setString(key, value);
    } else if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is double) {
      _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      _prefs.setStringList(key, value);
    }
  }
}
