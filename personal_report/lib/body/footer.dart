import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      color: Colors.grey.withOpacity(0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.building_2_fill),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('포인티센터'),
              Text('서울시 남부순환로 1801, 라피스 빌딩 8층'),
              Text('02-840-9002'),
              Row(
                children: [
                  Text('카카오톡 문의 :'),
                  TextButton(
                    onPressed: () {},
                    child: Text('포인티 센터 바로가기'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
