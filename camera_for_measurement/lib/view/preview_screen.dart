import 'dart:io';
import 'package:camera_for_measurement/provider/image_provider.dart';
import 'package:camera_for_measurement/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviewScreen extends ConsumerWidget {
  final String imagePath;

  const PreviewScreen({
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('사진 보기')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(
              File(ref.read(imageProvider.notifier).state!.path),
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
      ),
    );
  }
}
