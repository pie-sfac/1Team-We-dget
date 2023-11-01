import 'package:camera_for_measurement/common/const/custom_colors.dart';
import 'package:camera_for_measurement/common/const/custom_text_styles.dart';
import 'package:camera_for_measurement/common/const/custom_units.dart';
import 'package:camera_for_measurement/view/pose_detector_view.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  'Pose Detection',
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
