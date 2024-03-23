import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:asn1lib/asn1lib.dart';
import 'package:encrypt/encrypt.dart' as encrypt_package;

class Encryption {
  /// Encrypt AES 192-BIT
  String? encryptAES192({
    required String data,
  }) {
    try {
      final keyBytes = Uint8List(24); // 192 bits
      final iv = Uint8List(16); // AES block size is 128 bits

      Uint8List encryptedData = encryptAES192File(data, keyBytes, iv);

      return base64Encode(encryptedData);
    } catch (error) {
      print(error.toString());
    }
    return null;
  }

  Uint8List encryptAES192File(
    String data,
    Uint8List keyBytes,
    Uint8List iv,
  ) {
    final cipher = PaddedBlockCipher('AES/CBC/PKCS7')
      ..init(
        true,
        PaddedBlockCipherParameters(
            ParametersWithIV(KeyParameter(keyBytes), iv), null),
      );

    // Convert your string data to Uint8List using UTF8 encoding
    final inputAsUint8List = Uint8List.fromList(utf8.encode(data));
    return cipher.process(inputAsUint8List);
  }

  /// Encrypt ECC 384-BIT
  String? encryptECC384({
    required String data,
  }) {
    try {
      var firstKeyPair = generateKeyPair();
      var firstPublicKey = firstKeyPair.publicKey as ECPublicKey;
      var firstPrivateKey = firstKeyPair.privateKey as ECPrivateKey;

      var secondKeyPair = generateKeyPair();
      var secondPublicKey = secondKeyPair.publicKey as ECPublicKey;
      var secondPrivateKey = secondKeyPair.privateKey as ECPrivateKey;

      var firstSharedKey =
          generateSharedSecret(firstPrivateKey, secondPublicKey);
      var secondSharedKey =
          generateSharedSecret(secondPrivateKey, firstPublicKey);

      // Generate a random IV
      final iv = Uint8List.fromList(
          List<int>.generate(16, (i) => Random.secure().nextInt(256)));

      // Encrypt the message using the shared secret
      final inputAsUint8List = Uint8List.fromList(utf8.encode(data));
      Uint8List encryptedData = encryptMessage(inputAsUint8List, firstSharedKey, iv);
      String dataRawBytes = formatBytesAsString(encryptedData);
      String dataSharedKey = formatBytesAsString(secondSharedKey);
      String dataRawBytesShared = '$dataRawBytes@@@$dataSharedKey';
      return dataRawBytesShared;
    } catch (error) {
      print(error.toString());
    }
    return null;
  }

  AsymmetricKeyPair<PublicKey, PrivateKey> generateKeyPair() {
    var secureRandom = FortunaRandom();
    var random = Random.secure();
    var seeds = List<int>.generate(32, (_) => random.nextInt(255));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    var domainParams = ECDomainParameters('secp384r1');
    var keyParams = ECKeyGeneratorParameters(domainParams);

    var generator = ECKeyGenerator();
    generator.init(ParametersWithRandom(keyParams, secureRandom));

    return generator.generateKeyPair();
  }

  Uint8List bigIntToUint8List(BigInt bigInt) {
    var bytes = (bigInt.bitLength + 7) >> 3;
    var b256 = BigInt.from(256);
    var result = Uint8List(bytes);
    for (var i = 0; i < bytes; i++) {
      result[bytes - i - 1] = (bigInt % b256).toInt();
      bigInt = bigInt >> 8;
    }
    return result;
  }

  Uint8List generateSharedSecret(
      ECPrivateKey privateKey, ECPublicKey publicKey) {
    var agreement = ECDHBasicAgreement();
    agreement.init(privateKey);
    var sharedSecretBigInt = agreement.calculateAgreement(publicKey);
    return bigIntToUint8List(sharedSecretBigInt);
  }

  String publicKeyToBase64(ECPublicKey publicKey) {
    var pubKeyBytes = publicKey.Q!.getEncoded(false);
    var asn1Sequence = ASN1Sequence();
    var asn1Int = ASN1Integer(BigInt.parse('1'));
    var asn1BitString = ASN1BitString(pubKeyBytes);

    asn1Sequence.add(asn1Int);
    asn1Sequence.add(asn1BitString);

    var data = asn1Sequence.encodedBytes;
    return base64Encode(data);
  }

