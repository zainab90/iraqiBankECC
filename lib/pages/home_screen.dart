import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iraq_bank/controller/textstyle.dart';
import 'package:iraq_bank/widget/bottom_n_b.dart';
import 'package:iraq_bank/widget/widgetss_no_one.dart';
import 'package:iraq_bank/widget/drawerr.dart';
import 'package:iraq_bank/widget/icon_button_mode.dart';
import 'package:iraq_bank/widget/wwidget_three.dart';
import 'package:iraq_bank/widget/wwidget_two.dart';
import 'package:local_session_timeout/src/session_timeout_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';


class HomeScreen extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  const HomeScreen({
  required this.sessionStateStream,
  super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //========================

  //==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "الصفحة الرئيسية",
          style: CustomTextStyle.f19w,
        ),
        centerTitle: true,
        actions: const [IconButtonn()],
      ),
     // bottomNavigationBar: BottomNB(sessionStateStream: widget.sessionStateStream),
      drawer:  Drawerr(sessionStateStream: widget.sessionStateStream),
      //-------------------------------------------
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 11,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: serchfield,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "الاساسيات",
                  style: CustomTextStyle.f20w,
                ),
              ),
            ),
          ),
          Container(
            //added by zainab
            height: 110.0,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            //color: Colors.red,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  //added by zainab
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    aWidget(context),
                    a2,
                    a3,
                  ],
                ),
              ),
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "خدمات مالية",
                style: CustomTextStyle.f20w,
              ),
            ),
          ),
          Container(

            height: 130.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  b1,
                  b2,
                  b3,
                  b4,
                  b5,
                  b2


                ],
              ),
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "مزودي الخدمة",
                style: CustomTextStyle.f20w,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  c1,
                  c2,
                  c3,
                  c4,
                  c5,
                  c6,
                  c7,
                  c8,
                  c9,
                  c10,
                  c11,
                  c12,
                  c13,
                ],
              ),
            ),
          )
        ],
      ),

    );
  }

  @override
  void initState() {
    PackageInfo.fromPlatform().then((value) {
      print("package info is : ${value}"); // Value will be our all details we get from package info package
    });
  }
}
