import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wedget/model/info.dart';

class MyPainter extends CustomPainter {
  Size get size => _size;
  Size _size = Size.zero;
  List<Info> lines = [];
  List<Offset> panLine = []; //임시 리스트
  List<List<Offset>> eraseLine = [];
  List<Offset> offsetList = [];

  double sizes = 0.7;
  Color colors = Colors.black;
  Color lastcolor = Colors.black;

  bool penMode = true;
  bool imgMode = true;
  bool eraseMode = false;
  bool straightMode = false;
  bool circleMode = false;
  bool opacityMode = false;
  bool touchMode = false;
  bool textMode = false;
  String mode = 'penMode';
  String lastMode = 'penMode';
  String modeOption = '';

  List<Offset> circleLine = [];

  List<Info> undoLines = [];
  List<Info> infoList = [];

  late Info lastLine;

  MyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _size = size; // Store the size
    canvas.saveLayer(Offset.zero & size, Paint());
    var path = Path();

    for (final info in lines) {
      Paint paint = Paint()
        ..color = (info.modeOption == 'opacityMode')
            ? info.color.withOpacity(0.5)
            : info.color
        ..strokeWidth = info.size
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..blendMode =
            (info.mode == 'eraseMode') ? BlendMode.clear : BlendMode.srcOver;

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

    canvas.restore();
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
    lastModeSave();
    lastColorUse();
  }

  void eraseModeChange() {
    eraseMode = true;
    mode = 'eraseMode';
    print(eraseMode);
    print(mode);
  }

  void straightModeChange() {
    straightMode = true;
    mode = 'straightMode';
    print(straightMode);
    print(mode);
    lastModeSave();
    lastColorUse();
  }

  void circleModeChange() {
    circleMode = true;
    mode = 'circleMode';
    print(circleMode);
    print(mode);
    lastModeSave();
    lastColorUse();
  }

  void opacityModeChange() {
    lastColorUse();
    opacityMode = !opacityMode;
    modeOption = opacityMode ? 'opacityMode' : '';
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

  void lastModeSave() {
    if (mode != 'textMode' && mode != 'touchMode' && mode != 'eraseMode') {
      lastMode = mode;
      print('lastMode: $lastMode');
    }
  }

  void lastModeUse() {
    mode = lastMode;
  }

  void lastColorUse() {
    colors = lastcolor;
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
    // BlendMode blendMode = eraseMode ? BlendMode.clear : BlendMode.src;
    if (mode == 'eraseMode') {
      lines.last = (Info(panLine, sizes, colors, mode, modeOption));
    } else {
      lines.last = (Info(panLine, sizes, colors, mode, modeOption));
    }
    panLine = [];
    print('lines: ${lines}');
    print(panLine);
  }

  void colorChangeRed() {
    lastModeSave();
    colors = Colors.red;
    lastcolor = colors;
    print(colors);
  }

  void colorChangeBlack() {
    lastModeSave();
    colors = Colors.black;
    lastcolor = colors;
    print(colors);
  }

  void sizeChange(double sliderValue) {
    sizes = sliderValue;
  }
}
