import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:personal_report/model/archive_link.dart';
import 'package:personal_report/model/center.dart';
import 'package:personal_report/model/comment.dart';
import 'package:personal_report/model/condition.dart';
import 'package:personal_report/model/exercise.dart';
import 'package:personal_report/model/media.dart';
import 'package:personal_report/model/member.dart';
import 'package:personal_report/model/pain_history.dart';
import 'package:personal_report/model/writer.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Person {
  String uuid;
  Writer writer;
  Center center;
  Member member;
  Comment comment;
  Media media;
  ArchiveLink archiveLink;
  PainHistory painHistory;
  Condition condition;
  Exercise exercise;
  
  Person({
    required this.uuid,
    required this.writer,
    required this.center,
    required this.member,
    required this.comment,
    required this.media,
    required this.archiveLink,
    required this.painHistory,
    required this.condition,
    required this.exercise,
  });

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      uuid: map['uuid'] as String,
      writer: Writer.fromMap(map['writer'] as Map<String,dynamic>),
      center: Center.fromMap(map['center'] as Map<String,dynamic>),
      member: Member.fromMap(map['member'] as Map<String,dynamic>),
      comment: Comment.fromMap(map['comment'] as Map<String,dynamic>),
      media: Media.fromMap(map['media'] as Map<String,dynamic>),
      archiveLink: ArchiveLink.fromMap(map['archiveLink'] as Map<String,dynamic>),
      painHistory: PainHistory.fromMap(map['painHistory'] as Map<String,dynamic>),
      condition: Condition.fromMap(map['condition'] as Map<String,dynamic>),
      exercise: Exercise.fromMap(map['exercise'] as Map<String,dynamic>),
    );
  }
}

// void main() async {
//   Dio dio = Dio();
//   var url = "https://flutterapi.tykan.me/personal-reports/";
//   var uuid = "4d61d864-4885-4fff-a2f5-07f9b599885d";
//   var res = await dio.get(url+uuid);
//   // print(res);
//   // print(res.data);
//   // print(res.data.runtimeType);
//   var person = Person.fromMap(res.data);
//   // print(person.member);
//   // print(person.uuid);
//   print(person.writer.name);
//   // print(res.data);
//   // print(res.data.runtimeType);  // List<dynamic>
//   // print(res.data.first.runtimeType);  // Map<String, dynamic>
// }

  //   late Future data;
  //   Future getData() async {
  //   var url = "https://flutterapi.tykan.me/personal-reports/";
  //   var uuid = "60fcd982-4c5a-41d8-a524-3f8f75c2e2a5";
  //   var dio = Dio();

  //   var res = await dio.get(url+uuid);
  //   print(res.data);
  //   print(res.data.runtimeType);
  //   return res.data;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   data = getData();
  // } 