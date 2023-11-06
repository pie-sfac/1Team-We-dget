import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  double sliderValue = 0.7;

  XFile? selectedImage;

  double positionX1 = 0;
  double positionY1 = 0;

  @override
  void initState() {
    super.initState();
    painter = MyPainter(); // MyPainter 인스턴스 생성
  }

  Widget build(BuildContext context) {
    var imagePicker = ImagePicker();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: selectedImage != null
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(selectedImage!.path)),
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                  height: 700,
                  child: GestureDetector(
                    onPanStart: (s) {
                      // if (painter!.eraseMode) {
                      //   painter?.eraseStart(s.localPosition);
                      // } else {

                      setState(() {
                        painter?.panStart(s.localPosition);
                      });
                      // }
                    },
                    onPanUpdate: (s) {
                      // if (painter!.eraseMode) {
                      //   painter?.eraseUpdate(s.localPosition);
                      // } else {

                      setState(() {
                        painter?.panUpdate(s.localPosition);
                      });

                      // }
                    },
                    onPanEnd: (details) {
                      // if (painter!.eraseMode) {
                      //   painter?.eraseEnd();
                      // } else {
                      setState(() {
                        painter?.panEnd();
                      });
                      // }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Slider(
                      value: sliderValue,
                      min: 0.7,
                      max: 10.0,
                      divisions: 5,
                      onChanged: (newValue) {
                        setState(() {
                          sliderValue = newValue;
                          painter?.sizeChange(newValue);
                        });
                      },
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          if (painter!.mode != 'penMode')
                            painter?.penModeChange();
                        });
                      },
                      elevation: 2.0,
                      fillColor: Colors.blue,
                      child: Icon(
                        Icons.brush,
                        size: 12.0,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          if (painter!.mode != 'eraseMode')
                            painter?.eraseModeChange();
                        });
                      },
                      elevation: 2.0,
                      fillColor: Colors.blue,
                      child: Icon(
                        Icons.auto_fix_high,
                        size: 12.0,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              left: positionX1,
              top: positionY1,
              child: Container(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    TextField(
                        // showCursor: false,
                        ),
                    GestureDetector(
                      onScaleUpdate: (s) {
                        setState(
                          () {
                            positionX1 += s.focalPointDelta.dx;
                            positionY1 += s.focalPointDelta.dy;
                            print(positionX1);
                          },
                        );
                      },
                    ),
                  ],
                ),
                color: Colors.black12,
              ),
            ),
            Container(
              //여기 바로 업데이트가 안 됨
              child: CustomPaint(
                key: ValueKey(painter?.panLine.hashCode),
                painter: painter,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              if (painter!.mode != 'circleMode') {
                painter?.circleModeChange();
              }
            },
            child: Icon(Icons.circle_outlined),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              if (painter!.mode != 'straightMode') {
                painter?.straightModeChange();
              }
            },
            child: Icon(Icons.horizontal_rule),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                painter?.colorChangeRed();
                if (painter!.mode == 'eraseMode') {
                  painter?.eraseModeChange();
                }
              });
            },
            backgroundColor: Colors.red,
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                painter?.colorChangeBlack();
                if (painter!.mode == 'eraseMode') {
                  painter?.eraseModeChange();
                }
              });
            },
            backgroundColor: Colors.black,
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                painter?.opacityModeChange();
              });
            },
            child: Icon(Icons.blur_on),
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
                painter?.reset();
              });
            },
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () async {
              setState(() {
                painter?.imgDeleteModeChange();
              });
              if (painter!.imgMode) {
                selectedImage = null;
                setState(() {});
                Icon(Icons.delete);
              } else {
                var image =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  print('이미지 선택 완료');
                  selectedImage = image;
                  setState(() {});
                } else {
                  print('이미지 선택 실패');
                }
              }
            },
            child: Icon(painter!.imgMode ? Icons.image : Icons.delete),
          ),
        ],
      ),
    );
  }
}
