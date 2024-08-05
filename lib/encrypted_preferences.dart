import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class EncryptedPreferences {
  static final EncryptedPreferences _instance = EncryptedPreferences._internal();
  factory EncryptedPreferences() => _instance;
  EncryptedPreferences._internal() {
    _init();
  }

  final _secureStorage = FlutterSecureStorage();
  final String _key = 'my_32_length_secret_key_1234567890abcd'; // Ensure the key is exactly 32 characters long
  late final encrypt.Encrypter _encrypter;
  late final encrypt.IV _iv;

  void _init() {
    final key = encrypt.Key.fromUtf8(_key);
    _iv = encrypt.IV.fromLength(16);
    _encrypter = encrypt.Encrypter(encrypt.AES(key));
  }

  Future<void> saveCustomerData(String firstName, String lastName, String address, String birthday) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('firstName', _encrypt(firstName));
      prefs.setString('lastName', _encrypt(lastName));
      prefs.setString('address', _encrypt(address));
      prefs.setString('birthday', _encrypt(birthday));
      print('Customer data saved');
    } catch (e) {
      print('Error saving customer data: $e');
    }
  }

  Future<Map<String, String>> getCustomerData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('Customer data retrieved from SharedPreferences');
      return {
        'firstName': _decrypt(prefs.getString('firstName') ?? ''),
        'lastName': _decrypt(prefs.getString('lastName') ?? ''),
        'address': _decrypt(prefs.getString('address') ?? ''),
        'birthday': _decrypt(prefs.getString('birthday') ?? ''),
      };
    } catch (e) {
      print('Error getting customer data: $e');
      return {};
    }
  }

  String _encrypt(String text) {
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  String _decrypt(String base64Text) {
    final encrypted = encrypt.Encrypted.from64(base64Text);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}

