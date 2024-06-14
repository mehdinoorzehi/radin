import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar myChatPageAppBar() {
  return AppBar(
    toolbarHeight: 90,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    actions: [
      Image.asset(
        'assets/images/c.png',
        height: 28,
      ),
      const SizedBox(
        width: 15,
      ),
      Image.asset(
        'assets/images/vcall.png',
        height: 18,
      ),
      const SizedBox(
        width: 80,
      ),
      const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'نام گروه',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '86450 تعداد اعضا',
            style: TextStyle(color: Color(0xff797C7B)),
          )
        ],
      ),
      const SizedBox(
        width: 10,
      ),
      Image.asset(
        'assets/images/group_pic.png',
        height: 55,
      ),
      const SizedBox(
        width: 15,
      ),
      GestureDetector(
        onTap: () => Get.back(),
        child: Image.asset(
          'assets/images/arrow.png',
          height: 14,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
    ],
  );
}
