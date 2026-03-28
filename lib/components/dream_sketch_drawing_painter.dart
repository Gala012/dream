import 'package:flutter/material.dart';
class DrawingStroke {
  final List<Offset> points;
  final Color color;
  final double width;
  const DrawingStroke({
    required this.points,
    required this.color,
    required this.width,
  });
  bool containsPoint(Offset point, double radius) {
    for (final p in points) {
      if ((p - point).distance <= radius + width / 2) return true;
    }
    return false;
  }
}
class DrawingPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final DrawingStroke? currentStroke;
  final bool isEraserMode;
  final Offset? eraserPosition;
  final double eraserRadius;
  final bool drawBackground;
  const DrawingPainter({
    required this.strokes,
    this.currentStroke,
    this.isEraserMode = false,
    this.eraserPosition,
    this.eraserRadius = 20.0,
    this.drawBackground = false,
  });
  @override
  void paint(Canvas canvas, Size size) {
    if (drawBackground) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.white,
      );
    }
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }
    if (currentStroke != null) {
      _drawStroke(canvas, currentStroke!);
    }
    if (isEraserMode && eraserPosition != null) {
      _drawEraserIndicator(canvas, eraserPosition!);
    }
  }
  void _drawStroke(Canvas canvas, DrawingStroke stroke) {
    if (stroke.points.isEmpty) return;
    final paint = Paint()
      ..color = stroke.color
      ..strokeWidth = stroke.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    if (stroke.points.length == 1) {
      canvas.drawCircle(stroke.points.first, stroke.width / 2, paint..style = PaintingStyle.fill);
      return;
    }
    final path = Path();
    path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
    for (int i = 1; i < stroke.points.length; i++) {
      if (i + 1 < stroke.points.length) {
        final mid = Offset(
          (stroke.points[i].dx + stroke.points[i + 1].dx) / 2,
          (stroke.points[i].dy + stroke.points[i + 1].dy) / 2,
        );
        path.quadraticBezierTo(
          stroke.points[i].dx,
          stroke.points[i].dy,
          mid.dx,
          mid.dy,
        );
      } else {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
    }
    canvas.drawPath(path, paint);
  }
  void _drawEraserIndicator(Canvas canvas, Offset position) {
    canvas.drawCircle(position, eraserRadius, Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5);
  }
  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
