import 'package:flutter/material.dart';

class VisualizationCondition extends StatelessWidget {
  const VisualizationCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('박승환 회원님의 컨디션 변화입니다.'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    CircleAvatar(),
                    Text('매우좋음'),
                    Text('23.07.01'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
