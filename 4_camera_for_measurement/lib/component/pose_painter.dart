import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:camera_for_measurement/common/const/custom_colors.dart';
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
    final smallPaint = Paint()
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

    final horizontalPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.redAccent.withOpacity(0.5);

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
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
            smallPaint);
      });

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(
                translateX(joint1.x, size, imageSize, rotation, cameraLensDirection),
                translateY(joint1.y, size, imageSize, rotation, cameraLensDirection)),
            Offset(
                translateX(joint2.x, size, imageSize, rotation, cameraLensDirection),
                translateY(joint2.y, size, imageSize, rotation, cameraLensDirection)),
            paintType);
      }

      // Draw face
      paintLine(PoseLandmarkType.nose, PoseLandmarkType.rightEyeInner, smallPaint);
      paintLine(PoseLandmarkType.rightEyeInner, PoseLandmarkType.rightEye, smallPaint);
      paintLine(PoseLandmarkType.rightEye, PoseLandmarkType.rightEyeOuter, smallPaint);
      paintLine(PoseLandmarkType.rightEyeOuter, PoseLandmarkType.rightEar, smallPaint);

      paintLine(PoseLandmarkType.nose, PoseLandmarkType.leftEyeInner, smallPaint);
      paintLine(PoseLandmarkType.leftEyeInner, PoseLandmarkType.leftEye, smallPaint);
      paintLine(PoseLandmarkType.leftEye, PoseLandmarkType.leftEyeOuter, smallPaint);
      paintLine(PoseLandmarkType.leftEyeOuter, PoseLandmarkType.leftEar, smallPaint);

      paintLine(PoseLandmarkType.leftEyeInner, PoseLandmarkType.rightEyeInner, horizontalPaint);
      paintLine(PoseLandmarkType.leftEar, PoseLandmarkType.rightEar, horizontalPaint);

      paintLine(PoseLandmarkType.leftMouth, PoseLandmarkType.rightMouth, connectPaint);

      // Draw upper body
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder, connectPaint);

      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      paintLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftThumb, leftPaint);
      paintLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftIndex, leftPaint);
      paintLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftPinky, leftPaint);
      paintLine(PoseLandmarkType.leftIndex, PoseLandmarkType.leftPinky, leftPaint);

      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);
      paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);
      paintLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightThumb, rightPaint);
      paintLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightIndex, rightPaint);
      paintLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightPinky, rightPaint);
      paintLine(PoseLandmarkType.rightIndex, PoseLandmarkType.rightPinky, rightPaint);

      // Draw lower body
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, connectPaint);

      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel, leftPaint);
      paintLine(PoseLandmarkType.leftHeel, PoseLandmarkType.leftFootIndex, leftPaint);
      paintLine(PoseLandmarkType.leftFootIndex, PoseLandmarkType.leftAnkle, leftPaint);

      paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
      paintLine(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel, rightPaint);
      paintLine(PoseLandmarkType.rightHeel, PoseLandmarkType.rightFootIndex, rightPaint);
      paintLine(PoseLandmarkType.rightFootIndex, PoseLandmarkType.rightAnkle, rightPaint);

      // check horizontal balance
      paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.rightKnee, horizontalPaint);
      paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.rightElbow, horizontalPaint);

      // Calculate angle
      var angleKneeRight = getAngle(pose, PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
      var angleRightHip = getAngle(pose, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
      var angleRightShoulder = getAngle(pose, PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
      var angleKneeLeft = getAngle(pose, PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
      var angleLeftHip = getAngle(pose, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
      var angleLeftShoulder = getAngle(pose, PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);

      // Draw angle at important points
      drawAngle(PoseLandmarkType.rightKnee, angleKneeRight, pose, size, canvas);
      drawAngle(PoseLandmarkType.rightHip, angleRightHip, pose, size, canvas);
      drawAngle(PoseLandmarkType.rightShoulder, angleRightShoulder, pose, size, canvas);
      drawAngle(PoseLandmarkType.leftKnee, angleKneeLeft, pose, size, canvas);
      drawAngle(PoseLandmarkType.leftHip, angleLeftHip, pose, size, canvas);
      drawAngle(PoseLandmarkType.leftShoulder, angleLeftShoulder, pose, size, canvas);

      if (angleLeftShoulder >= 80.0 && angleLeftShoulder <= 100.0) {
        drawFeedbackCircle(PoseLandmarkType.leftShoulder, angleLeftShoulder,
            pose, size, canvas);
      }

      if (angleRightShoulder >= 80.0 && angleRightShoulder <= 100.0) {
        drawFeedbackCircle(PoseLandmarkType.rightShoulder, angleRightShoulder,
            pose, size, canvas);
      }
    }
  }

  drawAngle(
    PoseLandmarkType poseLandmarkType,
    double angle,
    Pose pose,
    Size size,
    Canvas canvas,
  ) {
    final background = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.black;

    final paragraphStyle = ParagraphStyle(
      textAlign: TextAlign.left,
      fontSize: 12,
      textDirection: TextDirection.ltr,
    );

    var builder = ParagraphBuilder(paragraphStyle);
    builder.pushStyle(
      ui.TextStyle(color: Colors.white, background: background),
    );
    builder.addText(angle.toStringAsFixed(1));
    builder.pop();

    final joint = pose.landmarks[poseLandmarkType]!;

    var textOffset = Offset(
      translateX(joint.x, size, imageSize, rotation, cameraLensDirection),
      translateY(joint.y, size, imageSize, rotation, cameraLensDirection),
    );

    canvas.drawParagraph(
      builder.build()..layout(const ParagraphConstraints(width: 100)),
      textOffset,
    );
  }

  drawFeedbackCircle(
    PoseLandmarkType poseLandmarkType,
    double angle,
    Pose pose,
    Size size,
    Canvas canvas,
  ) {
    final correctPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = CustomColors.Primary_500;

    final joint = pose.landmarks[poseLandmarkType]!;

    var offset = Offset(
      translateX(joint.x, size, imageSize, rotation, cameraLensDirection),
      translateY(joint.y, size, imageSize, rotation, cameraLensDirection),
    );

    canvas.drawCircle(offset, 20, correctPaint);
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
