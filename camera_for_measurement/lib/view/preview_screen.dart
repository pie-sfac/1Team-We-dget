import 'dart:io';
import 'package:camera_for_measurement/view/home_screen.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  const PreviewScreen({
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사진 보기')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 16,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => HomeScreen(),
                ),
                (route) => false,
              );
            },
            child: Text('홈으로'),
          ),
        ],
      ),
    );
  }
}
