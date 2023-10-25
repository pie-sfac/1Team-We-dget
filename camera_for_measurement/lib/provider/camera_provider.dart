import 'package:camera/camera.dart';
import 'package:camera_for_measurement/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraProvider = StateProvider<CameraDescription?>((ref) {
  if (cameras.isEmpty) return null;
  return cameras.first;
});
