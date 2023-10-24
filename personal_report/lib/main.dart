import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('* 공통적으로 사용할 내용을 담는 common 폴더와 구현을 위한 단위를 나눈 각 폴더 (여기서는 report)로 나누어 작업합니다.'),
            Text('* 각 폴더 내에는 model, provider, view 폴더가 있으며, 필요한 경우 이외에 추가 폴더를 생성할 수 있습니다.'),
            Text('화이팅'),
          ],
        ),
      ),
    );
  }
}
