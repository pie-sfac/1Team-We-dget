// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';

// class Info {
//   Info(this.offset, this.size, this.color);
//   final Offset offset;
//   final double size;
//   final Color color;

// Info({
//   List<List<Offset>>? initialLines,
// }) : lines = initialLines ?? [];

// Map<String, dynamic> toMap() {
//   return <String, dynamic>{
//     'lines':
//         lines.map((line) => line.map((offset) => offset).toList()).toList(),
//   };
// }

// void add(List<Offset> line) {
//   lines.add([...line]);
// }
//}
class Info {
  List<Offset> offset;
  double size;
  Color color;
  String mode;
  String modeOption;
  String? text;

  Info(
    this.offset,
    this.size,
    this.color,
    this.mode,
    this.modeOption,
  );

  Info.clone(Info other)
      : offset = List.from(other.offset),
        size = other.size,
        color = other.color,
        mode = other.mode,
        modeOption = other.modeOption;

  // void add(List<Offset> line) {
  //   lines.add([...line]);
  // }

  @override
  String toString() {
    return 'Info(offset: $offset, size: $size, color: $color, mode: $mode, modeOption: $modeOption)';
  }
}
