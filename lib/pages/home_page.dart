import 'package:flutter/material.dart';

import '../widgets/bottom_navigation_bar_widget.dart';
import '../widgets/white_container_widget.dart';
import '../widgets/stories_widget.dart';

class HomePage1 extends StatelessWidget {
  const HomePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //! ویجت استوری که فعلا فقط به صورت عکس می باشد
          StoriesWidget(),
          //! قسمت مربوط به گفتکو ها
          WhiteContainer(),
          //! باتم نویگیشن بار که فعلا فقط به صورت عکس می باشد
          BottomNavigatinBarWidget()
        ],
      ),
    );
  }
}
