import 'package:camera_for_measurement/common/const/custom_colors.dart';
import 'package:camera_for_measurement/common/const/custom_text_styles.dart';
import 'package:camera_for_measurement/common/const/custom_units.dart';
import 'package:camera_for_measurement/view/analysis_view.dart';
import 'package:camera_for_measurement/view/pose_detector_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자세 측정 카메라'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: CustomUnits.margin,
          ),
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PoseDetectorView(),
                    ),
                  );
                },
                child: Text(
                  'Pose Detection (사진 찍기)',
                  style: CustomTextStyles.Body1.copyWith(
                    color: CustomColors.Gray_50,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const AnalysisView(),
                      ),
                      (route) => false);
                },
                child: Text(
                  'Pose Analysis (사진 보기)',
                  style: CustomTextStyles.Body1.copyWith(
                    color: CustomColors.Gray_50,
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
