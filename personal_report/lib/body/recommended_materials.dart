import 'package:flutter/material.dart';
import 'package:personal_report/common/const/custom_colors.dart';

class RecommendedMaterials extends StatelessWidget {
  const RecommendedMaterials({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.3,
        ),
        itemCount: 8,
        itemBuilder: (_, index) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Container(
                  width: 50, height: 50, color: CustomColors.Primary_500,
                ),
                const SizedBox(width: 16),
                Text('3분 만에 손목 강화... '),
              ],
            ),
          );
        },
      ),
    );
  }
}
