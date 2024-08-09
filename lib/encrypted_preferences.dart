import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A helper class to manage encrypted shared preferences.
class EncryptedPreferences {
  static final _storage = FlutterSecureStorage();

  /// Writes a value to the secure storage.
  static Future<void> writeValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads a value from the secure storage.
  static Future<String?> readValue(String key) async {
    return await _storage.read(key: key);
  }

  /// Deletes a value from the secure storage.
  static Future<void> deleteValue(String key) async {
    await _storage.delete(key: key);
  }

  /// Clears all values from the secure storage.
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
