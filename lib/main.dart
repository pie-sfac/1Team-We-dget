import 'package:flutter/material.dart';

const List<String> dropdownMenuList = <String>[
  'BodyWeightGraph',
  'LineGraph',
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _selectedWidget = Container(); // Default widget

  void _onDropDownChanged(Widget newWidget) {
    setState(() {
      _selectedWidget = newWidget;
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
              SideBar(onChanged: (String newValue) {
                switch (newValue) {
                  case 'BodyWeightGraph':
                    _onDropDownChanged(BodyWeightGraph());
                    break;
                  case 'LineGraph':
                    _onDropDownChanged(LineGraph());
                    break;
                }
              }),
              Expanded(
                child: _selectedWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  SideBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 250,
      color: Colors.black38,
      child: Column(
        children: [
          ListTile(
            title: SideDropDownButton(
              onChanged: onChanged,
              dropdownMenuList: dropdownMenuList,
            ),
          ),
        ],
      ),
    );
  }
}

class BodyWeightGraph extends StatefulWidget {
  const BodyWeightGraph({Key? key}) : super(key: key);

  @override
  _BodyWeightGraphState createState() => _BodyWeightGraphState();
}

class _BodyWeightGraphState extends State<BodyWeightGraph> {
  bool showPoint = true; // Control the visibility of the point

  void _togglePointVisibility() {
    setState(() {
      showPoint = !showPoint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _togglePointVisibility, // Toggle point on double tap
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: LineGraphPainter(showPoint: showPoint),
      ),
    );
  }
}

class LineGraphPainter extends CustomPainter {
  final bool showPoint;
  final List<double> data = [70, 72, 68, 74, 72, 70, 67]; // Example data

  LineGraphPainter({required this.showPoint});

  @override
  void paint(Canvas canvas, Size size) {
    // Define the paint color
    var backgroundPaint = Paint()
      ..color = Colors.yellow; // Change this to your desired color

    // Draw a rectangle with the paint
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    var linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var pointPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;

    double margin = 50;
    double graphWidth = size.width - margin * 2;
    double graphHeight = size.height - margin * 2;
    double xStep = graphWidth / (data.length - 1);
    double maxY =
        data.reduce((value, element) => value > element ? value : element);
    double minY =
        data.reduce((value, element) => value < element ? value : element);

    // Draw X and Y axis
    canvas.drawLine(Offset(margin, size.height - margin),
        Offset(size.width - margin, size.height - margin), linePaint);
    canvas.drawLine(Offset(margin, margin),
        Offset(margin, size.height - margin), linePaint);

    // Scale the data to fit the canvas
    var scaledData = data
        .map((weight) => (weight - minY) / (maxY - minY) * graphHeight)
        .toList();

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
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class SideDropDownButton extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final List<String> dropdownMenuList;

  SideDropDownButton({required this.onChanged, required this.dropdownMenuList});

  @override
  _SideDropDownButtonState createState() => _SideDropDownButtonState();
}

class _SideDropDownButtonState extends State<SideDropDownButton> {
  String _selectedValue = dropdownMenuList.first;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget
        .dropdownMenuList.first; // Set the default value to the first item
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          _selectedValue = newValue!;
        });
        widget.onChanged(newValue!);
      },
      items:
          widget.dropdownMenuList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
            painter: LineGraphPainter2(),
          ),
        ),
      ),
    );
  }
}

class LineGraphPainter2 extends CustomPainter {
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

    // Connect all data points with a line
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
