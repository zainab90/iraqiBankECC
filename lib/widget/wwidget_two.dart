import 'package:flutter/material.dart';
import 'package:get/get.dart';



Widget serchfield = TextFormField(
  decoration: InputDecoration(
    fillColor: Colors.white,
    filled: true,
    prefixIcon: const Icon(Icons.search),
    suffixIcon: IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {},
    ),
    hintText: 'Search...',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
);

Widget b1 = Padding(
  padding: const EdgeInsets.all(8.0),
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
        fixedSize:const Size(128, 110),
        shape: const BeveledRectangleBorder(
        )
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 1),
        Image.asset("images/wu.png",fit: BoxFit.cover, width: 50, height: 50,),
        const Center(child: Text("ويسترن يونيون")),
        const SizedBox(height: 1),
      ],
    ),
  ),
);
//added by zainab




Widget b2 = Padding(
  padding: const EdgeInsets.all(8.0),
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
        fixedSize:const Size(125, 110),
        shape: const BeveledRectangleBorder(
        )
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,      children: [
        const SizedBox(height: 1),
        Image.asset("images/mc.png"),
        const Text("والت كارد"),
        const SizedBox(height: 1.0,)
      ],
    ),
  ),
);

Widget b3 = Padding(
  padding: const EdgeInsets.all(8.0),
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
        fixedSize:const Size(125, 110),
        shape: const BeveledRectangleBorder(
        )
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 1),
        Image.asset("images/visa_icon.png",fit: BoxFit.cover, height:50.0,width: 100.0,),
        const Text("فيزا كارد"),
        const SizedBox(height: 1.0,)
      ],
    ),
  ),
);

Widget b4 = Padding(
  padding: const EdgeInsets.all(8.0),
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
        fixedSize:const Size(125, 110),
        shape: const BeveledRectangleBorder(
        )
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,      children: [
        SizedBox(height: 1),
        Icon(Icons.add_box_outlined, size: 50),
        Text("شحن الرصيد"),
        SizedBox(height: 1.0,)
      ],
    ),
  ),
);

Widget b5 = Padding(
  padding: const EdgeInsets.all(8.0),
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
        fixedSize:const Size(135, 110),
        shape: const BeveledRectangleBorder(
        )
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 1),
        Icon(Icons.shopping_cart, size: 50),
        Text("بطاقات الكترونية"),
        SizedBox(height: 1.0,)
      ],
    ),
  ),
);

Widget b6 = Padding(
  padding: const EdgeInsets.all(8.0),
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
        fixedSize:const Size(130, 110),
        shape: const BeveledRectangleBorder(
        )
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 1),
        Icon(Icons.add_card_rounded, size: 50),
        Text(
          "تعبئة بواسطة الفيزا او الماستر",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.0,)
      ],
    ),
  ),
);
