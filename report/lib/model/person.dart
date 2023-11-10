import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:report/model/archive_link.dart';
import 'package:report/model/center.dart';
import 'package:report/model/comment.dart';
import 'package:report/model/condition.dart';
import 'package:report/model/exercise.dart';
import 'package:report/model/media.dart';
import 'package:report/model/member.dart';
import 'package:report/model/pain_history.dart';
import 'package:report/model/writer.dart';

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
