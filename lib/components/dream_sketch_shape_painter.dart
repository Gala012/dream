import 'dart:math';
import 'package:flutter/material.dart';
enum ShapeType {
  square,
  rectangle,
  circle,
  triangle,
  pentagon,
  hexagon,
  star5,
  diamond,
  octagon,
  heart,
  cross,
  arrow,
  trapezoid,
  crescent,
  cloud,
  lightning,
  flower,
  leaf,
}
class DreamSketchShapeInfo {
  final String name;
  final ShapeType type;
  const DreamSketchShapeInfo(this.name, this.type);
  static const List<DreamSketchShapeInfo> shapes = [
    DreamSketchShapeInfo('Square', ShapeType.square),
    DreamSketchShapeInfo('Rectangle', ShapeType.rectangle),
    DreamSketchShapeInfo('Circle', ShapeType.circle),
    DreamSketchShapeInfo('Triangle', ShapeType.triangle),
    DreamSketchShapeInfo('Pentagon', ShapeType.pentagon),
    DreamSketchShapeInfo('Hexagon', ShapeType.hexagon),
    DreamSketchShapeInfo('Star', ShapeType.star5),
    DreamSketchShapeInfo('Diamond', ShapeType.diamond),
    DreamSketchShapeInfo('Octagon', ShapeType.octagon),
    DreamSketchShapeInfo('Heart', ShapeType.heart),
    DreamSketchShapeInfo('Cross', ShapeType.cross),
    DreamSketchShapeInfo('Arrow', ShapeType.arrow),
    DreamSketchShapeInfo('Trapezoid', ShapeType.trapezoid),
    DreamSketchShapeInfo('Crescent', ShapeType.crescent),
    DreamSketchShapeInfo('Cloud', ShapeType.cloud),
    DreamSketchShapeInfo('Lightning', ShapeType.lightning),
    DreamSketchShapeInfo('Flower', ShapeType.flower),
    DreamSketchShapeInfo('Leaf', ShapeType.leaf),
  ];
}
class DreamSketchShapePainter extends CustomPainter {
  final ShapeType type;
  final Color strokeColor;
  final double strokeWidth;
  const DreamSketchShapePainter(
    this.type, {
    this.strokeColor = const Color(0xFF4C3D9C),
    this.strokeWidth = 3.0,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(size.width, size.height) * 0.38;
    switch (type) {
      case ShapeType.square:
        canvas.drawRect(
            Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 2), paint);
      case ShapeType.rectangle:
        canvas.drawRect(
            Rect.fromCenter(center: Offset(cx, cy), width: r * 2.4, height: r * 1.4), paint);
      case ShapeType.circle:
        canvas.drawCircle(Offset(cx, cy), r, paint);
      case ShapeType.triangle:
        _drawPolygon(canvas, paint, Offset(cx, cy), r, 3, -pi / 2);
      case ShapeType.pentagon:
        _drawPolygon(canvas, paint, Offset(cx, cy), r, 5, -pi / 2);
      case ShapeType.hexagon:
        _drawPolygon(canvas, paint, Offset(cx, cy), r, 6, 0);
      case ShapeType.star5:
        _drawStar(canvas, paint, Offset(cx, cy), r, r * 0.42, 5);
      case ShapeType.diamond:
        _drawPolygon(canvas, paint, Offset(cx, cy), r, 4, 0);
      case ShapeType.octagon:
        _drawPolygon(canvas, paint, Offset(cx, cy), r, 8, pi / 8);
      case ShapeType.heart:
        _drawHeart(canvas, paint, size);
      case ShapeType.cross:
        _drawCross(canvas, paint, Offset(cx, cy), r);
      case ShapeType.arrow:
        _drawArrow(canvas, paint, size);
      case ShapeType.trapezoid:
        _drawTrapezoid(canvas, paint, size);
      case ShapeType.crescent:
        _drawCrescent(canvas, paint, size);
      case ShapeType.cloud:
        _drawCloud(canvas, paint, size);
      case ShapeType.lightning:
        _drawLightning(canvas, paint, size);
      case ShapeType.flower:
        _drawFlower(canvas, paint, size);
      case ShapeType.leaf:
        _drawLeaf(canvas, paint, size);
    }
  }
  void _drawPolygon(Canvas canvas, Paint paint, Offset center, double radius, int sides, double startAngle) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = startAngle + (2 * pi * i / sides);
      final pt = Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle));
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  void _drawStar(Canvas canvas, Paint paint, Offset center, double outerR, double innerR, int points) {
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = -pi / 2 + (pi * i / points);
      final pt = Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  void _drawHeart(Canvas canvas, Paint paint, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = min(size.width, size.height) * 0.38;
    final path = Path();
    path.moveTo(cx, cy - s * 0.1);
    path.cubicTo(cx + s * 0.9, cy - s * 0.9, cx + s * 1.25, cy + s * 0.35, cx, cy + s * 1.05);
    path.cubicTo(cx - s * 1.25, cy + s * 0.35, cx - s * 0.9, cy - s * 0.9, cx, cy - s * 0.1);
    canvas.drawPath(path, paint);
  }
  void _drawCross(Canvas canvas, Paint paint, Offset c, double r) {
    final aw = r * 0.3;
    final path = Path()
      ..moveTo(c.dx - aw, c.dy - r)
      ..lineTo(c.dx + aw, c.dy - r)
      ..lineTo(c.dx + aw, c.dy - aw)
      ..lineTo(c.dx + r, c.dy - aw)
      ..lineTo(c.dx + r, c.dy + aw)
      ..lineTo(c.dx + aw, c.dy + aw)
      ..lineTo(c.dx + aw, c.dy + r)
      ..lineTo(c.dx - aw, c.dy + r)
      ..lineTo(c.dx - aw, c.dy + aw)
      ..lineTo(c.dx - r, c.dy + aw)
      ..lineTo(c.dx - r, c.dy - aw)
      ..lineTo(c.dx - aw, c.dy - aw)
      ..close();
    canvas.drawPath(path, paint);
  }
  void _drawArrow(Canvas canvas, Paint paint, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(size.width, size.height) * 0.38;
    final sh = r * 0.32;
    final hx = cx + r;
    final hd = r * 0.48;
    final path = Path()
      ..moveTo(cx - r, cy - sh)
      ..lineTo(hx - hd, cy - sh)
      ..lineTo(hx - hd, cy - r)
      ..lineTo(hx, cy)
      ..lineTo(hx - hd, cy + r)
      ..lineTo(hx - hd, cy + sh)
      ..lineTo(cx - r, cy + sh)
      ..close();
    canvas.drawPath(path, paint);
  }
  void _drawTrapezoid(Canvas canvas, Paint paint, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(size.width, size.height) * 0.38;
    final path = Path()
      ..moveTo(cx - r * 0.6, cy - r)
      ..lineTo(cx + r * 0.6, cy - r)
      ..lineTo(cx + r, cy + r)
      ..lineTo(cx - r, cy + r)
      ..close();
    canvas.drawPath(path, paint);
  }
  void _drawCrescent(Canvas canvas, Paint paint, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(size.width, size.height) * 0.38;
    final path = Path();
    path.addArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), -pi / 2, pi);
    path.arcTo(
      Rect.fromCircle(center: Offset(cx + r * 0.4, cy), radius: r * 0.72),
      pi / 2,
      -pi,
      false,
    );
    path.close();
    canvas.drawPath(path, paint);
  }
  void _drawCloud(Canvas canvas, Paint paint, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(size.width, size.height) * 0.38;
    canvas.drawCircle(Offset(cx - r * 0.5, cy), r * 0.55, paint);
    canvas.drawCircle(Offset(cx + r * 0.5, cy), r * 0.55, paint);
    canvas.drawCircle(Offset(cx, cy - r * 0.3), r * 0.65, paint);
    canvas.drawCircle(Offset(cx - r * 0.2, cy + r * 0.15), r * 0.45, paint);
    canvas.drawCircle(Offset(cx + r * 0.2, cy + r * 0.15), r * 0.45, paint);
  }
  void _drawLightning(Canvas canvas, Paint paint, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(size.width, size.height) * 0.38;
    final path = Path()
      ..moveTo(cx + r * 0.4, cy - r)
      ..lineTo(cx - r * 0.3, cy - r * 0.1)
      ..lineTo(cx + r * 0.2, cy - r * 0.05)
      ..lineTo(cx - r * 0.5, cy + r * 0.5)
      ..lineTo(cx, cy + r * 0.45)
      ..lineTo(cx - r * 0.1, cy + r)
      ..lineTo(cx + r * 0.3, cy + r * 0.1)
      ..lineTo(cx - r * 0.05, cy + r * 0.05)
      ..close();
    canvas.drawPath(path, paint);
  }
  void _drawFlower(Canvas canvas, Paint paint, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(size.width, size.height) * 0.38;
    final petalR = r * 0.42;
    final centerR = r * 0.2;
    for (int i = 0; i < 5; i++) {
      final angle = (2 * pi * i / 5) - pi / 2;
      final px = cx + r * 0.48 * cos(angle);
      final py = cy + r * 0.48 * sin(angle);
      canvas.drawCircle(Offset(px, py), petalR, paint);
    }
    canvas.drawCircle(Offset(cx, cy), centerR, paint);
  }
  void _drawLeaf(Canvas canvas, Paint paint, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(size.width, size.height) * 0.38;
    final path = Path()
      ..moveTo(cx, cy - r)
      ..quadraticBezierTo(cx + r * 0.8, cy - r * 0.3, cx + r * 0.6, cy + r * 0.7)
      ..quadraticBezierTo(cx + r * 0.2, cy + r, cx, cy + r)
      ..quadraticBezierTo(cx - r * 0.2, cy + r, cx - r * 0.6, cy + r * 0.7)
      ..quadraticBezierTo(cx - r * 0.8, cy - r * 0.3, cx, cy - r);
    canvas.drawPath(path, paint);
    final veinPath = Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx, cy + r);
    canvas.drawPath(veinPath, paint);
  }
  @override
  bool shouldRepaint(DreamSketchShapePainter old) =>
      old.type != type || old.strokeColor != strokeColor || old.strokeWidth != strokeWidth;
}
