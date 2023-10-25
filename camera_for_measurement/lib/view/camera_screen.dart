import 'package:camera/camera.dart';
import 'package:camera_for_measurement/provider/camera_provider.dart';
import 'package:camera_for_measurement/view/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cameraNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 촬영하기'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$state'),
          Expanded(
            child: CameraPreview(
              ref.read(cameraNotifierProvider.notifier).controller,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final cameraController =
                ref.read(cameraNotifierProvider.notifier).controller;

            final image = await cameraController.takePicture().catchError(
              (Object e) {
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

            if (!mounted) return;

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PreviewScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
