import 'package:encrypt/encrypt.dart';
import 'package:sliit_eats/helpers/keys.dart';

class Crypto {
  static encryptAES(plainText) {
    final key = Key.fromUtf8(Keys.ENCRYPTION_KEY);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted? encrypted = encrypter.encrypt(plainText, iv: iv);
    print(encrypted.base64);
    return encrypted.base64;
  }

  static decryptAES(cipherText) {
    try {
      final key = Key.fromUtf8(Keys.ENCRYPTION_KEY);
      final iv = IV.fromLength(16);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      var decrypted = encrypter.decrypt64(cipherText, iv: iv);
      return decrypted;
    } catch(e) {
      print("Failed to decrypt cipher");
      return "";
    }
  }
}
