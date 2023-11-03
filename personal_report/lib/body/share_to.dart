import 'package:flutter/material.dart';

class ShareTo extends StatelessWidget {
  const ShareTo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('박승환 회원님의\n퍼스널 레포트를 공유해 보세요'),
          Text('내가 작성한 만족도와 함께 전달됩니다'),
          Row(
            children: List.generate(3, (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(),
                  Text('링크복사'),
                ],
              ),
            ),),
          ),
        ],
      ),
    );
  }
}