  Uint8List encryptMessage(
      Uint8List plainTextBytes, Uint8List sharedSecret, Uint8List iv) {
    final key = encrypt_package.Key(sharedSecret.sublist(0, 32));
    final encrypter = encrypt_package.Encrypter(
        encrypt_package.AES(key, mode: encrypt_package.AESMode.gcm));

    // Encrypt the bytes
    final encrypted =
        encrypter.encryptBytes(plainTextBytes, iv: encrypt_package.IV(iv));

    // Concatenate IV and encrypted bytes
    return Uint8List.fromList(iv + encrypted.bytes);
  }

// Helper function to format bytes as string (for display purposes)
  String formatBytesAsString(Uint8List bytes) {
    var result =
        bytes.map((b) => '\\x${b.toRadixString(16).padLeft(2, '0')}').join();
    return "b'$result'";
  }

  /// Encrypt Hybrid AEC-ECC
  String? hybridEncrypt({
    required String data,
  }) {
    try {
      // Generate ECC key pairs
      var firstKeyPair = hybridGenerateKeyPair();
      var firstPublicKey = firstKeyPair.publicKey as ECPublicKey;
      var firstPrivateKey = firstKeyPair.privateKey as ECPrivateKey;

      var secondKeyPair = hybridGenerateKeyPair();
      var secondPublicKey = secondKeyPair.publicKey as ECPublicKey;
      var secondPrivateKey = secondKeyPair.privateKey as ECPrivateKey;

      // Generate shared secrets
      var firstSharedKey =
          hybridGenerateSharedSecret(firstPrivateKey, secondPublicKey);
      var secondSharedKey =
          hybridGenerateSharedSecret(secondPrivateKey, firstPublicKey);

      // Generate a random IV
      final iv = Uint8List.fromList(
          List<int>.generate(16, (i) => Random.secure().nextInt(256)));

     // Encrypt the message using the shared secret
      final inputAsUint8List = Uint8List.fromList(utf8.encode(data));
      Uint8List encryptedData = encryptMessage(inputAsUint8List, firstSharedKey, iv);
      String dataRawBytes = formatBytesAsString(encryptedData);
      String dataSharedKey = formatBytesAsString(secondSharedKey);
      print(encryptedData);
      print(secondSharedKey);
      String dataRawBytesShared = '$dataRawBytes@@@$dataSharedKey';
      return dataRawBytesShared;
    } catch (error) {
      print(error.toString());
    }
    return null;
  }

  AsymmetricKeyPair<PublicKey, PrivateKey> hybridGenerateKeyPair() {
    var secureRandom = FortunaRandom();
    var random = Random.secure();
    var seeds = List<int>.generate(32, (_) => random.nextInt(255));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    // Your Requirements 160 BIT
    var domainParams160 = ECDomainParameters('secp160r1');

    // More security but take more time 521 BIT
    var domainParams521 = ECDomainParameters('secp521r1');
    var keyParams = ECKeyGeneratorParameters(domainParams521);

    var generator = ECKeyGenerator();
    generator.init(ParametersWithRandom(keyParams, secureRandom));

    return generator.generateKeyPair();
  }

  Uint8List hybridBigIntToUint8List(BigInt bigInt) {
    var bytes = (bigInt.bitLength + 7) >> 3;
    var b256 = BigInt.from(256);
    var result = Uint8List(bytes);
    for (var i = 0; i < bytes; i++) {
      result[bytes - i - 1] = (bigInt % b256).toInt();
      bigInt = bigInt >> 8;
    }
    return result;
  }

  Uint8List hybridGenerateSharedSecret(
      ECPrivateKey privateKey, ECPublicKey publicKey) {
    var agreement = ECDHBasicAgreement();
    agreement.init(privateKey);
    var sharedSecretBigInt = agreement.calculateAgreement(publicKey);
    return hybridBigIntToUint8List(sharedSecretBigInt);
  }

  String hybridPublicKeyToBase64(ECPublicKey publicKey) {
    var pubKeyBytes = publicKey.Q!.getEncoded(false);
    var asn1Sequence = ASN1Sequence();
    var asn1Int = ASN1Integer(BigInt.parse('1'));
    var asn1BitString = ASN1BitString(pubKeyBytes);

    asn1Sequence.add(asn1Int);
    asn1Sequence.add(asn1BitString);

    var data = asn1Sequence.encodedBytes;
    return base64Encode(data);
  }

  Uint8List hybridEncryptMessage(
      Uint8List plainTextBytes, Uint8List sharedSecret, Uint8List iv) {
    // Use the first 32 bytes of the shared secret as the key
    final key = encrypt_package.Key(sharedSecret.sublist(0, 32));
    final encrypter = encrypt_package.Encrypter(
        encrypt_package.AES(key, mode: encrypt_package.AESMode.gcm));

    // Encrypt the bytes
    final encrypted =
        encrypter.encryptBytes(plainTextBytes, iv: encrypt_package.IV(iv));

    // Concatenate IV and encrypted bytes
    return Uint8List.fromList(iv + encrypted.bytes);
  }
}
