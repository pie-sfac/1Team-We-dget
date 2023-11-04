import 'dart:math';
import 'package:flutter/material.dart';

class LineGraph extends StatelessWidget {
  final List<WeightData> data;
  final Color lineColor;
  final double lineWidth;

  const LineGraph({
    Key? key,
    required this.data,
    this.lineColor = Colors.blue,
    this.lineWidth = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite, // Graph will take all available space
      painter: GraphPainter(
        data: data,
        lineColor: lineColor,
        lineWidth: lineWidth,
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<WeightData> data;
  final Color lineColor;
  final double lineWidth;

  GraphPainter({
    required this.data,
    required this.lineColor,
    required this.lineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    // Calculate scale based on given data
    double maxX =
        data.map((e) => e.date.millisecondsSinceEpoch.toDouble()).reduce(max);
    double minX =
        data.map((e) => e.date.millisecondsSinceEpoch.toDouble()).reduce(min);
    double maxY = data.map((e) => e.weight).reduce(max);
    double minY = data.map((e) => e.weight).reduce(min);

    // Function to scale and translate the weight data to canvas coordinates
    Offset scalePoint(DateTime date, double weight) {
      return Offset(
        (date.millisecondsSinceEpoch - minX) / (maxX - minX) * size.width,
        size.height - (weight - minY) / (maxY - minY) * size.height,
      );
    }

    // Draw axes
    final axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    // Y Axis
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), axisPaint);
    // X Axis
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), axisPaint);

    // Draw lines for graph
    Path path = Path();
    if (data.isNotEmpty) {
      path.moveTo(scalePoint(data.first.date, data.first.weight).dx,
          scalePoint(data.first.date, data.first.weight).dy);
      for (var weightData in data) {
        path.lineTo(scalePoint(weightData.date, weightData.weight).dx,
            scalePoint(weightData.date, weightData.weight).dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WeightData {
  final DateTime date;
  final double weight;

  WeightData({required this.date, required this.weight});
}
