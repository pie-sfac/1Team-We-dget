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

  UniqueKey buttonKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    painter = MyPainter(); // MyPainter 인스턴스 생성
  }

  Widget build(BuildContext context) {
    var imagePicker = ImagePicker();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: InteractiveViewer(
                // boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 3.0,
                panEnabled: painter?.mode == 'touchMode' ? true : false,
                child: Container(
                  child: Stack(
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
                      ),
                      painter?.mode != 'touchMode'
                          ? GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onPanStart: (s) {
                                setState(() {
                                  if (painter?.mode == 'textMode')
                                    _addTextField(s.localPosition);
                                  painter?.panStart(s.localPosition);
                                  // _addTextField(s.localPosition);
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
                                // }
                              },
                            )
                          : Container(),
                      Container(
                        child: CustomPaint(
                          key: ValueKey(painter?.panLine.hashCode),
                          painter: painter,
                        ),
                      ),
                      if (painter!.lines.isNotEmpty)
                        for (var info in painter!.lines)
                          if (info.mode == 'textMode')
                            Container(
                              child: Stack(
                                children: [
                                  ...textFields, // Add your textFields here
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 80,
              child: Row(
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
              ),
            )
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
                if (painter!.mode != 'textMode') {
                  painter?.textModeChange();
                }
              });
            },
            child: Icon(Icons.text_fields_sharp),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                painter?.undo();
                if (painter?.lastLine.mode == 'textMode' &&
                    textFields.isNotEmpty) {
                  textFields.removeLast();
                  // print(textFields);
                }
              });
            },
            child: Icon(Icons.undo),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                painter?.redo();
                // if (painter?.undoLines.last.mode == 'textMode' &&
                //     textFields.isNotEmpty) {
                //   textFields;
                //   // print(textFields);
                // }
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
                textFields.clear();
                keyList.clear();
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
            child: Icon(
                painter!.imgMode ? Icons.image : Icons.image_not_supported),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                if (painter!.mode != 'touchMode') {
                  painter?.touchModeChange();
                }
              });
            },
            child: Icon(Icons.touch_app),
          ),
          SizedBox(height: 12),
          FloatingActionButton.small(
            key: buttonKey,
            onPressed: () {
              setState(() {});
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  List<Widget> textFields = [];
  List<UniqueKey> keyList = [];
  final UniqueKey key = UniqueKey();

  // List<TextField> MytextFields = [];

  void _addTextField(Offset offset) {
    final key = UniqueKey();
    keyList.add(key);
    double positionX1 = offset.dx;
    double positionY1 = offset.dy;
    late Positioned textField;
    // 이전 위치를 기반으로 새로운 Positioned 위젯을 생성
    textField = Positioned(
      key: key,
      left: positionX1,
      top: positionY1,
      child: Draggable(
        child: Material(
          child: Container(
            width: 200,
            height: 40,
            color: Colors.grey,
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.black,
                border: OutlineInputBorder(),
                hintText: '내용을 입력하세요',
              ),
            ),
          ),
        ),
        feedback: Material(
          child: Container(
            width: 200,
            height: 40,
            color: Colors.grey.withOpacity(0.5),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type something...',
              ),
            ),
          ),
        ),
        onDragEnd: (details) {
          setState(() {
            positionX1 = details.offset.dx;
            positionY1 = details.offset.dy;
            // print('New positionX1: $positionX1');
            // print('New positionY1: $positionY1');
            // print(textFields);

            final updatedTextField = Positioned(
              left: positionX1,
              top: positionY1,
              child: textField.child,
            );

            int index = -1;

            void findKeyIndex() {
              for (int i = 0; i < keyList.length; i++) {
                if (keyList[i] == textField.key) {
                  index = i;
                  print('i $i');
                  break;
                } else {
                  index = -1; // 키를 찾지 못한 경우 -1을 반환합니다.
                }
              }
            }

            findKeyIndex();
            // print('UniqueKey(): ${UniqueKey()}');
            // print('textField.key: ${textField.key}');
            // print('key: ${key}');
            // print('keyList: ${keyList}');
            // print(textFields.indexOf(textField));
            if (index != -1) {
              textFields[index] = updatedTextField;
            } else {
              print('key 값이 없습니다');
            }
          });
        },
      ),
    );

    setState(() {
      textFields.add(textField);
    });
  }
}
