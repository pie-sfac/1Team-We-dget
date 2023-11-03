import 'dart:io';
import 'package:flutter/material.dart';
import '../../custom_painter/custom_painter.dart';
import '../../custom_painter/painter_controller.dart';

class CustomCanvas extends StatelessWidget {
  final PainterController controller;

  const CustomCanvas({
    required this.controller,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        image: controller.bgImagePath == null
            ? null
            : DecorationImage(
                image: FileImage(
                  File(controller.bgImagePath!),
                ),
                fit: BoxFit.cover,
              ),
      ),
      child: Painter(controller),
    );
  }
}
