import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Canvas Zoom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pinch to Zoom"),
      ),
      body: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          _previousScale = _scale;
          setState(() {});
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          _scale = _previousScale * details.scale;
          setState(() {});
        },
        onScaleEnd: (ScaleEndDetails details) {
          _previousScale = 1.0;
          setState(() {});
        },
        child: CustomPaint(
          painter: MyCustomPainter(_scale),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  final double scale;

  MyCustomPainter(this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    var backgroundPaint = Paint()..color = Colors.yellow;

    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Apply the scale as a transformation
    final Matrix4 matrix4 = Matrix4.identity()..scale(scale, scale, 1.0);
    canvas.transform(matrix4.storage);

    // Draw something on the canvas
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(centerX, centerY), 100.0 * scale, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // You can optimize this to only repaint when needed
  }
}
