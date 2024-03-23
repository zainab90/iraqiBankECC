import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:iraq_bank/controller/textstyle.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easy_permission/easy_permissions.dart';
import 'package:flutter_scankit/flutter_scankit.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iraq_bank/ECC_AES/decrypt.dart';
import 'package:iraq_bank/widget/drawerr.dart';
import 'package:local_session_timeout/src/session_timeout_manager.dart';
import 'package:iraq_bank/widget/icon_button_mode.dart';




const _permissions = [Permissions.READ_EXTERNAL_STORAGE, Permissions.CAMERA];

const _permissionGroup = [PermissionGroup.Camera, PermissionGroup.Photos];

class BarcodeScaning extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;

  const BarcodeScaning({
    required this.sessionStateStream,
    super.key,
  });

  @override
  _BarcodeScaningState createState() => _BarcodeScaningState();
}

class _BarcodeScaningState extends State<BarcodeScaning> {
  late FlutterScankit scanKit;

  String email = "";
  String account = "";

  @override
  void initState() {
    super.initState();
    scanKit = FlutterScankit();
    scanKit.addResultListen((val) {
      decryptQRCode(val);
    });
  }

  @override
  void dispose() {
    scanKit.dispose();
    super.dispose();
  }

  Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> scanImageForQRCode(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);

    try {
      final List<Barcode> barcodes =
      await barcodeScanner.processImage(inputImage);
      for (final barcode in barcodes) {
        print('QR Code Data: ${barcode.rawValue}');
        decryptQRCode(barcode.rawValue!);
      }
    } catch (e) {
      print('Error scanning QR code: $e');
    }

    barcodeScanner.close();
  }

  void scanQRCodeFromPic() async {
    File? pickedImage = await pickImageFromGallery();
    if (pickedImage != null) {
      await scanImageForQRCode(pickedImage);
    } else {
      // Handle the case where no image was picked
      print("No image was picked.");
    }
  }

  void decryptQRCode(String qrValue) async {
print("satrt decryption here==========================");
final decryptStopwatch = Stopwatch()..start();
    List<String> values = qrValue.split(',');
    print('value 0 : ${values[0]}');
    print('value 1 : ${values[1]}');
    String? encryptEmail;
    String? encryptAccount;

    /// Decrypt AES 192-BIT
    //  encryptEmail = Decryption().decryptAES192(base64EncryptedData: values[0]);
    // encryptAccount = Decryption().decryptAES192(base64EncryptedData: values[1]);

    /// Decrypt ECC 384-BIT
    // encryptEmail = Decryption().decryptECC384(base64EncryptedData: values[0]);
    // encryptAccount = Decryption().decryptECC384(base64EncryptedData: values[1]);

    // Decrypt Hybrid AEC-ECC
    encryptEmail = Decryption().hybridDecrypt(base64EncryptedData: values[0]);
    encryptAccount = Decryption().hybridDecrypt(base64EncryptedData: values[1]);

    if (encryptEmail != null && encryptAccount != null) {
      email = encryptEmail;
      //account = encryptAccount;
    }
    else
      {
        email="";
      }

    if (encryptAccount != null) {
      account = encryptAccount;
    }
    else{
      account="";
    }

decryptStopwatch.stop();
print('Decryption time: ${decryptStopwatch.elapsedMilliseconds} ms ===============================');

    setState(() {});
  }

  Future<void> startScan() async {

    final scanStopwatch = Stopwatch()..start();
    try {
      await scanKit.startScan(scanTypes: [ScanTypes.ALL]);
    } on PlatformException {}
    scanStopwatch.stop();

    print('Scan time is : ${scanStopwatch.elapsedMilliseconds} ms   =================');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'صفحة فك تشفير البيانات',
          style: CustomTextStyle.f20b,
        ),
        centerTitle: true,
        actions: const [IconButtonn()],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'البيانات التي تم فك تشفيرها',
              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w800),
            ),
            Container(height: 300.0,
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey[300],
              ),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(email, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 24.0)),
                      const SizedBox(height: 20),
                      Text(account,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 24.0)),
                    ],
                  ),
                ),
              ),),

            const SizedBox(height: 30),
                      ElevatedButton(
              child: const Text("QR Code مسح"),
              onPressed: () async {
                if (!await FlutterEasyPermission.has(
                  perms: _permissions,
                  permsGroup: _permissionGroup,
                )) {
                  FlutterEasyPermission.request(
                    perms: _permissions,
                    permsGroup: _permissionGroup,
                  );
                  if (!await FlutterEasyPermission.has(
                    perms: _permissions,
                    permsGroup: _permissionGroup,
                  )) {
                    startScan();
                  }
                } else {
                  startScan();
                }
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text("QR Code from pic"),
              onPressed: () async {
                if (!await FlutterEasyPermission.has(
                  perms: _permissions,
                  permsGroup: _permissionGroup,
                )) {
                  FlutterEasyPermission.request(
                    perms: _permissions,
                    permsGroup: _permissionGroup,
                  );
                  if (!await FlutterEasyPermission.has(
                    perms: _permissions,
                    permsGroup: _permissionGroup,
                  )) {
                    scanQRCodeFromPic();
                  }
                } else {
                  scanQRCodeFromPic();
                }
              },
            ),
          ],
        ),
      ),
      drawer:  Drawerr(sessionStateStream: widget.sessionStateStream,),

    );
  }
}
