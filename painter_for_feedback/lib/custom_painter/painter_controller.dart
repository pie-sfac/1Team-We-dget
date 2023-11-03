import 'package:flutter/material.dart';
import 'custom_painter.dart';

class PainterController extends ChangeNotifier {
  Color _drawColor = Colors.black;
  Color _backgroundColor = Colors.white;
  double _thickness = 6;
  PathHistory pathHistory;
  ValueGetter<Size>? widgetFinish;
  String? bgImagePath;

  /// Creates a new instance for the use in a [Painter] widget.
  PainterController() : pathHistory = PathHistory();

  /// Retrieves the current draw color.
  Color get drawColor => _drawColor;

  /// Sets the draw color.
  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  /// Retrieves the current background color.
  Color get backgroundColor => _backgroundColor;

  /// Updates the background color.
  set backgroundColor(Color color) {
    _backgroundColor = color;
    _updatePaint();
  }

  /// Returns the current thickness that is used for drawing.
  double get thickness => _thickness;

  /// Sets the draw thickness..
  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  void _updatePaint() {
    Paint paint = Paint();

    paint.color = drawColor;
    paint.blendMode = BlendMode.srcOver;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = thickness;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;

    pathHistory.currentPaint = paint;
    pathHistory.setBackgroundColor(backgroundColor);
    notifyListeners();
  }

  void undo() {
    pathHistory.undo();
    notifyListeners();
  }

  void redo() {
    pathHistory.redo();
    notifyListeners();
  }

  void clear() {
    pathHistory.clear();
    notifyListeners();
  }
}
