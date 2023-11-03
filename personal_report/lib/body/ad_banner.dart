import 'package:flutter/material.dart';
import 'package:personal_report/common/const/custom_colors.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomColors.Primary_500,
          width: 2,
        ),
      ),
    );
  }
}
