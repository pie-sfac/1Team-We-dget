import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pictureProvider = StateProvider<XFile?>((ref) => null);

final sizeProvider = StateProvider<Size>((ref) => Size(0, 0));

final videoProvider = StateProvider<XFile?>((ref) => null);