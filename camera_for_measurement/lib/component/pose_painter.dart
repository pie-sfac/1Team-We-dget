import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'coordinates_translator.dart';

class PosePainter extends CustomPainter {
  PosePainter(
    this.poses,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.green;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    final connectPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.redAccent;

    final dottedPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.redAccent.withOpacity(0.5);

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        // var poseLandMark = pose.landmarks.values as PoseLandmark;
        // print(
        //     'Pose: ${poseLandMark.type}, Offset: (${poseLandMark.x}, ${poseLandMark.y}, z: ${poseLandMark.z}, likelihood: ${poseLandMark.likelihood})');

        canvas.drawCircle(
            Offset(
              translateX(
                landmark.x,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
              translateY(
                landmark.y,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
            ),
            1,
            paint);
      });

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(
                translateX(
                  joint1.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint1.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            Offset(
                translateX(
                  joint2.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint2.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            paintType);
      }

      //Draw arms
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          rightPaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      //Draw Body
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
          rightPaint);

      //Draw legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

      //Connect left and right
      paintLine(
          PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, connectPaint);
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder,
          connectPaint);

      //Connect left and right - dotted
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.rightKnee, dottedPaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.rightElbow, dottedPaint);

      //calculate joint angle
      var angleKneeRight = getAngle(
        pose,
        PoseLandmarkType.rightHip,
        PoseLandmarkType.rightKnee,
        PoseLandmarkType.rightAnkle,
      );

      var angleHipRight = getAngle(
        pose,
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightHip,
        PoseLandmarkType.rightKnee,
      );

      final background = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = Colors.black;

      final builder_angleKneeRight = ParagraphBuilder(
        ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 12,
          textDirection: TextDirection.ltr,
        ),
      );
      builder_angleKneeRight.pushStyle(
        ui.TextStyle(
          color: Colors.white,
          background: background,
        ),
      );
      builder_angleKneeRight.addText(angleKneeRight.toStringAsFixed(1));
      builder_angleKneeRight.pop();

      final builder_angleHipRight = ParagraphBuilder(
        ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 12,
          textDirection: TextDirection.ltr,
        ),
      );
      builder_angleHipRight.pushStyle(
        ui.TextStyle(
          color: Colors.white,
          background: background,
        ),
      );
      builder_angleHipRight.addText(angleHipRight.toStringAsFixed(1));
      builder_angleHipRight.pop();

      final rkJoint = pose.landmarks[PoseLandmarkType.rightKnee]!;
      final rhJoint = pose.landmarks[PoseLandmarkType.rightHip]!;

      var textOffset = Offset(
          translateX(
            rkJoint.x,
            size,
            imageSize,
            rotation,
            cameraLensDirection,
          ),
          translateY(
            rkJoint.y,
            size,
            imageSize,
            rotation,
            cameraLensDirection,
          ));
      canvas.drawParagraph(
        builder_angleKneeRight.build()..layout(const ParagraphConstraints(width: 100)),
        textOffset,
      );

      textOffset = Offset(
          translateX(
            rhJoint.x,
            size,
            imageSize,
            rotation,
            cameraLensDirection,
          ),
          translateY(
            rhJoint.y,
            size,
            imageSize,
            rotation,
            cameraLensDirection,
          ));
      canvas.drawParagraph(
        builder_angleHipRight.build()..layout(const ParagraphConstraints(width: 100)),
        textOffset,
      );
    }
  }

  double getAngle(
      pose, PoseLandmarkType a, PoseLandmarkType b, PoseLandmarkType c) {
    final PoseLandmark joint1 = pose.landmarks[a];
    final PoseLandmark joint2 = pose.landmarks[b];
    final PoseLandmark joint3 = pose.landmarks[c];

    var radians = atan2(joint3.y - joint2.y, joint3.x - joint2.x) -
        atan2(joint1.y - joint2.y, joint1.x - joint2.x);

    var angle = (radians * 180 / pi).abs();
    if (angle > 180) angle = 360 - angle;

    return angle;
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}
