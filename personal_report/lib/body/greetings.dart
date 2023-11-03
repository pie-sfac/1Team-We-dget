import 'package:flutter/material.dart';

class Greetings extends StatelessWidget {
  const Greetings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('박승환 회원님'),
          Text('과거 레포트 보러가기'),
        ],
      ),
    );
  }
}
