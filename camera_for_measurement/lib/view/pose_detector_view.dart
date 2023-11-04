import 'dart:async';
import 'package:camera/camera.dart';
import 'package:camera_for_measurement/component/pose_painter.dart';
import 'package:camera_for_measurement/provider/pose_info_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'camera_view.dart';

class PoseDetectorView extends ConsumerStatefulWidget {
  const PoseDetectorView({super.key});

  @override
  ConsumerState<PoseDetectorView> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends ConsumerState<PoseDetectorView> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      customPaint: _customPaint,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  void _extractPoseData(List<Pose> poses) {
    List<String> posesToString = [];
    if (poses.isNotEmpty) {
      poses.first.landmarks.forEach((key, value) {
        var info =
            'Type: ${value.type} | x: ${value.x} | y: ${value.y} | likelihood: ${value.likelihood} | createdAt: ${DateTime.now()}';
        posesToString.add(info);
      });
      ref.read(poseInfoProvider.notifier).state = [
        ...ref.read(poseInfoProvider),
        ...posesToString
      ];
    }
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    List<Pose> poses = await _poseDetector.processImage(inputImage);

    _extractPoseData(poses);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
