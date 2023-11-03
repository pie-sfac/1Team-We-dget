import 'package:camera/camera.dart';
import 'package:camera_for_measurement/provider/camera_notifier_provider.dart';
import 'package:camera_for_measurement/view/camera_screen.dart';
import 'package:camera_for_measurement/view/detection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cameraNotifierProvider);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (state == null) const Text('사용할 수 있는 카메라가 없습니다.'),
            if (state != null) Text('[temp] 사용카메라: $state'),
            if (state != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CameraScreen(),
                    ),
                  );
                },
                child: Text('카메라 사용하기'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DetectionScreen(),
                  ),
                );
              },
              child: Text('Pose Detection'),
            ),
          ],
        ),
      ),
    );
  }
}
