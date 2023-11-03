import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

final poseInfoProvider = StateProvider<List<String>>((ref) => []);