import 'package:camera/camera.dart';
import 'package:camera_for_measurement/provider/camera_notifier_provider.dart';
import 'package:camera_for_measurement/provider/image_provider.dart';
import 'package:camera_for_measurement/view/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraScreen extends ConsumerWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cameraNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 촬영하기'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('$state'),
            CameraPreview(
              ref.read(cameraNotifierProvider.notifier).controller,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final cameraController =
                ref.read(cameraNotifierProvider.notifier).controller;

            final image = await cameraController.takePicture().catchError(
              (Object e) {
                // ToDo: 에러 케이스 정리
                if (e is CameraException) {
                  switch (e.code) {
                    case 'CameraAccessDenied':
                      // Handle access errors here.
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('카메라를 사용할 수 없습니다. 사용권한을 확인해 주세요.'),
                        ),
                      );
                      break;
                    default:
                      // Handle other errors here.
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('에러를 확인해 주세요. $e'),
                        ),
                      );
                      print(e);
                      break;
                  }
                }
              },
            );

            ref.read(imageProvider.notifier).state = image;

            if (ref.read(imageProvider.notifier).state != null) {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PreviewScreen(
                    imagePath: image.path,
                  ),
                ),
              );
            }
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
