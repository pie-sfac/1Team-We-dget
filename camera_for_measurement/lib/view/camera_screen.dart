import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:camera_for_measurement/provider/camera_notifier_provider.dart';
import 'package:camera_for_measurement/provider/image_provider.dart';
import 'package:camera_for_measurement/view/pose_painter.dart';
import 'package:camera_for_measurement/view/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  double currentZoomLevel = 1.0;
  final poseDetector = PoseDetector(
      options: PoseDetectorOptions(
    mode: PoseDetectionMode.stream,
    model: PoseDetectionModel.base,
  ));

  CustomPaint? customPaint;

  @override
  void dispose() {
    poseDetector.close();

    super.dispose();
  }

  Future<void> _processImage(InputImage inputImage) async {
    final poses = await poseDetector.processImage(inputImage);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
      );
      setState(() {
        customPaint = CustomPaint(
          painter: painter,
        );
      });
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cameraNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 촬영하기'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Todo: 카메라 뷰의 이미지를 실시간으로 mlkit가 보여줄 수 있게 해야 함.
          CameraPreview(
            ref.watch(cameraNotifierProvider.notifier).controller,
            child: customPaint,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                var image = ref
                    .watch(cameraNotifierProvider.notifier)
                    .onAvailableImage!
                    .planes
                    .first;

                _processImage(
                  InputImage.fromBytes(
                    bytes: image.bytes,
                    metadata: InputImageMetadata(
                      size: Size(
                        image.width!.toDouble(),
                        image.height!.toDouble(),
                      ),
                      rotation: InputImageRotation.rotation0deg,
                      // used only in Android
                      format: InputImageFormat.bgra8888,
                      // used only in iOS
                      bytesPerRow: image.bytesPerRow, // used only in iOS
                    ),
                  ),
                );

                print('clicked!');
              },
              child: const Text('processImageButton'),
            ),
          ),
          Text(
            '[camera] $state',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              onPressed: () {
                ref.read(cameraNotifierProvider.notifier).toggleCameraLens();

                setState(() {

                });
              },
              child: Icon(
                Platform.isIOS
                    ? Icons.flip_camera_ios_outlined
                    : Icons.flip_camera_android_outlined,
                // size: 25,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 4,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Slider(
                        value: currentZoomLevel,
                        min: ref
                            .read(cameraNotifierProvider.notifier)
                            .minAvailableZoom,
                        max: min(
                            ref
                                .read(cameraNotifierProvider.notifier)
                                .maxAvailableZoom,
                            3),
                        onChanged: (val) async {
                          ref
                              .read(cameraNotifierProvider.notifier)
                              .controller
                              .setZoomLevel(val);
                          currentZoomLevel = val;
                          setState(() {});
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.yellow,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            '${currentZoomLevel.toStringAsFixed(1)}x',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final cameraController =
                ref.read(cameraNotifierProvider.notifier).controller;

            final image = await cameraController.takePicture().catchError(
              (Object e) {
                // ToDo: 에러 케이스 정리
                if (e is CameraException) {
                  switch (e.code) {
                    case 'CameraAccessDenied':
                      // Handle access errors here.
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('카메라를 사용할 수 없습니다. 사용권한을 확인해 주세요.'),
                        ),
                      );
                      break;
                    default:
                      // Handle other errors here.
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('에러를 확인해 주세요. $e'),
                        ),
                      );
                      print(e);
                      break;
                  }
                }
              },
            );

            ref.read(imageProvider.notifier).state = image;

            if (ref.read(imageProvider.notifier).state != null) {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PreviewScreen(
                    imagePath: image.path,
                  ),
                ),
              );
            }
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
