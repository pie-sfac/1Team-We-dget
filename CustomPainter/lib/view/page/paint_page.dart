import 'package:flutter/material.dart';
import 'package:wedget/view/widget/my_painter.dart';

class PaintPage extends StatefulWidget {
  const PaintPage({super.key});

  @override
  State<PaintPage> createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  // Info info = Info(initialLines: []);
  // List<Offset> panLine = [];
  MyPainter? painter; // MyPainter 인스턴스를 저장할 변수

  bool extended = false;
  double sliderValue = 0.1;

  @override
  void initState() {
    super.initState();
    painter = MyPainter(); // MyPainter 인스턴스 생성
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              painter: painter,
            ),
            Column(
              children: [
                Container(
                  height: 700,
                  color: Colors.black12,
                  child: GestureDetector(
                    onPanStart: (s) {
                      setState(() {
                        painter?.panStart(s.localPosition);
                      });
                    },
                    onPanUpdate: (s) {
                      setState(() {
                        painter?.panUpdate(s.localPosition);
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        painter?.panEnd();
                      });
                    },
                  ),
                ),
                Slider(
                    value: sliderValue,
                    min: 0.1,
                    max: 15.0,
                    divisions: 5,
                    onChanged: (newValue) {
                      setState(() {
                        sliderValue = newValue;
                        painter?.sizeChange(newValue);
                      });
                    })
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.small(
            onPressed: () {},
            child: Icon(Icons.auto_fix_normal_sharp),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {},
            child: Icon(Icons.auto_fix_high),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {},
            child: Icon(Icons.crop_square),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {},
            child: Icon(Icons.horizontal_rule),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                painter?.colorChangeRed();
              });
            },
            backgroundColor: Colors.red,
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                painter?.colorChangeBlack();
              });
            },
            backgroundColor: Colors.black,
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                painter?.undo();
                // print(info.lines);
              });
            },
            child: Icon(Icons.undo),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                painter?.redo();
                // print(info.lines);
              });
            },
            child: Icon(Icons.redo),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                // painter?.reset();
              });
            },
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {},
            child: Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}
