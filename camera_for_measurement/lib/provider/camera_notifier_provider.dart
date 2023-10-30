import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_for_measurement/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraNotifierProvider =
    StateNotifierProvider.autoDispose<CameraNotifier, CameraDescription?>(
  (ref) {
    return CameraNotifier();
  },
);

class CameraNotifier extends StateNotifier<CameraDescription?> {
  double currentZoomLevel = 1.0;
  double minAvailableZoom = 1.0;
  double maxAvailableZoom = 1.0;
  CameraImage? onAvailableImage;

  CameraNotifier() : super(cameras.isEmpty ? null : cameras.first) {
    initializeControllerFuture();
  }

  final CameraController controller = CameraController(
    cameras.first, ResolutionPreset.high, enableAudio: false,
    imageFormatGroup: Platform.isAndroid
        ? ImageFormatGroup.nv21 // for Android
        : ImageFormatGroup.bgra8888, // for iOS
  );

  Future<void>? toggleCameraLens() {
    if (cameras.length < 2) return null;

    if (controller.description == cameras.first) {
      controller.setDescription(cameras[1]);
    } else {
      controller.setDescription(cameras.first);
    }
    return null;
  }

  Future<void> initializeControllerFuture() async {
    controller.initialize().then((value) {
      if (!mounted) return;

      controller.getMinZoomLevel().then((value) {
        currentZoomLevel = value;
        minAvailableZoom = value;
      });

      controller.getMaxZoomLevel().then((value) {
        maxAvailableZoom = value;
      });

      // controller.startImageStream(
      //   (image) => onAvailableImage = image,
      // );
    });
  }
}
