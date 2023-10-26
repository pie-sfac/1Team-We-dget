import 'package:flutter/material.dart';
import 'package:wedget/info.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Info info = Info(initialLines: []);
  List<Offset> panLine = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              painter: MyPainter(info, panLine),
            ),
            Container(
              color: Colors.black12,
              child: GestureDetector(
                onPanStart: (s) {
                  setState(() {
                    panLine = [s.localPosition];
                    print(panLine);
                  });
                },
                onPanUpdate: (s) {
                  setState(() {
                    panLine.add(s.localPosition);
                    print(panLine);
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    info.add(panLine);
                    panLine = [];
                    print(info.lines);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final Info info;
  final List<Offset> panLine;

  MyPainter(this.info, this.panLine);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    var path = Path();

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
}
