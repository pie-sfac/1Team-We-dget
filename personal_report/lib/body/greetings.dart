import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:personal_report/model/person.dart';

class Greetings extends StatefulWidget {
  const Greetings({super.key});

  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  Dio dio = Dio();
  Person? person;

  Future<Person?> fetchData() async {
    var url = "https://flutterapi.tykan.me/personal-reports/";
    var uuid = "4d61d864-4885-4fff-a2f5-07f9b599885d";
    var res = await dio.get(url + uuid);

    if(res.statusCode == 200) {
      person = Person.fromMap(res.data);
      print(res.data['member']['name']);
      print(person!.member.name);
      return person;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    fetchData();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(person!.member.name),
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

