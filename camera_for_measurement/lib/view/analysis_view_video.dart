import 'package:camera_for_measurement/component/custom_video_player.dart';
import 'package:camera_for_measurement/component/pose_painter.dart';
import 'package:camera_for_measurement/view/home_screen.dart';
import 'package:camera_for_measurement/view/on_camera_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../common/const/custom_units.dart';
import '../provider/picture_provider.dart';
import '../provider/pose_info_provider.dart';
import 'package:collection/collection.dart';

class AnalysisViewVideo extends ConsumerStatefulWidget {
  const AnalysisViewVideo({super.key});

  @override
  ConsumerState<AnalysisViewVideo> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends ConsumerState<AnalysisViewVideo> {
  bool isDetectOn = true;
  List<CustomPaint> _customPaints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => Home(),
                        ),
                        (route) => false);
                  },
                  icon: const Icon(Icons.home_outlined),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => OnCameraView(),
                        ),
                        (route) => false);
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                ),
              ],
            ),
            Spacer(),
            Text('영상 보기'),
            Spacer(flex: 2),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: CustomUnits.margin),
          child: ListView(
            children: [
              if (ref.watch(videoProvider.notifier).state != null)
                renderProcessedVideo(),
              const SizedBox(height: 16),
              if (ref.watch(poseInfoProvider.notifier).state.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _customPaints
                        .mapIndexed(
                          (index, e) => Column(
                            children: [
                              Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                  ),
                                  child: e,
                                ),
                              ),
                              Text(
                                  '${DateTime.parse(ref.read(poseInfoProvider.notifier).state[index]['createdAt']).difference(DateTime.parse(ref.read(poseInfoProvider.notifier).state.first['createdAt']))}'),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              if (ref.watch(poseInfoProvider.notifier).state.isNotEmpty)
                Switch(
                    value: isDetectOn,
                    onChanged: (val) {
                      isDetectOn = !isDetectOn;
                      setState(() {});
                    }),
              if (ref.watch(poseInfoProvider.notifier).state.isNotEmpty)
                renderAnalyzedValue(),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderAnalyzedValue() {
    final state = ref.watch(poseInfoProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('$state'),
        const SizedBox(height: 16),
        if (state.isNotEmpty)
          Center(
            child: Text('${state.length} 번 감지'),
          ),
        const SizedBox(height: 16),
        if (state.isNotEmpty)
          Text('${ref.watch(poseInfoProvider.notifier).state.mapIndexed(
                (index, e) => (e['Pose'] as Pose).landmarks.values.map(
                      (f) =>
                          'index: $index\n${f.type.name} x: ${f.x}, y: ${f.y}, z: ${f.z}, likelihood: ${f.likelihood}\n',
                    ),
              ).toList()}'),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget renderProcessedVideo() {
    if (ref.watch(poseInfoProvider.notifier).state.isNotEmpty) {
      var _multiplePaintData = ref.watch(poseInfoProvider.notifier).state;

      _customPaints = _multiplePaintData.map((_paintData) {
        Pose pose = _paintData['Pose'];
        List<Pose> poses = [];
        poses.add(pose);

        InputImage inputImage = _paintData['inputImage'];
        var imageSize = inputImage.metadata!.size;
        var rotation = inputImage.metadata!.rotation;

        var cameraLensDirection = _paintData['cameraLensDirection'];

        var painter =
            PosePainter(poses, imageSize, rotation, cameraLensDirection);

        return CustomPaint(painter: painter, size: imageSize);
      }).toList();
    }

    setState(() {});

    return SafeArea(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          color: Colors.red.withOpacity(0.3),
          child: Stack(
            children: [
              ref.watch(videoProvider.notifier).state == null
                  ? const SizedBox.shrink()
                  : Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 2,
                        child: CustomVideoPlayer(
                          video: ref.watch(videoProvider.notifier).state!,
                          customPaints: _customPaints,
                          isDetectOn: isDetectOn,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
