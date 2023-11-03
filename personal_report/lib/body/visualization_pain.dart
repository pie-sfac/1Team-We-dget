import 'package:flutter/material.dart';

class VisualizationPain extends StatelessWidget {
  const VisualizationPain({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('박승환 회원님의 통증 변화 그래프입니다.'),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Placeholder(),
          ),
        ],
      ),
    );
  }
}
