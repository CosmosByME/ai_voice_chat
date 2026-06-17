import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences sharedPreferences;
  LocalStorage({required this.sharedPreferences});

  Future<void> saveString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  String? getString(String key) {
    final value = sharedPreferences.getString(key);
    if (kDebugMode) {
      print(value);
    }
    return value;
  }

  Future<void> removeString(String key) async {
    await sharedPreferences.remove(key);
  }

  Future<void> removeAll() async {
    await sharedPreferences.clear();
  }
}
