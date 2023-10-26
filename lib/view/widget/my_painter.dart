import 'package:flutter/material.dart';
import 'package:wedget/model/info.dart';

class MyPainter extends CustomPainter {
  final Info info;
  final List<Offset> panLine;
  final List<List<Offset>> undoLines = [];
  var path = Path();
  Color color = Colors.black;
  // 그림 그리기 작업 기록

  MyPainter(this.info, this.panLine);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    //실시간으로 그려지게
    if (panLine.isNotEmpty) {
      path.moveTo(panLine.first.dx, panLine.first.dy);
      for (int i = 1; i < panLine.length; i++) {
        path.lineTo(panLine[i].dx, panLine[i].dy);
      }
    }

    // info 리스트 모두
    final List<List<Offset>> lines = info.lines;
    for (final line in lines) {
      if (line.isNotEmpty) {
        path.moveTo(line.first.dx, line.first.dy);
        for (int i = 1; i < line.length; i++) {
          path.lineTo(line[i].dx, line[i].dy);
        }
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void undo() {
    if (info.lines.isNotEmpty) {
      // info에 그려진 마지막 라인을 삭제
      final lastLine = info.lines.removeLast();
      // 삭제한 라인을 undoLines에 추가하여 나중에 되돌릴 수 있도록 저장
      undoLines.add(lastLine);
    }
  }

  void redo() {
    if (undoLines.isNotEmpty) {
      // undoLines에 있는 마지막 라인을 복원
      final restoredLine = undoLines.removeLast();
      // 복원한 라인을 info에 추가
      info.add(restoredLine);
    }
  }

  void reset() {
    info.lines.clear();
  }

  void square(Canvas canvas, Size size) {}

  void straight(Canvas canvas, Size size) {}

  void colorChangRed() {
    color = Colors.red;
    print(color);
  }

  void colorChangBlack() {
    color = Colors.black;
    print(color);
  }
}
