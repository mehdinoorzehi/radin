import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BottomNavigatinBarWidget extends StatelessWidget {
  const BottomNavigatinBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 73,
        width: Get.width,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 249, 248, 248),
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(7.w), right: Radius.circular(7.w))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/settings.png',
              height: 24,
              width: 24,
            ),
            const SizedBox(
              width: 55,
            ),
            Image.asset(
              'assets/images/call.png',
              height: 24,
              width: 24,
            ),
            const SizedBox(
              width: 55,
            ),
            Image.asset(
              'assets/images/user.png',
              height: 24,
              width: 24,
            ),
            const SizedBox(
              width: 55,
            ),
            Image.asset(
              'assets/images/message.png',
              height: 25,
              width: 86,
            ),
          ],
        ));
  }
}
