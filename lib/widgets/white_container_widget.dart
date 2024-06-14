import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/pages/chat_page.dart';

class WhiteContainer extends StatelessWidget {
  const WhiteContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DraggableScrollableSheet(
        initialChildSize: 0.66,
        minChildSize: 0.66,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              color: Colors.white,
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding:
                      const EdgeInsets.only(left: 20.0, right: 35.0),
                  title: const Text(
                    'نام گروه -تست',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.5),
                  ),
                  subtitle: const Text('سلام چطوری؟ -تست',
                      style: TextStyle(fontSize: 13)),
                  leading: Image.asset('assets/images/group_pic.png'),
                  onTap: () {
                    Get.to(const ChatPage());
                  },
                  trailing: const Padding(
                    padding: EdgeInsets.only(top: 14),
                    child: Column(
                      children: [
                        Text('4 دقیه قبل'),
                        Text('data'),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
