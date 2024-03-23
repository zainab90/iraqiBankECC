import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:iraq_bank/ECC_AES/encrypt.dart';
import 'package:iraq_bank/controller/textstyle.dart';
import 'package:iraq_bank/widget/drawerr.dart';
import 'package:iraq_bank/widget/icon_button_mode.dart';
import 'package:local_session_timeout/src/session_timeout_manager.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class ECC extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;

  const ECC({super.key, required this.sessionStateStream});

  @override
  State<ECC> createState() => _ECCState();
}

class _ECCState extends State<ECC> {
  //------------------------------------------
  TextEditingController acounttext = TextEditingController();
  TextEditingController amounttext = TextEditingController();

  String? cipherTextBankAccount;
  String? cipherTextamount;

//-------------------------------------------------
  bool _isQRGenerated = false;
  bool _isEncryption = false;

  //---------------------------------------------
  String? _qrData;

//save qr functionality
  final controller = ScreenshotController();

  final GlobalKey _globalKey = GlobalKey();

  Future<void> _saveQRToGallery() async {
    try {
      RenderRepaintBoundary boundary =
      _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // Use a scale factor to improve image quality
      ui.Image image = await boundary.toImage(pixelRatio: 5.0); // Adjust the pixelRatio for higher quality
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      await _saveImageToGallery(pngBytes);
    } catch (e) {
      print("Error saving QR code to gallery: $e");
    }
  }


