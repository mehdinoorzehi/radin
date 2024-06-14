import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoriesWidget extends StatelessWidget {
  const StoriesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xff010519),
              Color(0xff111A40),
              Color(0xff212F71),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Image.asset(
              'assets/images/tabbar.png',
              height: 45,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image.asset(
                'assets/images/stories.png',
                height: 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
