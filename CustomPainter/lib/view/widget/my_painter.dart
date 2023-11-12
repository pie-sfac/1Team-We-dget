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

  bool penMode = true;
  bool imgMode = true;
  bool eraseMode = false;
  bool straightMode = false;
  bool circleMode = false;
  bool opacityMode = false;
  bool touchMode = false;
  bool textMode = false;
  String mode = 'penMode';
  String modeOption = '';

  List<Offset> circleLine = [];

  List<Info> undoLines = [];
  List<Info> infoList = [];

  late Info lastLine;

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

      List<Offset> offsetList = info.offset;

      if (offsetList.isNotEmpty) {
        var path = Path();

        if (info.mode == 'circleMode') {
          if (offsetList.length >= 2) {
            // 선의 두 끝점의 중간 지점 계산
            Offset start = offsetList.first;
            Offset end = offsetList.last;
            Offset center =
                Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
            double radius =
                sqrt(pow(end.dx - center.dx, 2) + pow(end.dy - center.dy, 2));

            // 중간 지점에 원을 그립니다.
            canvas.drawCircle(center, radius, paint);
          }
        } else if (info.mode == 'straightMode') {
          var p1 = info.offset.first;
          var p2 = info.offset.last;
          canvas.drawLine(p1, p2, paint);
        } else if (info.mode != 'textMode' && info.mode != 'touchMode') {
          path.moveTo(offsetList.first.dx, offsetList.first.dy);
          for (int i = 1; i < offsetList.length; i++) {
            path.lineTo(offsetList[i].dx, offsetList[i].dy);
          }

          canvas.drawPath(path, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void penModeChange() {
    penMode = true;
    mode = 'penMode';
    print(penMode);
    print(mode);
  }

  void eraseModeChange() {
    eraseMode = !eraseMode;
    mode = eraseMode ? 'eraseMode' : 'penMode';
    print(eraseMode);
    print(mode);
    eraseMode ? blendModes = BlendMode.srcOut : blendModes = BlendMode.srcOver;
  }

  void straightModeChange() {
    straightMode = true;
    mode = 'straightMode';
    print(straightMode);
    print(mode);
  }

  void circleModeChange() {
    circleMode = true;
    mode = 'circleMode';
    print(circleMode);
    print(mode);
  }

  void opacityModeChange() {
    opacityMode = !opacityMode;
    modeOption = opacityMode ? 'opacityMode' : '';
    colors = opacityMode ? colors.withOpacity(0.5) : colors.withOpacity(1);
    print(opacityMode);
    print(modeOption);
    print(mode);
  }

  void textModeChange() {
    textMode = true;
    mode = 'textMode';
    print(textMode);
    print(mode);
  }

  void touchModeChange() {
    touchMode = true;
    mode = 'touchMode';
    print(touchMode);
    print(mode);
  }

  void imgDeleteModeChange() {
    imgMode = !imgMode;
  }

  void undo() {
    if (lines.isNotEmpty) {
      // info에 그려진 마지막 라인을 삭제
      lastLine = lines.removeLast();
      print('lastLine: $lastLine');
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
    undoLines.clear();
  }

  void panStart(Offset offset) {
    panLine = [...panLine, offset];
    lines = [...lines, Info(panLine, sizes, colors, mode, modeOption)];
    print(panLine); // Info 객체의 내용을 출력
    undoLines.clear();
  }

  void panUpdate(Offset offset) {
    panLine = [...panLine, offset];
    lines.last = (Info(panLine, sizes, colors, mode, modeOption));
    print(panLine);
  }

  void panEnd() {
    var eraseGap = 10;
    BlendMode blendMode = eraseMode ? BlendMode.clear : BlendMode.src;
    if (mode == 'eraseMode') {
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

              lineInfo.offset.clear();
            }
          }
        }
      }
    } else {
      lines.last = (Info(panLine, sizes, colors, mode, modeOption));
    }
    panLine = [];
    print('lines: ${lines}');
    print(panLine);
  }

  void colorChangeRed() {
    if (modeOption == 'opacityMode') {
      colors = Colors.red.withOpacity(0.5);
    } else {
      colors = Colors.red;
    }
    mode = 'penMode';
    print(colors);
  }

  void colorChangeBlack() {
    if (modeOption == 'opacityMode') {
      colors = Colors.black.withOpacity(0.5);
    } else {
      colors = Colors.black;
    }
    mode = 'penMode';
    print(colors);
  }

  void sizeChange(double sliderValue) {
    sizes = sliderValue;
  }
}
