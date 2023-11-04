import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wedget/model/info.dart';

class MyPainter extends CustomPainter {
  List<Info> lines = [];
  List<Offset> panLine = []; //임시 리스트
  List<List<Offset>> eraseLine = [];
  List<Offset> offsetList = [];

  double sizes = 0.7;
  Color colors = Colors.black;
  BlendMode blendModes = BlendMode.srcOver;

  bool eraseMode = false;
  bool straightMode = false;

  List<Offset> circleLine = [];

  List<Info> undoLines = [];

  MyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    for (final info in lines) {
      Paint paint = Paint()
        ..color = info.color
        ..strokeWidth = info.size
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      // ..blendMode = info.blendMode;

      // if (eraseMode) {
      //   paint.blendMode = BlendMode.clear; // 지우개 모드일 때 이전 그림을 투명하게 처리
      // } else {
      //   paint.blendMode = BlendMode.srcOver; // 일반 그리기 모드
      // }

      List<Offset> offsetList = info.offset;

      if (offsetList.isNotEmpty) {
        var path = Path();
        path.moveTo(offsetList.first.dx, offsetList.first.dy);
        for (int i = 1; i < offsetList.length; i++) {
          path.lineTo(offsetList[i].dx, offsetList[i].dy);
        }

        canvas.drawPath(path, paint);
        // if (straightMode) {
        //   canvas.drawCircle(circleLine.first, 50, paint);
        // }
      }
      // if (straightMode) {
      // } else {}
    }

    //lines 리스트 모두
    // final List<List<Offset>> lines = info.lines;
    // for (final line in lines) {
    //   if (line.isNotEmpty) {
    //     path.moveTo(line.first.dx, line.first.dy);
    //     for (int i = 1; i < line.length; i++) {
    //       path.lineTo(line[i].dx, line[i].dy);
    //     }
    //   }
    // }

    // if (offsetList.isNotEmpty) {
    //   var path = Path();
    //   path.moveTo(offsetList.first.dx, offsetList.first.dy);
    //   for (int i = 1; i < offsetList.length; i++) {
    //     path.lineTo(offsetList[i].dx, offsetList[i].dy);
    //   }

    // canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void eraseModeChange() {
    eraseMode = !eraseMode;
    print(eraseMode);
    eraseMode ? blendModes = BlendMode.srcOut : blendModes = BlendMode.srcOver;
  }

  void straightModeChange() {
    straightMode = !straightMode;
    print(straightMode);
  }

  void undo() {
    if (lines.isNotEmpty) {
      // info에 그려진 마지막 라인을 삭제
      final lastLine = lines.removeLast();
      print(lastLine);
      print('hi');
      // 삭제한 라인을 undoLines에 추가하여 나중에 되돌릴 수 있도록 저장
      undoLines.add(lastLine);
    }
  }

  void redo() {
    print("undoLines: ${undoLines}");
    if (undoLines.isNotEmpty) {
      // undoLines에 있는 마지막 라인을 복원
      final restoredLine = undoLines.removeLast();
      // 복원한 라인을 info에 추가
      lines.add(restoredLine);
    }
  }

  void reset() {
    lines.clear();
  }

  void panStart(Offset offset) {
    panLine.add(offset);
    print(panLine); // Info 객체의 내용을 출력
    undoLines.clear();
  }

  void panUpdate(Offset offset) {
    panLine.add(offset);
    print(panLine);
  }

  void panEnd() {
    var color = colors;
    var eraseGap = 10;
    BlendMode blendMode = eraseMode ? BlendMode.clear : BlendMode.src;
    if (eraseMode) {
      eraseLine.add(panLine);
      print(eraseLine);
      for (var eraseOffsets in eraseLine) {
        for (var lineInfo in lines) {
          for (int i = 0; i < lineInfo.offset.length; i++) {
            final offset = lineInfo.offset[i];
            if (eraseOffsets.any((eraseOffset) {
              return sqrt(pow((eraseOffset.dx - offset.dx), 2) +
                      pow((eraseOffset.dy - offset.dy), 2)) <
                  eraseGap;
            })) {
              // 선 지우기
              Info lastLine = (lineInfo);

              // 지운 선을 undoLines에 추가
              undoLines = [Info.clone(lastLine)];

              // 지우지 말고 그대로 두려면 아래 라인을 주석 처리하거나 삭제
              lineInfo.offset.clear();
            }
          }
        }
      }
    } else if (straightMode) {
      circleLine = [panLine.first, panLine.last];
      lines.add(Info(circleLine, sizes, color, blendModes, eraseMode));
    } else {
      lines.add(Info(panLine, sizes, color, blendModes, eraseMode));
    }
    panLine = [];
    print(lines);
    print(panLine);
  }

  void square(Canvas canvas, Size size) {}

  // void straight(Canvas canvas, Size size) {}

  void colorChangeRed() {
    colors = Colors.red;
    print(colors);
  }

  void colorChangeBlack() {
    colors = Colors.black;
    print(colors);
  }

  void sizeChange(double sliderValue) {
    sizes = sliderValue;
  }
}
