import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// 앱의 메인 클래스로 상태를 관리하고 UI를 구성합니다.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

// MyApp의 상태를 관리하는 클래스입니다.
class _MyAppState extends State<MyApp> {
  bool isRedPointActive = true; // 빨간색 점의 활성 상태
  bool showGrid = true; // 그리드의 표시 여부
  bool showPointLabels = true; // 점 라벨의 표시 여부

  // 빨간색 점의 표시 여부를 토글하는 함수
  void _toggleRedPoint() {
    setState(() {
      isRedPointActive = !isRedPointActive;
    });
  }

  // 그리드의 표시 여부를 토글하는 함수
  void _toggleGrid() {
    // New method to toggle grid visibility
    setState(() {
      showGrid = !showGrid;
    });
  }

  // 점 라벨의 표시 여부를 토글하는 함수
  void _togglePointLabels() {
    // New method to toggle point label visibility
    setState(() {
      showPointLabels = !showPointLabels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Graph Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Graph Demo'),
        ),
        body: Container(
          color: Colors.white,
          child: Row(
            children: [
              SideBar(
                toggleRedPoint: _toggleRedPoint,
                toggleGrid: _toggleGrid,
                togglePointLabels: _togglePointLabels,
                isRedPointActive: isRedPointActive,
                isGridActive: showGrid,
              ),
              Expanded(
                  child: BodyWeightGraph(
                showPoint: isRedPointActive,
                showGrid: showGrid,
                showPointLabels: showPointLabels,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// 사이드바 UI를 구성하는 클래스입니다.
class SideBar extends StatelessWidget {
  final VoidCallback toggleRedPoint; // Callback function
  final VoidCallback toggleGrid;
  final VoidCallback togglePointLabels;
  final bool isRedPointActive; // State variable
  final bool isGridActive;

  SideBar({
    required this.toggleRedPoint,
    required this.toggleGrid,
    required this.isRedPointActive,
    required this.isGridActive,
    required this.togglePointLabels,
  });

  // 사이드바의 ui를 구성하는 캘르시
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 250,
      color: Colors.black38,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: toggleRedPoint, // Call the callback function
            child: Text(isRedPointActive
                ? 'Deactivate Red Point'
                : 'Activate Red Point'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: togglePointLabels,
            child: Text('Toggle Point Labels'),
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 3.0),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: toggleGrid, // Call the new callback function
            child: Text(isGridActive ? 'Grid 숨기기' : 'Grid 보이기'),
          ),
        ],
      ),
    );
  }
}

class BodyWeightGraph extends StatefulWidget {
  const BodyWeightGraph(
      {Key? key,
      required this.showPoint,
      required this.showGrid,
      required this.showPointLabels})
      : super(key: key);
  final bool showPoint;
  final bool showGrid;
  final bool showPointLabels;

  @override
  _BodyWeightGraphState createState() => _BodyWeightGraphState();
}

class _BodyWeightGraphState extends State<BodyWeightGraph> {
  final TransformationController _transformationController =
      TransformationController();

  double minY = double.infinity;
  double maxY = -double.infinity;

  @override
  void initState() {
    super.initState();
    final data = [
      {'label': 'Jan', 'value': 10.0},
      // ... rest of the data
    ];

    // Calculate minY and maxY from the data
    for (var point in data) {
      double y = point['value'] as double;
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
    }
  }

  @override
  Widget build(BuildContext context) {
    double graphWidth = MediaQuery.of(context).size.width;
    double graphHeight = MediaQuery.of(context).size.height;

    // Draw axes. Axes are not scalable.
    // Draw axes. Axes are not scalable.
    Widget axis = CustomPaint(
      size: Size(graphWidth, graphHeight),
      painter: AxisPainter(
        maxY: maxY,
        minY: minY,
        step: (maxY - minY) / 10, // Assuming you want 10 steps on the y-axis
      ),
    );

    // Make only data points and lines scalable
    Widget graph = InteractiveViewer(
      transformationController:
          _transformationController, // Use _transformationController here
      minScale: 0.01,
      maxScale: 5.0,
      constrained: false,
      child: CustomPaint(
        painter: LineAndPointPainter(
            showPoint: widget.showPoint,
            showGrid: widget.showGrid,
            showPointLabels: widget.showPointLabels,
            data: [
              {'label': 'Jan', 'value': 10.0},
              {'label': 'Feb', 'value': 20.0},
              {'label': 'Mar', 'value': 25.0},
              {'label': 'Apr', 'value': 15.0},
              {'label': 'May', 'value': 30.0},
              {'label': 'Jun', 'value': 50.0},
              {'label': 'Jul', 'value': 30.0},
              {'label': 'Aug', 'value': 25.0},
              {'label': 'Sep', 'value': 10.0},
              {'label': 'Oct', 'value': 5.0},
              {'label': 'Nov', 'value': 20.0},
              {'label': 'Dec', 'value': 30.0},
            ]),
        size: Size(graphWidth, graphHeight),
      ),
    );

    return Container(
      margin: EdgeInsets.all(20),
      child: GestureDetector(
        // onTap: () {
        //   // Toggle the visibility of data points when tapped
        //   setState(() {
        //     showPoint = !showPoint;
        //   });
        // },
        child: Stack(
          children: [
            axis, // Basic axis widget
            graph, // Scalable graph widget
          ],
        ),
      ),
    );
  }
}

// 그래프의 선과 점을 그리는 커스텀 페인터 클래스 입니다.
class LineAndPointPainter extends CustomPainter {
  final bool showPoint;
  final List<Map<String, dynamic>> data; // Updated data type
  final double margin;
  final bool showGrid;
  final bool showPointLabels; // New property for showing labels

  LineAndPointPainter({
    required this.showPoint,
    required this.data,
    required this.showGrid,
    required this.showPointLabels, // New parameter
    this.margin = 50,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var pointPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;

    var textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    var gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3) // Light grey color for the grid
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double graphWidth = size.width - margin * 2;
    double graphHeight = size.height - margin * 2;
    double xStep = graphWidth / (data.length - 1);
    double maxY = data
        .map((e) => e['value'] as double)
        .reduce((value, element) => value > element ? value : element);
    double minY = data
        .map((e) => e['value'] as double)
        .reduce((value, element) => value < element ? value : element);

    // Scale the data to fit within the clipped area
    var scaledData = data.map((pointData) {
      double value = pointData['value'] as double;
      return (value - minY) / (maxY - minY) * graphHeight;
    }).toList();

    // Draw the grid if showGrid is true
    if (showGrid) {
      double xGridStep =
          graphWidth / 10; // Adjust the number of grid lines as needed
      double yGridStep = graphHeight / 10;

      for (double i = margin; i <= size.width - margin; i += xGridStep) {
        canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
      }
      for (double j = margin; j <= size.height - margin; j += yGridStep) {
        canvas.drawLine(Offset(0, j), Offset(size.width, j), gridPaint);
      }
    }

    // Draw the graph line and points
    for (int i = 0; i < scaledData.length; i++) {
      if (i < scaledData.length - 1) {
        Offset start =
            Offset(margin + i * xStep, size.height - margin - scaledData[i]);
        Offset end = Offset(
            margin + (i + 1) * xStep, size.height - margin - scaledData[i + 1]);
        canvas.drawLine(start, end, linePaint);
      }

      // Draw the point as a circle on each data point if showPoint is true
      if (showPoint) {
        Offset point =
            Offset(margin + i * xStep, size.height - margin - scaledData[i]);
        canvas.drawCircle(point, 5, pointPaint);

        // Draw the label if showPointLabels is true
        if (showPointLabels) {
          String label = data[i]['label'] as String;
          textPainter.text = TextSpan(
            text: label,
            style: TextStyle(color: Colors.black, fontSize: 12),
          );
          textPainter.layout();
          textPainter.paint(
              canvas,
              point +
                  Offset(-textPainter.width / 2,
                      -20)); // Adjust the offset as needed
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 그래프의 축을 그리는 커스텀 페인터 클래스입니다.
// 그래프의 축을 그리는 커스텀 페인터 클래스입니다.
class AxisPainter extends CustomPainter {
  final double maxY;
  final double minY;
  final double
      step; // This should be the same step used for the y-axis grid lines

  AxisPainter({
    required this.maxY,
    required this.minY,
    required this.step,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    // Draw the x-axis
    canvas.drawLine(Offset(0, size.height - 1),
        Offset(size.width, size.height - 1), axisPaint);

    // Draw the y-axis with y-values reversed to fit in the first quadrant
    canvas.drawLine(Offset(1, size.height), Offset(1, 0), axisPaint);

    // Draw labels on the y-axis for each horizontal grid line
    var textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    double graphHeight =
        size.height - 50 * 2; // Assuming margin is 50 as before
    double yGridStep = graphHeight / 10; // Assuming 10 grid lines as before

    for (double j = 50; j <= size.height - 50; j += yGridStep) {
      // Calculate the value for the grid step label
      double value = maxY - (j - 50) / graphHeight * (maxY - minY);
      String label = value.toStringAsFixed(1); // One decimal place

      // Create a text span for the label
      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(color: Colors.black, fontSize: 12),
      );

      // Layout the text painter and draw the label
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(-textPainter.width - 5, j - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
