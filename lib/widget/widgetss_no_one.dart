import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iraq_bank/messages/receive.dart';
import 'package:iraq_bank/pages/tranasfer_history.dart';
import '../messages/send.dart';
import 'package:intl/intl.dart';


Widget a1 = Padding(
  padding: const EdgeInsets.all(8.0),
  child: ElevatedButton(
    onPressed: () {
      // Get.to(() => const Send());

    },
    style: ElevatedButton.styleFrom(
      fixedSize: const Size(110, 90),
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: 10),
        Icon(Icons.monetization_on_outlined, size: 30),
        Text("تحويل اموال"),
      ],
    ),
  ),
);



String myDateFormat(String reciv_date)
{
 try{
   DateTime new_date=DateTime.parse(reciv_date);
  String x=DateFormat.yMMMd().format(new_date);
   return x;
 }
     catch( e ){
   return "";
     }
}
String myTimeFormat(String reciv_date){
  try{
    DateTime new_date=DateTime.parse(reciv_date);
    String x=DateFormat.jms().format(new_date);
    return x;
  }
  catch( e ){
    return "";
  }

}


Padding aWidget(BuildContext context){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton(

      onPressed: () {
        Get.to(() => const Send());

      },
      style: ElevatedButton.styleFrom(
fixedSize:const Size(116, 90),
        shape: const BeveledRectangleBorder(
        )
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 1),
          Icon(Icons.monetization_on_outlined, size: 30),
          Text("تحويل اموال"),
          SizedBox(height: 1),

        ],
      ),
    ),
  );
}


//========================================

Widget a2 = Padding(
  padding: const EdgeInsets.all(8.0),
  child: ElevatedButton(
    onPressed: () {
      Get.to(() => const TranasferHistory());
    },
    style: ElevatedButton.styleFrom(
        fixedSize:const Size(128, 90),
        shape: const BeveledRectangleBorder(
        )
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 1),
        Icon(Icons.list_alt, size: 30),
        Text("تاريخ المعاملات "),
        SizedBox(height: 1),
      ],
    ),
  ),
);
//======================================

Widget a3 = Padding(
  padding: const EdgeInsets.all(8.0),
  child: ElevatedButton(
    onPressed: () {
      Get.to(() => const Res());
    },
    style: ElevatedButton.styleFrom(
        fixedSize:const Size(116, 90),
        shape: const BeveledRectangleBorder(
        )
    ),
    child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        SizedBox(height: 1),
        Icon(Icons.notification_important, size: 30),
        Text("الاشعارات"),
          SizedBox(height: 1),
      ],
    ),
  ),
);
