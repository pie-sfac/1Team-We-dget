import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pinch to Zoom Line Graph'),
        ),
        body: LineGraph(),
      ),
    );
  }
}

class LineGraph extends StatefulWidget {
  @override
  _LineGraphState createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double graphWidth = screenSize.width * _scale;

    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _previousScale = _scale;
        setState(() {});
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = _previousScale * details.scale;
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        _previousScale = 1.0;
        setState(() {});
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: graphWidth,
          height: screenSize.height,
          child: CustomPaint(
            painter: LineGraphPainter(),
          ),
        ),
      ),
    );
  }
}

class LineGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Example list of data points
    List<Offset> points = List.generate(40, (index) {
      // Modulating the index to create a wave effect on the graph
      double x = (size.width / 40) * index;
      double y =
          size.height / 2 + (size.height / 4) * (index % 2 == 0 ? -1 : 1);
      return Offset(x, y);
    });

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
