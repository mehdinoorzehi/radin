import 'package:flutter/material.dart';

import '../consts.dart';

class ScrollBottmButtonWidget extends StatelessWidget {
  const ScrollBottmButtonWidget({
    super.key,
    required this.showScrollToBottomButton,
    required this.scrollController,
  });

  final bool showScrollToBottomButton;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showScrollToBottomButton,
      child: FloatingActionButton(
        backgroundColor: kBlueColor,
        foregroundColor: Colors.white,
        mini: true,
        onPressed: () {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_downward),
      ),
    );
  }
}
