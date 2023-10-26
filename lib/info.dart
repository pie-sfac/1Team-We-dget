// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Info {
  List<List<Offset>> lines;

  Info({
    List<List<Offset>>? initialLines,
  }) : lines = initialLines ?? [];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lines':
          lines.map((line) => line.map((offset) => offset).toList()).toList(),
    };
  }

  void add(List<Offset> line) {
    lines.add([...line]);
  }
}
