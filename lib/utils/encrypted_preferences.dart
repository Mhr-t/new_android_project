import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptedPreferences {
  static final _storage = FlutterSecureStorage();

  static Future<void> writeValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> readValue(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> deleteValue(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
