import 'package:flutter/material.dart';
import 'package:iraq_bank/pages/barcode_scaning.dart';
import 'package:iraq_bank/pages/card_screen.dart';
import 'package:iraq_bank/pages/ecc_screen.dart';
import 'package:iraq_bank/pages/home_screen.dart';
import 'package:iraq_bank/pages/person_screen.dart';
import 'package:iraq_bank/pages/qr_scanner.dart';
import 'dart:async';

import 'package:local_session_timeout/local_session_timeout.dart';

class BottomNB extends StatefulWidget {
  //========================================================== الكود رقم 6
   final StreamController<SessionState> sessionStateStream;

  const BottomNB({
     required this.sessionStateStream,
    super.key
  });
  //=====================================

  @override
  BottomNBState createState() => BottomNBState();
}

class BottomNBState extends State<BottomNB> {
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = [
      HomeScreen(sessionStateStream: widget.sessionStateStream),
      PersonPage(sessionStateStream: widget.sessionStateStream),
      CardScreen(sessionStateStream: widget.sessionStateStream),
      QrScanner(sessionStateStream: widget.sessionStateStream),
      ECC(sessionStateStream: widget.sessionStateStream),
      BarcodeScaning(sessionStateStream: widget.sessionStateStream),
    ];
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      //
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedIconTheme: const IconThemeData(size: 40),
        // selectedFontSize: 16,
        // unselectedFontSize: 14,
        //
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الشخصية'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'البطاقات'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Qr مسح '),
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'تشفير'),
          BottomNavigationBarItem(icon: Icon(Icons.lock_open_rounded), label: 'فك التشفير'),
        ],
        currentIndex: _selectedIndex,

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
