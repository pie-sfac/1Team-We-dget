import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:camera_for_measurement/component/pose_painter.dart';
import 'package:camera_for_measurement/provider/pose_info_provider.dart';
import 'package:camera_for_measurement/view/analysis_view_video.dart';
import 'package:camera_for_measurement/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../common/const/custom_colors.dart';
import '../common/const/custom_text_styles.dart';
import '../common/const/custom_units.dart';
import '../provider/picture_provider.dart';
import 'analysis_view_camera.dart';

class OnCameraView extends ConsumerStatefulWidget {
  const OnCameraView({super.key});

  @override
  ConsumerState<OnCameraView> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends ConsumerState<OnCameraView> {
  static List<CameraDescription> _cameras = [];
  int _cameraIndex = -1;
  CameraController? _controller;

  bool _changingCameraLens = false;

  GlobalKey previewContainerKey = GlobalKey();

  bool _liveStreamOn = true;

  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  bool _isTakingPicture = false;
  bool _isTakingVideo = false;
  CustomPaint? _customPaint;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();

    _initialize();
    _isTakingPicture = false;
    _isTakingVideo = false;
  }

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();

    // _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light),
    );

    return Scaffold(
      body: (_cameras.isEmpty ||
              _controller == null ||
              _controller?.value.isInitialized == false)
          ? Container()
          : Container(
              color: Colors.black,
              child: Stack(
                children: [
                  _changingCameraLens
                      ? Center(
                          child: Text(
                            '카메라 렌즈를 바꾸는 중입니다 ...',
                            style: CustomTextStyles.Body1.copyWith(
                              color: CustomColors.Gray_50,
                            ),
                          ),
                        )
                      : Center(
                          child: RepaintBoundary(
                            key: previewContainerKey,
                            child: CameraPreview(
                              _controller!,
                              child: _liveStreamOn ? _customPaint : null,
                            ),
                          ),
                        ),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: CustomUnits.buttonMargin,
                            vertical: CustomUnits.buttonMargin / 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _backButton(),
                              Expanded(
                                child: _exposureControl(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: CustomUnits.buttonMargin,
                            vertical: CustomUnits.buttonMargin / 2,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _zoomControl(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: _detectionSwitch()),
                                  Expanded(child: _cameraButton()),
                                  Expanded(child: _videoButton()),
                                  Expanded(child: _switchLiveCameraToggle()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _backButton() => SizedBox(
        height: 50.0,
        width: 50.0,
        child: FloatingActionButton(
          heroTag: Object(),
          elevation: 0,
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => Home(),
              ),
              (route) => false),
          backgroundColor: CustomColors.Primary_300,
          child: Icon(
            Icons.chevron_left,
            color: CustomColors.Gray_50,
            size: 40,
          ),
        ),
      );

  Widget _exposureControl() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Slider(
              value: _currentExposureOffset,
              min: _minAvailableExposureOffset,
              max: _maxAvailableExposureOffset,
              activeColor: CustomColors.Gray_50,
              inactiveColor: CustomColors.Gray_300,
              onChanged: (value) async {
                setState(() {
                  _currentExposureOffset = value;
                });
                await _controller?.setExposureOffset(value);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: CustomColors.Gray_900,
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  '${_currentExposureOffset.toStringAsFixed(1)}x',
                  style: CustomTextStyles.Caption1.copyWith(
                    color: CustomColors.Gray_50,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _zoomControl() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Slider(
              value: _currentZoomLevel,
              min: _minAvailableZoom,
              max: min(_maxAvailableZoom, 5),
              activeColor: CustomColors.Gray_50,
              inactiveColor: CustomColors.Gray_300,
              onChanged: (value) async {
                setState(() {
                  _currentZoomLevel = value;
                });
                await _controller?.setZoomLevel(value);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: CustomColors.Gray_900,
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  '${_currentZoomLevel.toStringAsFixed(1)}x',
                  style: CustomTextStyles.Caption1.copyWith(
                    color: CustomColors.Gray_50,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _detectionSwitch() {
    return SizedBox(
      height: 50.0,
      width: 50.0,
      child: Switch(
        value: _liveStreamOn,
        activeColor: CustomColors.Primary_500,
        onChanged: (bool value) {
          setState(() {
            _liveStreamOn = !_liveStreamOn;
            !_liveStreamOn
                ? _stopPoseDetector()
                : _startPoseDetector(_cameras[_cameraIndex]);
          });
        },
      ),
    );
  }

  Widget _cameraButton() {
    return SizedBox(
      height: 70.0,
      width: 70.0,
      child: FloatingActionButton(
        heroTag: Object(),
        elevation: 0,
        onPressed: _captureAndShowImage,
        backgroundColor: CustomColors.Primary_300,
        child: Icon(
          Icons.fiber_manual_record,
          color: CustomColors.Gray_50,
          size: 70,
        ),
      ),
    );
  }

  Widget _videoButton() {
    return SizedBox(
      height: 70.0,
      width: 70.0,
      child: FloatingActionButton(
        heroTag: Object(),
        elevation: 0,
        onPressed: _recordAndShowVideo,
        backgroundColor: CustomColors.Erro,
        child: Icon(
          Icons.fiber_manual_record,
          color: CustomColors.Gray_50,
          size: 70,
        ),
      ),
    );
  }

  Widget _switchLiveCameraToggle() {
    return SizedBox(
      height: 50.0,
      width: 50.0,
      child: FloatingActionButton(
        heroTag: Object(),
        elevation: 0,
        onPressed: () => _switchLiveCamera(_cameras[_cameraIndex]),
        backgroundColor: CustomColors.Primary_300,
        child: Icon(
          Platform.isIOS
              ? Icons.flip_camera_ios_outlined
              : Icons.flip_camera_android_outlined,
          color: CustomColors.Gray_50,
          size: 25,
        ),
      ),
    );
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == _cameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) return;

      _controller?.getMinZoomLevel().then((value) {
        _currentZoomLevel = value;
        _minAvailableZoom = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        _maxAvailableZoom = value;
      });
      _currentExposureOffset = 0.0;
      _controller?.getMinExposureOffset().then((value) {
        _minAvailableExposureOffset = value;
      });
      _controller?.getMaxExposureOffset().then((value) {
        _maxAvailableExposureOffset = value;
      });
      _controller?.startImageStream(_processCameraImage).then((value) {
        _cameraLensDirection = camera.lensDirection;
      });
      setState(() {});
    });
  }

  Future _switchLiveCamera(camera) async {
    if (!_liveStreamOn) {
      _liveStreamOn = true;
      _startPoseDetector(camera);
    }

    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  // 사진을 찍으면 AnalysisView 로 이동
  Future<void> _captureAndShowImage() async {
    _isTakingPicture = true;

    ref.read(poseInfoProvider.notifier).state.clear();

    final picture = await _controller?.takePicture();
    ref.read(pictureProvider.notifier).state = picture;

    // print(ref.read(poseInfoProvider));

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const AnalysisViewCamera(),
      ),
      (route) => false,
    );
  }

  Future<void> _recordAndShowVideo() async {
    _isTakingVideo = true;

    ref.read(poseInfoProvider.notifier).state.clear();

    await _controller?.startVideoRecording();
    print('record started');
    /// Take on video for 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    final video = await _controller?.stopVideoRecording();
    print('record finished');

    ref.read(videoProvider.notifier).state = video;

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const AnalysisViewVideo(),
      ),
      (route) => false,
    );
  }

  Future _stopPoseDetector() async {
    await _controller?.stopImageStream();
  }

  Future _startPoseDetector(camera) async {
    _controller?.startImageStream(_processCameraImage).then((value) {
      _cameraLensDirection = camera.lensDirection;
    });
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;

    _processImage(inputImage);
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  Future<void> _processImage(
    InputImage inputImage,
  ) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    List<Pose> poses = await _poseDetector.processImage(inputImage);

    Future.delayed(const Duration(seconds: 2), () {
      _isTakingVideo = false;
    });

    if (poses.isNotEmpty) {
      var info = {
        'createdAt': '${DateTime.now()}',
        'Pose': poses.first,
        'inputImage': inputImage,
        'cameraLensDirection': _cameraLensDirection,
      };

      ref.read(poseInfoProvider.notifier).state.add(info);
    }

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
