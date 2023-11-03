import 'package:flutter/material.dart';
import 'package:personal_report/common/const/custom_colors.dart';

class Rating extends StatelessWidget {
  const Rating({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                index < 4 ? Icons.star : Icons.star_border,
                color: index < 4 ? CustomColors.Primary_300 : Colors.grey,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
                '선생님 좋아요 통증 없어요 선생님 좋아요 통증 없어요 선생님 좋아요 통증 없어요 선생님 좋아요 통증 없어요 선생님 좋아요 통증 없어요 '),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('만족도 및 후기 발송'),
          ),
        ],
      ),
    );
  }
}
