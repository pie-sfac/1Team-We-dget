import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../provider/image_provider.dart';

class DetectionScreen extends ConsumerStatefulWidget {
  const DetectionScreen({super.key});

  @override
  ConsumerState<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends ConsumerState<DetectionScreen> {
  late final InputImage inputImage;

  final poseDetector = PoseDetector(options: PoseDetectorOptions());

  List<Map<String, dynamic>> detected = [];

  final GlobalKey _widgetKeyForSize = GlobalKey();

  int willShowDetectionBox = 0;

  @override
  void initState() {
    super.initState();

    if (ref.read(imageProvider.notifier).state != null) {
      inputImage = InputImage.fromFilePath(
        ref.read(imageProvider.notifier).state!.path,
      );
    }
  }

  @override
  void dispose() {
    poseDetector.close();

    super.dispose();
  }

  Future<void> processImage(InputImage inputImage) async {
    final poses = await poseDetector.processImage(inputImage);

    for (Pose pose in poses) {
      // to access all landmarks
      // ToDo: (1) x, y 가 왜 바뀌지? (2) 카메라 회전을 허용하는 경우 변환
      pose.landmarks.forEach((_, landmark) {
        final type = landmark.type.name;
        final x = landmark.y;
        final y = landmark.x;
        final likelihood = landmark.likelihood;

        detected.add({
          'type': type,
          'x': x,
          'y': y,
          'likelihood': likelihood,
        });
      });

      // to access specific landmarks
      // final landmark = pose.landmarks[PoseLandmarkType.nose];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Screen'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (ref.read(imageProvider.notifier).state == null)
              const Center(
                child: Text('사진이 없습니다.'),
              ),
            if (ref.read(imageProvider.notifier).state != null)
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        key: _widgetKeyForSize,
                        child: Image.file(
                          File(ref.read(imageProvider.notifier).state!.path),
                        ),
                      ),
                      if (willShowDetectionBox >= 3)
                        ...detected
                            .where((element) => element['likelihood'] > 0.7)
                            .map(
                              (e) => Container(
                                width: (_widgetKeyForSize.currentContext
                                        ?.findRenderObject() as RenderBox)
                                    .size
                                    .width,
                                height: (_widgetKeyForSize.currentContext
                                        ?.findRenderObject() as RenderBox)
                                    .size
                                    .height,
                                // color: Colors.red.withOpacity(0.1),
                                child: CustomPaint(
                                  size: (_widgetKeyForSize.currentContext
                                          ?.findRenderObject() as RenderBox)
                                      .size,
                                  painter: MyPainter(
                                    // Todo: camera resolution 값에 따라 offset 값 변환 필요
                                    offset: Offset(e['x'] / 2, e['y'] / 2),
                                    text: e['type'],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      processImage(inputImage);
                      willShowDetectionBox++;
                      setState(() {});
                    },
                    child: const Text('Detect'),
                  ),
                  Text('$detected'),
                  if (willShowDetectionBox >= 3)
                    Text(
                        '${(_widgetKeyForSize.currentContext?.findRenderObject() as RenderBox).size}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final Offset offset;
  final String text;

  MyPainter({
    required this.offset,
    required this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.deepPurpleAccent;

    canvas.drawCircle(offset, 4, paint);
    canvas.drawParagraph(
      (ParagraphBuilder(
        ParagraphStyle(
          fontSize: 10,
          textAlign: TextAlign.center,
        ),
      )..addText(text))
          .build()
        ..layout(
          ParagraphConstraints(width: size.width / 5),
        ),
      offset,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
