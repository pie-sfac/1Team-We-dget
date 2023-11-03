import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFeedback extends StatelessWidget {
  const CustomFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Column(
        children: [
          Text(
              '회원님 어깨가 ... 운동하세요 운동 많이하세요 회원님 어깨가 ... 운동하세요 운동 많이하세요회원님 어깨가 ... 운동하세요 운동 많이하세요회원님 어깨가 ... 운동하세요 운동 많이하세요회원님 어깨가 ... 운동하세요 운동 많이하세요'),
          Divider(thickness: 2),
          Icon(CupertinoIcons.chevron_down),
        ],
      ),
    );
  }
}
