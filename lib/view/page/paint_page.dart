import 'package:flutter/material.dart';
import 'package:wedget/model/info.dart';
import 'package:wedget/view/widget/my_painter.dart';

class PaintPage extends StatefulWidget {
  const PaintPage({super.key});

  @override
  State<PaintPage> createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  Info info = Info(initialLines: []);
  List<Offset> panLine = [];
  MyPainter? painter; // MyPainter 인스턴스를 저장할 변수

  bool extended = false;

  @override
  void initState() {
    super.initState();
    painter = MyPainter(info, panLine); // MyPainter 인스턴스 생성
  }

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
                    // print(panLine);
                  });
                },
                onPanUpdate: (s) {
                  setState(() {
                    panLine.add(s.localPosition);
                    // print(panLine);
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    info.add(panLine);
                    panLine = [];
                    // print(info.lines);
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.auto_fix_high),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.crop_square),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.horizontal_rule),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                painter?.colorChangRed();
              });
            },
            backgroundColor: Colors.red,
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                painter?.colorChangBlack();
              });
            },
            backgroundColor: Colors.black,
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                painter?.undo();
                print(info.lines);
              });
            },
            child: Icon(Icons.undo),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                painter?.redo();
                print(info.lines);
              });
            },
            child: Icon(Icons.redo),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                painter?.reset();
              });
            },
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
