import 'package:camera/camera.dart';
import 'package:camera_for_measurement/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraNotifierProvider =
    StateNotifierProvider.autoDispose<CameraNotifier, CameraDescription?>(
  (ref) {
    return CameraNotifier();
  },
);

class CameraNotifier extends StateNotifier<CameraDescription?> {
  CameraNotifier() : super(cameras.isEmpty ? null : cameras.first) {
    initializeControllerFuture();
  }

  final CameraController controller =
      CameraController(cameras.first, ResolutionPreset.medium);

  Future<void> initializeControllerFuture() async {
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            //   Navigator.of(context).pop();
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(
            //       content: Text('카메라를 사용할 수 없습니다. 사용권한을 확인해 주세요.'),
            //     ),
            //   );
            break;
        }
      }
    });
  }
}

// final countModelNotifierProvider = StateNotifierProvider<CountModelNotifer, CountModel>((_) => CountModelNotifer());
//
// class CountModelNotifer extends StateNotifier<CountModel> {
//   CountModelNotifer() : super(CountModel.empty());
//
//   void increment() {
//     state = state.copyWith(value: state.value + 1, lastUpdatedAt: DateTime.now());
//   }
//
//   void decrement() {
//     state = state.copyWith(value: state.value - 1, lastUpdatedAt: DateTime.now());
//   }
// }
