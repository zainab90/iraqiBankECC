import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iraq_bank/controller/controller.dart';
import 'package:iraq_bank/controller/textstyle.dart';
import 'package:iraq_bank/pages/card_screen.dart';
import 'package:iraq_bank/pages/ecc_screen.dart';
import 'package:iraq_bank/pages/home_screen.dart';
import 'package:iraq_bank/pages/login_screen.dart';
import 'package:iraq_bank/pages/person_screen.dart';
import 'package:iraq_bank/pages/qr_scanner.dart';
import 'package:iraq_bank/widget/bottom_n_b.dart';
import 'package:iraq_bank/widget/button_mode.dart';

import 'dart:async';

import 'package:local_session_timeout/src/session_timeout_manager.dart';

class Drawerr extends StatelessWidget {
  final StreamController<SessionState> sessionStateStream;

  HomeController test =  Get.put(HomeController());

  Drawerr({
    super.key, required this.sessionStateStream
  });

  //--------------------------------------------
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 40),
            
                 Padding(
                   padding: const EdgeInsets.only(bottom: 0.0,top:22.0, right: 8.0),
                   child: Row(
                     children: [
                      CircleAvatar(
                          radius: 30,
                          backgroundImage:NetworkImage(
                            test.imgUrl.value
                          )
                      ),
                      const SizedBox(width: 8.0,),
                      Text(test.userName.value, style: CustomTextStyle.f18w),
                    ],
                                   ),
                 ),
            
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                //_________________________________________________
                TextButton.icon(
                  icon: const Icon(Icons.home),
                  label: const Text("Home Page"),
                  onPressed: () {
                  //  Get.to(() => const HomeScreen(sessionStateStream: widget.sessionStateStream ));
                   Get.off(() => BottomNB(sessionStateStream: sessionStateStream));
            
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 90),
                //------------------------------------------------
                TextButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scan Qr"),
                  onPressed: () {
                    Get.to(() =>  QrScanner(sessionStateStream: sessionStateStream));
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 90),
            
                //----------------------------------------------------
                TextButton.icon(
                  icon: const Icon(Icons.account_box),
                  label: const Text("Person Page"),
                  onPressed: () {
                    Get.to(() =>  PersonPage(sessionStateStream: sessionStateStream));
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 80),
            
                //-------------------------------------------------------
                TextButton.icon(
                  icon: const Icon(Icons.credit_card),
                  label: const Text("My Card"),
                  onPressed: () {
                    Get.to(() =>  CardScreen(sessionStateStream: sessionStateStream));
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 80),
                //---------------------------------------------------------
                TextButton.icon(
                  icon: const Icon(Icons.security),
                  label: const Text("ECC"),
                  onPressed: () {
                    Get.to(() =>  ECC(sessionStateStream: sessionStateStream));
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 80),
            
                //----------------------------------------------------
                TextButton.icon(
                  icon: const Icon(Icons.settings),
                  label: const Text("settings"),
                  onPressed: () {
                    Get.snackbar(
                      "تنبيه",
                      "هذه الخدمة غير متاحة بعد",
                      backgroundColor: Colors.white,
                      icon: const Icon(
                        Icons.priority_high_rounded,
                      ),
                    );
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 80),
            
                //-----------------------------------------------------
                TextButton.icon(
                  icon: const Icon(Icons.info),
                  label: const Text("info"),
                  onPressed: () {
                    Get.snackbar(
                      "تنبيه",
                      "هذه الخدمة غير متاحة بعد",
                      backgroundColor: Colors.white,
                      icon: const Icon(
                        Icons.priority_high_rounded,
                      ),
                    );
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 80),
            
               const ButtonMode(),
            
                //----------------------------------------------------
             //   SizedBox(height: MediaQuery.of(context).size.height / 80),
            
                TextButton.icon(
                  onPressed: () {
                   // Get.offUntil(() => Login(sessionStateStream: sessionStateStream));
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {return  Login(sessionStateStream: sessionStateStream);}), (route) => false);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("LogOut"),
                )
              ],
            ),
          )),
    );
  }
}
