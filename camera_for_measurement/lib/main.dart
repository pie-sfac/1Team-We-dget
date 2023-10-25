import 'package:camera/camera.dart';
import 'package:camera_for_measurement/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late final List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}
