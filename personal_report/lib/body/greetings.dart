import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Greetings extends StatefulWidget {
  const Greetings({super.key});

  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('박승환 회원님'),
          Row(
            children: [
              Text('과거 레포트 보러가기'),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(Icons.navigate_next),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

