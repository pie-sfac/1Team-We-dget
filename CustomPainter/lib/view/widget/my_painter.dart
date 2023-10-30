import 'package:flutter/material.dart';
import 'package:wedget/model/info.dart';

class MyPainter extends CustomPainter {
  List<Info> lines = [];
  List<Offset> panLine = []; //임시 리스트
  List<Offset> offsetList = [];

  double sizes = 3;
  Color colors = Colors.black;
  bool eraseMode = false;

  // final Info info;
  // final List<Offset> panLine;
  final List<Info> undoLines = [];
  // var path = Path();
  // // 그림 그리기 작업 기록

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
        path.moveTo(offsetList.first.dx, offsetList.first.dy);
        for (int i = 1; i < offsetList.length; i++) {
          path.lineTo(offsetList[i].dx, offsetList[i].dy);
        }

        canvas.drawPath(path, paint);
        // canvas.restore();
      }
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

  void undo() {
    if (lines.isNotEmpty) {
      // info에 그려진 마지막 라인을 삭제
      final lastLine = lines.removeLast();
      print(lastLine);
      // 삭제한 라인을 undoLines에 추가하여 나중에 되돌릴 수 있도록 저장
      undoLines.add(lastLine);
    }
  }

  void redo() {
    if (undoLines.isNotEmpty) {
      // undoLines에 있는 마지막 라인을 복원
      final restoredLine = undoLines.removeLast();
      // 복원한 라인을 info에 추가
      lines.add(restoredLine);
    }
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
    lines.add(Info(panLine, sizes, color));
    panLine = [];
    print(lines);
    print(panLine);
  }

  // void reset() {
  //   info.lines.clear();
  // }

  void square(Canvas canvas, Size size) {}

  void straight(Canvas canvas, Size size) {}

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
