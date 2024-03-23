import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iraq_bank/controller/textstyle.dart';
import 'package:iraq_bank/widget/icon_button_mode.dart';
import 'package:iraq_bank/widget/widgetss_no_one.dart';

import 'view_image_storage.dart';

class QU {
  final String qr;
  final String name;
final String sent_time;
  QU({required this.qr, required this.name,  this.sent_time = ''});
}

class Res extends StatefulWidget {
  const Res({super.key});

  @override
  State<Res> createState() => _ResState();
}

class _ResState extends State<Res> {
  @override
  void initState() {
    getQrs();
    super.initState();
  }

  bool lod = true;
  List<QU> qrs = [];
  getQrs() async {
    qrs = [];

    var check = await FirebaseFirestore.instance.collection('users').where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).limit(1).get();

    if (check.docs.length == 1) {
      var data = await FirebaseFirestore.instance.collection('users').
      doc(check.docs[0].id).collection('qr').get();
      for (var i in data.docs) {
        print("each item in notifi is ${i.data()}");
      if (i.data()["sent_time"]==null)
        {
          qrs.add(QU(qr: i.data()['qr'], name: i.data()['sender']));

        }
      else{

        qrs.add(QU(qr: i.data()['qr'], name: i.data()['sender'],sent_time: i.data()['sent_time'].toString())
        );

      }

      }
      qrs.sort((a,b)=>b.sent_time.compareTo(a.sent_time));
    }
    setState(() {
      lod = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "صفحة الاشعارات",
          style: CustomTextStyle.f20b,
        ),
        centerTitle: true,
        actions: const [IconButtonn()],
      ),
      body: lod
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: qrs.length,
              itemBuilder: (c, i) =>
                  Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(

                 trailing : const Text('تم استلام اشعار', style: CustomTextStyle.f18b),
                //  title: Text(qrs[i].time),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(myDateFormat(qrs[i].sent_time.toString())),
                     Text(myTimeFormat(qrs[i].sent_time.toString()))
                   ],
                  ),


                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Vimg(
                          img: qrs[i].qr,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
