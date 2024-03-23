import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:encrypt/encrypt.dart' as encrypt_package;




class Decryption {
  /// Decrypt AES 192-BIT
  String? decryptAES192({
    required String base64EncryptedData,
  }) {
    try {
      final keyBytes = Uint8List(24); // 192 bits
      final iv = Uint8List(16); // AES block size is 128 bits

      // Decode the Base64 encrypted data to get the encrypted bytes
      final encryptedData = base64Decode(base64EncryptedData);

      String decryptedData = decryptAES192File(encryptedData, keyBytes, iv);
      return decryptedData;
    } catch (error) {
      print(error.toString());
    }
    return null;
  }

  String decryptAES192File(
    Uint8List encryptedData,
    Uint8List keyBytes,
    Uint8List iv,
  ) {
    final cipher = PaddedBlockCipher('AES/CBC/PKCS7')
      ..init(
        false,
        PaddedBlockCipherParameters(
            ParametersWithIV(KeyParameter(keyBytes), iv), null),
      );
    final decryptedData = cipher.process(encryptedData);
    return utf8.decode(decryptedData);
  }

  /// Decrypt ECC 384-BIT
  String? decryptECC384({
    required String base64EncryptedData,
  }) {
    try {
      final rawBytes = base64EncryptedData.split('@@@')[0];
      final sharedKey = base64EncryptedData.split('@@@')[1];
      final listRawBytes = stringToBytes(rawBytes);
      final listDataShared = stringToBytes(sharedKey);

      Uint8List decryptedMessage =
          decryptECC384Msg(listRawBytes, listDataShared);
      return base64Encode(decryptedMessage);
    } catch (error) {
      print(error.toString());
    }
    return null;
  }

  Uint8List decryptECC384Msg(
      Uint8List cipherTextWithIV, Uint8List sharedSecret) {
    // Extract IV and cipher text
    final iv = encrypt_package.IV(cipherTextWithIV.sublist(0, 16));
    final cipherTextBytes = cipherTextWithIV.sublist(16);

    final key = encrypt_package.Key(sharedSecret.sublist(0, 32));
    final encrypter = encrypt_package.Encrypter(
        encrypt_package.AES(key, mode: encrypt_package.AESMode.gcm));

    // Decrypt the bytes
    List<int> decryptedBytes = encrypter
        .decryptBytes(encrypt_package.Encrypted(cipherTextBytes), iv: iv);

    // Convert List<int> to Uint8List
    return Uint8List.fromList(decryptedBytes);
  }

// Converts a string with byte formatting to a Uint8List
  Uint8List stringToBytes(String formattedString) {
    var hexString = formattedString
        .replaceAll("b'", "") // Remove the "b'" at the beginning
        .replaceAll("\\x", "") // Remove the "\\x" before each byte
        .replaceAll("'", ""); // Remove the closing "'"

    // Ensure the string length is a multiple of 2
    if (hexString.length % 2 != 0) {
      throw const FormatException(
          "The provided string does not have a valid byte format.");
    }

    // Convert the hexadecimal string to bytes
    List<int> bytes = [];
    for (int i = 0; i < hexString.length; i += 2) {
      var byteString = hexString.substring(i, i + 2);
      var byte = int.parse(byteString, radix: 16);
      bytes.add(byte);
    }

    return Uint8List.fromList(bytes);
  }

// Decrypts hybrid AES-ECC encrypted data
  String? hybridDecrypt({
    required String base64EncryptedData,
  }) {
    try {
      final parts = base64EncryptedData.split('@@@');
      final rawBytes = parts[0];
      final sharedKey = parts[1];

      final listRawBytes = stringToBytes(rawBytes);
      final listDataShared = stringToBytes(sharedKey);

      Uint8List decryptedMessage = decryptMessage(listRawBytes, listDataShared);
      // Change here: Directly decode decrypted bytes to string
      String decryptedText = utf8.decode(decryptedMessage);

      return decryptedText; // Return the decrypted text directly
    } catch (error) {
      print(error.toString());
    }
    return null;
  }

// Decrypts the message using AES-GCM
  Uint8List decryptMessage(Uint8List cipherTextWithIV, Uint8List sharedSecret) {
    // Extract IV and cipher text
    final iv = encrypt_package.IV(cipherTextWithIV.sublist(0, 16));
    final cipherTextBytes = cipherTextWithIV.sublist(16);

    // Use the first 32 bytes of the shared secret as the key
    final key = encrypt_package.Key(sharedSecret.sublist(0, 32));
    final encrypter = encrypt_package.Encrypter(
        encrypt_package.AES(key, mode: encrypt_package.AESMode.gcm));

    // Decrypt the bytes
    List<int> decryptedBytes = encrypter
        .decryptBytes(encrypt_package.Encrypted(cipherTextBytes), iv: iv);

    // Convert List<int> to Uint8List
    return Uint8List.fromList(decryptedBytes);
  }
}
