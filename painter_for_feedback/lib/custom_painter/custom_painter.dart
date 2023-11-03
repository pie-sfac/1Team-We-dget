import 'package:flutter/material.dart';
import '../custom_painter/painter_controller.dart';

class Painter extends StatefulWidget {
  final PainterController painterController;

  Painter(
    this.painterController,
  ) : super(key: ValueKey<PainterController>(painterController));

  @override
  PainterState createState() => PainterState();
}

class PainterState extends State<Painter> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      child: CustomPaint(
        painter: _PainterPainter(widget.painterController.pathHistory),
      ),
    );
  }

  bool _isWithinContainer(Offset pos) {
    final containerSize = (context.findRenderObject() as RenderBox).size;

    return pos.dx >= 0 &&
        pos.dx <= containerSize.width &&
        pos.dy >= 0 &&
        pos.dy <= containerSize.height;
  }

  void _onPanStart(DragStartDetails start) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(start.globalPosition);

    if (_isWithinContainer(pos)) {
      setState(() {
        widget.painterController.pathHistory.add(pos);
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails update) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);

    if (_isWithinContainer(pos)) {
      setState(() {
        widget.painterController.pathHistory.updateCurrent(pos);
      });
    }
  }
}

class _PainterPainter extends CustomPainter {
  final PathHistory _path;

  _PainterPainter(this._path, {Listenable? repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_PainterPainter oldDelegate) {
    return true;
  }
}

class PathHistory {
  List<MapEntry<Path, Paint>> paths;
  List<MapEntry<Path, Paint>> undonePaths; // For storing undone paths
  Paint currentPaint;
  final Paint _backgroundPaint;
  bool isExpanded;

  PathHistory()
      : paths = <MapEntry<Path, Paint>>[],
        undonePaths = <MapEntry<Path, Paint>>[],
        isExpanded = false,
        _backgroundPaint = Paint()..blendMode = BlendMode.dstOver,
        currentPaint = Paint();

  void setBackgroundColor(Color backgroundColor) {
    _backgroundPaint.color = backgroundColor;
  }

  void undo() {
    if (paths.isNotEmpty) {
      undonePaths.add(paths.removeLast());
    }
  }

  void redo() {
    if (undonePaths.isNotEmpty) {
      paths.add(undonePaths.removeLast());
    }
  }

  void clear() {
    paths.clear();
    undonePaths.clear();
  }

  void add(Offset startPoint) {
    Path path = Path()..moveTo(startPoint.dx, startPoint.dy);

    paths.add(MapEntry<Path, Paint>(path, currentPaint));
    undonePaths.clear();
  }

  void updateCurrent(Offset nextPoint) {
    paths.last.key.lineTo(nextPoint.dx, nextPoint.dy);
  }

  void draw(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    setBackgroundColor(Colors.transparent);

    for (MapEntry<Path, Paint> pathEntry in paths) {
      Path path = pathEntry.key;
      Paint paint = pathEntry.value;

      // Set paint properties
      paint
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..blendMode =
            (paint.color == const Color(0xFFFFFFFE)) ? BlendMode.clear : BlendMode.src;

      // Draw the path on the canvas
      canvas.drawPath(path, paint);
    }

    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      _backgroundPaint,
    );
    canvas.restore();
  }
}