  Future<void> _saveImageToGallery(Uint8List pngBytes) async {
    // Check for storage permissions
    if (!await Permission.storage.request().isGranted) {
      return; // Only proceed if permission was granted
    }

    // Temporary file in the cache directory
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/qr_code.png').create();
    await file.writeAsBytes(pngBytes);

    // Save the file to the gallery
    final bool? isSaved = await GallerySaver.saveImage(file.path, albumName: "QR Codes");

    if (isSaved != null && isSaved) {
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("QR Code saved to gallery")));
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'تم حفظ الصورة بنجاح',
        btnOkOnPress: () {},
      ).show();



    } else {
   //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save QR Code")));

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'عذرا لم يتم حقظ الصورة في الهاتف',
        btnOkOnPress: () {},
      ).show();



    }

    // Optionally, clean up the temporary file
    await file.delete();
  }

  //------------------------------------------ ECC Function and generat QR

  Future<void> encryption() async {
    final encryptStopwatch = Stopwatch()..start();
    String? encryptCipherTextBankAccount;
    String? encryptCipherTextAmount;

    /// Encrypt AES 192-BIT
    // encryptCipherTextBankAccount = Encryption().encryptAES192(data: acounttext.text);
    //  encryptCipherTextAmount = Encryption().encryptAES192(data: amounttext.text);

    /// Encrypt ECC 384-BIT
    // encryptCipherTextBankAccount = Encryption().encryptECC384(data: acounttext.text);
    // encryptCipherTextAmount = Encryption().encryptECC384(data: amounttext.text);

    /// Encrypt Hybrid AEC-ECC
    ///
    encryptCipherTextBankAccount = Encryption().hybridEncrypt(data: acounttext.text);
    encryptCipherTextAmount = Encryption().hybridEncrypt(data: amounttext.text);

    if (encryptCipherTextBankAccount != null &&
        encryptCipherTextAmount != null) {
      cipherTextBankAccount = encryptCipherTextBankAccount;
      cipherTextamount = encryptCipherTextAmount;
    }

    _isEncryption = true;
    setState(() {});
    encryptStopwatch.stop();
    print('Encryption time: ${encryptStopwatch.elapsedMilliseconds} ms');
  }

  //------------------------------------------ QRلتحويل النص المشفر الى
  void qrData() {
    final encryptStopwatch = Stopwatch()..start();
    _qrData = '$cipherTextBankAccount,$cipherTextamount';
    _isQRGenerated = true;
    setState(() {});
    encryptStopwatch.stop();
    print('Generate QR time: ${encryptStopwatch.elapsedMilliseconds} ms');
  }

  //-----------------------------------------
  final timer = Timer(const Duration(milliseconds: 100),
      () => print('Timer finished')); // لقياس زمن تنفيذ الكود
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" تشفير المعلومات المصرفية",    style: CustomTextStyle.f20b,),
        centerTitle: true,
        actions: const [IconButtonn()],
      ),
      body: ListView(
        children: [
          Center(
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 3.6,
                width: MediaQuery.of(context).size.width / 1.8,
                child: _isQRGenerated
                    ?
                Screenshot(
                  controller: controller,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1),
                    ),
                    child: QrImage(
                      data: _qrData.toString(),
                      size: MediaQuery.of(context).size.height / 5,
                    ),
                  ),

                )
                // Center(
                //       child: CustomPaint(
                //           size: Size(
                //             MediaQuery.of(context).size.width / 1.7,
                //             MediaQuery.of(context).size.height / 3.5,
                //           ),
                //           painter: QrPainter(
                //             emptyColor: Colors.white,
                //             data: _qrData!,
                //             version: QrVersions.auto,
                //           ),
                //         ),
                //     )
                    :
                const Center(
                        child: Text(" اضغظ على زر توليد رمز الاستجابة السريعة ",
                            textAlign: TextAlign.center, style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w300
                          ),),
                      ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                // Text(cipherTextBankAccount),
                // Text(cipherTextamount),
                ////////////////////////////////////////////
                TextField(
                  controller: acounttext,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "ادخل رقم الحساب البنكي ",
                    suffixIcon: Icon(Icons.account_balance),
                  ),
                ),
                ////////////////////////////////////////////////
                SizedBox(height: MediaQuery.of(context).size.height / 99),
                TextField(
                  controller: amounttext,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "ادخل قيمة المبلغ",
                    suffixIcon: Icon(Icons.currency_exchange),
                  ),
                ), /////////////////////////////////////////
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 99),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 50, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    encryption();
                    //  ECC Function <<-------------------------->>

                    Get.snackbar(
                      "",
                      "تم تشفير النص بنجاح",
                      duration: const Duration(seconds: 3),
                    );
                  },
                  child: const Text("تشفير", textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 50, left: 50),
            child: ElevatedButton(
              onPressed: () {
                if (cipherTextamount == null) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.rightSlide,
                    title: ' الرجاء قم بتشفير البيانات اولا',
                    btnOkText: 'رجوع',
                    btnOkOnPress: () {
                      acounttext.clear();
                      amounttext.clear();
                    },
                  ).show();
                  return;
                }

                qrData(); //-------------------------------------------Qr Data

                Get.snackbar(
                  "",
                  "تم توليد رمز الاستجابة السريع",
                  duration: const Duration(seconds: 3),
                );
                acounttext.clear();
                amounttext.clear();
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(
                  MediaQuery.of(context).size.width / 1.4,
                  MediaQuery.of(context).size.height / 18,
                ),
              ),
              child: Text(
                _isQRGenerated
                    ? 'تم توليد رمز الاستجابة السريعة '
                    : "اضغظ  لتوليد رمز الاستجابة السريعة",
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, right: 50, left: 50, bottom: 10),
            child: ElevatedButton(
              onPressed: () async {
                _saveQRToGallery();

                // final image = await controller.capture();
                // if (image != null) {
                //   AwesomeDialog(
                //     context: context,
                //     dialogType: DialogType.success,
                //     animType: AnimType.rightSlide,
                //     title: 'تم الحفظ بنجاح',
                //     btnOkOnPress: () {},
                //   ).show();
                //
                //   //++++++++++++++++++++++++++++++++++++++++
                //
                //   _saveQRToGallery(); // --------------------------------------------------- Save Qr Function
                // }
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                MediaQuery.of(context).size.width / 1.4,
                MediaQuery.of(context).size.height / 18,
              )),
              child: const Text('حفظ في الهاتف '),
            ),
          ),
        ],
      ),
      drawer:  Drawerr(sessionStateStream: widget.sessionStateStream,),
    );
  }
}
