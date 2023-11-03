import 'package:flutter/material.dart';

import '../common/const/custom_colors.dart';

class PersonalGallery extends StatelessWidget {
  const PersonalGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          5,
          (index) => Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              width: 100,
              height: 100,
              color: CustomColors.Primary_300,
            ),
          ),
        ),
      ),
    );
  }
}
