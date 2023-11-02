import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:camera_for_measurement/common/const/custom_colors.dart';
import 'package:camera_for_measurement/common/const/custom_text_styles.dart';
import 'package:camera_for_measurement/common/const/custom_units.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:path_provider/path_provider.dart';

class CameraView extends StatefulWidget {
  static String get routeName => 'camera';

  const CameraView(
      {Key? key,
      required this.customPaint,
      required this.onImage,
      this.onCameraFeedReady,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.back})
      : super(key: key);

  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final VoidCallback? onCameraFeedReady;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  bool _changingCameraLens = false;
  bool _liveStreamOn = true;

  XFile? imageFile;
  XFile? videoFile;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
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
      body: _liveFeedBody(),
    );
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
    return Container(
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
                  child: CameraPreview(
                    _controller!,
                    child: _liveStreamOn ? widget.customPaint : null,
                  ),
                ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.black,
                  child: Padding(
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
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: CustomUnits.buttonMargin,
                      vertical: CustomUnits.buttonMargin / 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _zoomControl(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _detectionSwitch()),
                            Expanded(child: _cameraButton()),
                            Expanded(child: _switchLiveCameraToggle()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton() => SizedBox(
        height: 50.0,
        width: 50.0,
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () => Navigator.of(context).pop(),
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
        elevation: 0,
        onPressed: () {
          _controller?.takePicture();
        },
        backgroundColor: CustomColors.Primary_300,
        child: Icon(
          Icons.fiber_manual_record,
          color: CustomColors.Gray_50,
          size: 60,
        ),
      ),
    );
  }

  Widget _switchLiveCameraToggle() {
    return SizedBox(
      height: 50.0,
      width: 50.0,
      child: FloatingActionButton(
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
      if (!mounted) {
        return;
      }
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
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      // _startPoseDetector(camera);
      setState(() {});
    });
  }

  Future _startPoseDetector(camera) async {
    _controller?.startImageStream(_processCameraImage).then((value) {
      if (widget.onCameraFeedReady != null) {
        widget.onCameraFeedReady!();
      }
      if (widget.onCameraLensDirectionChanged != null) {
        widget.onCameraLensDirectionChanged!(camera.lensDirection);
      }
    });
  }

  Future _stopPoseDetector() async {
    await _controller?.stopImageStream();
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera(camera) async {
    if (!_liveStreamOn) {
      _liveStreamOn = true;
      _startPoseDetector(camera);
    }

    setState(() => _changingCameraLens = true);
    _cameraIndex =  (_cameraIndex + 1) % _cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

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

  void onTakePictureButtonPressed() {
    _controller?.takePicture().then((XFile? file) async {
      // final String filePath = (await getApplicationDocumentsDirectory()).path;

      if (mounted) {
        setState(() {
          imageFile = file;
        });
        if (file != null) {
          // ToDo
          // final fileName = file.path;
          // await file.saveTo('$filePath/$fileName');

          // if (!mounted) return;
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Picture saved to ${file.path}'),
          //   ),
          // );
        }
      }
    });
  }
}
