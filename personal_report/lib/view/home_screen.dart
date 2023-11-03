import 'package:flutter/material.dart';
import 'package:personal_report/body/ad_banner.dart';
import 'package:personal_report/body/footer.dart';
import 'package:personal_report/body/greetings.dart';
import 'package:personal_report/body/personal_gallery.dart';
import 'package:personal_report/body/rating.dart';
import 'package:personal_report/body/recommended_materials.dart';
import 'package:personal_report/body/share_to.dart';
import 'package:personal_report/body/visualization_condition.dart';
import 'package:personal_report/body/visualization_pain.dart';

import '../body/feedback.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Greetings(),
            AdBanner(),
            renderTitle('박승환 회원님 영상 및 이미지'),
            PersonalGallery(),
            renderTitle('김파이 선생님 피드백'),
            CustomFeedback(),
            renderTitle('센터 추천 링크'),
            RecommendedMaterials(),
            renderTitle('통증 변화'),
            VisualizationPain(),
            renderTitle('컨디션 변화'),
            VisualizationCondition(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '만족도 및 후기',
                textAlign: TextAlign.center,
              ),
            ),
            Rating(),
            ShareTo(),
            Footer(),
          ],
        ),
      ),
    );
  }

  renderTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16,
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
          ),
          const SizedBox(width: 4),
          Text(title),
        ],
      ),
    );
  }
}
