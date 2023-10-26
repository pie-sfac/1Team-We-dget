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
  CameraNotifier() : super(cameras.isEmpty ? null : cameras.first) {
    initializeControllerFuture();
  }

  final CameraController controller = CameraController(
    cameras.first, ResolutionPreset.high,
    imageFormatGroup: Platform.isAndroid
        ? ImageFormatGroup.nv21 // for Android
        : ImageFormatGroup.bgra8888, // for iOS
  );

  Future<void> initializeControllerFuture() async {
    controller.initialize();
  }
}
