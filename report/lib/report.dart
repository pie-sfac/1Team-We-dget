// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('박승환 회원님'),  // api에서 호출되도록 수정.
          centerTitle: false,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          actions: [
            Row(
              children: [
                Row(
                  children:[
                    Text('과거 레포트 보러가기'),
                    Icon(Icons.navigate_next),  // 이동할 페이지가 있도록 만들기.
                  ]
                )
              ]
            )  
          ],
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: const Color.fromARGB(255, 2, 46, 82),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('박승환 회원님 영상 및 이미지'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: const Color.fromARGB(255, 2, 46, 82),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('김파이 선생님 피드백'),
                    ),
                  ],
                ),
                Text('', overflow: TextOverflow.ellipsis,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: const Color.fromARGB(255, 2, 46, 82),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('센터 추천 링크'),
                    ),
                  ],)
              ],
            ),
          )
        ),
      ),
    );
  }
}