import 'dart:io';
import 'package:camera_for_measurement/component/pose_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../common/const/custom_units.dart';
import '../provider/picture_provider.dart';
import '../provider/pose_info_provider.dart';

class AnalysisView extends ConsumerStatefulWidget {
  const AnalysisView({super.key});

  @override
  ConsumerState<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends ConsumerState<AnalysisView> {
  bool isDetectOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: CustomUnits.margin,
          ),
          child: ListView(
            children: [
              if (ref.watch(poseInfoProvider.notifier).state != [])
                renderProcessedImage(),
              if (ref.watch(poseInfoProvider.notifier).state != [])
                Switch(
                  value: isDetectOn,
                  onChanged: (val) {
                    isDetectOn = !isDetectOn;
                    setState(() {});
                  }),
              Text('${ref.watch(poseInfoProvider.notifier).state.last}'),
              Text('${ref.watch(poseInfoProvider.notifier).state}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderProcessedImage() {
    if (ref.watch(poseInfoProvider.notifier).state.isEmpty) return Container();

    var _paintData = ref.watch(poseInfoProvider.notifier).state.last;

    Pose pose = _paintData['Pose'];
    List<Pose> poses = [];
    poses.add(pose);

    InputImage inputImage = _paintData['inputImage'];
    var imageSize = inputImage.metadata!.size;
    var rotation = inputImage.metadata!.rotation;

    var cameraLensDirection = _paintData['cameraLensDirection'];

    var painter = PosePainter(poses, imageSize, rotation, cameraLensDirection);

    CustomPaint _customPaint = CustomPaint(painter: painter);

    return Center(
      child: Container(
        // transform: Matrix4.fromList(
        //     [0.5, 0, 0, 0, 0, 0.5, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]),
        width: imageSize.width, // / 2,
        height: imageSize.height, // / 2,
        color: Colors.red.withOpacity(0.3),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (ref.watch(pictureProvider.notifier).state != null)
              Image.file(File(ref.watch(pictureProvider.notifier).state!.path)),
            if (isDetectOn) Container(child: _customPaint),
          ],
        ),
      ),
    );
  }
}
