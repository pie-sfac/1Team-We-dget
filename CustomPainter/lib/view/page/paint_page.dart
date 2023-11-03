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

  @override
  void initState() {
    super.initState();
    painter = MyPainter(); // MyPainter 인스턴스 생성
  }

  @override
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
                )
              ],
            ),
            Container(
              //여기 바로 업데이트가 안 됨
              child: GestureDetector(
                child: CustomPaint(
                  painter: painter,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.small(
            onPressed: () {
              painter?.eraseModeChange();
            },
            child: Icon(Icons.auto_fix_normal_sharp),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              painter?.eraseModeChange();
            },
            child: Icon(Icons.auto_fix_high),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {},
            child: Icon(Icons.crop_square),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              if (painter!.eraseMode) {
                painter?.eraseModeChange();
              }
              painter?.straightModeChange();
            },
            child: Icon(Icons.horizontal_rule),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                painter?.colorChangeRed();
                if (painter!.eraseMode) {
                  painter?.eraseModeChange();
                } else if (painter!.straightMode) {
                  painter?.straightModeChange();
                }
              });
            },
            backgroundColor: Colors.red,
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                painter?.colorChangeRed();
                if (painter!.eraseMode) {
                  painter?.eraseModeChange();
                } else if (painter!.straightMode) {
                  painter?.straightModeChange();
                }
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
                painter?.reset();
              });
            },
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () async {
              var image =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                print('이미지 선택 완료');
                selectedImage = image;
                setState(() {});
              } else {
                print('이미지 선택 실패');
              }
            },
            child: Icon(Icons.image),
          ),
        ],
      ),
    );
  }

  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
