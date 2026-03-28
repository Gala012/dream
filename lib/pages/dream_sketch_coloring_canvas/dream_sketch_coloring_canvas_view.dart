import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/dream_sketch_color_bar.dart';
import '../../components/dream_sketch_drawing_painter.dart';
import 'dream_sketch_coloring_canvas_logic.dart';
class DreamSketchColoringCanvasView
    extends GetView<DreamSketchColoringCanvasLogic> {
  const DreamSketchColoringCanvasView({super.key});
  static const _purple = Color(0xFF6A5ACD);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F1FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87),
          onPressed: Get.back,
        ),
        title: Text(
          controller.theme.isNotEmpty ? controller.theme : 'Coloring',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() => _buildModeToggle()),
          SizedBox(width: 10.w),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildCanvasArea()),
          _buildToolbar(),
          Obx(
            () => DreamSketchColorBar(
              selectedIndex: controller.colorIndex.value,
              onColorTap: controller.onColorSelect,
              onCustomColor: controller.onCustomColorTap,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildModeToggle() {
    final isBucket = controller.mode.value == ColoringMode.bucket;
    return Container(
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeBtn(
            icon: Icons.format_color_fill_rounded,
            label: 'Fill',
            active: isBucket,
            onTap: controller.onBucketTap,
          ),
          _buildModeBtn(
            icon: Icons.brush_rounded,
            label: 'Brush',
            active: !isBucket,
            onTap: controller.onBrushTap,
          ),
        ],
      ),
    );
  }
  Widget _buildModeBtn({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: active ? _purple : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14.sp,
              color: active ? Colors.white : Colors.grey.shade500,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: active ? Colors.white : Colors.grey.shade500,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCanvasArea() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: _purple));
      }
      if (controller.lineArtImage == null) {
        return Center(
          child: Text(
            'No image available',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
          ),
        );
      }
      final ratio = controller.imgWidth / controller.imgHeight;
      return Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: AspectRatio(
              aspectRatio: ratio,
              child: Container(
                padding: EdgeInsets.all(10.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final canvasSize = Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );
                      return RepaintBoundary(
                        key: controller.canvasKey,
                        child: Obx(() => _buildInteractiveCanvas(canvasSize)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
  Widget _buildInteractiveCanvas(Size canvasSize) {
    final isBucket = controller.mode.value == ColoringMode.bucket;
    return InteractiveViewer(
      transformationController: controller.transformationController,
      panEnabled: isBucket,
      scaleEnabled: true,
      minScale: 0.5,
      maxScale: 5.0,
      boundaryMargin: EdgeInsets.all(80.w),
      child: Listener(
        onPointerDown: (event) => controller.onPointerDown(event),
        onPointerMove: (event) => controller.onPointerMove(event, canvasSize),
        onPointerUp: (event) => controller.onPointerUp(event),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) {
            if (isBucket) {
              controller.pendingTapPos = d.localPosition;
            }
          },
          onTap: () {
            if (isBucket && controller.pendingTapPos != null) {
              controller.onCanvasTap(controller.pendingTapPos!, canvasSize);
              controller.pendingTapPos = null;
            }
          },
          child: _buildCanvas(canvasSize),
        ),
      ),
    );
  }
  Widget _buildCanvas(Size canvasSize) {
    return Obx(() {
      controller.repaint.value;
      return SizedBox(
        width: canvasSize.width,
        height: canvasSize.height,
        child: CustomPaint(
          painter: _ColoringPainter(
            lineArtImage: controller.lineArtImage,
            fillImage: controller.fillRenderImage,
            strokes: List.from(controller.strokes),
            currentStroke: controller.currentStroke,
          ),
          size: canvasSize,
        ),
      );
    });
  }
  Widget _buildToolbar() {
    return Container(
      height: 56.h,
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            _buildToolBtn(
              Icons.undo_rounded,
              'Undo',
              controller.canUndo ? controller.onUndoTap : null,
            ),
            _buildVDivider(),
            _buildToolBtn(
              Icons.redo_rounded,
              'Redo',
              controller.canRedo ? controller.onRedoTap : null,
            ),
            _buildVDivider(),
            _buildToolBtn(
              Icons.zoom_out_map_rounded,
              'Reset',
              controller.onResetZoom,
            ),
            _buildVDivider(),
            _buildToolBtn(
              Icons.delete_outline_rounded,
              'Clear',
              controller.onClearTap,
            ),
            _buildVDivider(),
            _buildToolBtn(
              Icons.save_alt_rounded,
              'Save',
              controller.isSaving.value ? null : controller.onSaveTap,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildVDivider() => SizedBox(
    height: 24.h,
    child: VerticalDivider(color: Colors.grey.shade200, width: 1, thickness: 1),
  );
  Widget _buildToolBtn(IconData icon, String label, VoidCallback? onTap) {
    final enabled = onTap != null;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: enabled ? _purple : Colors.grey.shade300,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: enabled ? Colors.grey.shade600 : Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _ColoringPainter extends CustomPainter {
  final ui.Image? lineArtImage;
  final ui.Image? fillImage;
  final List<DrawingStroke> strokes;
  final DrawingStroke? currentStroke;
  const _ColoringPainter({
    required this.lineArtImage,
    required this.fillImage,
    required this.strokes,
    required this.currentStroke,
  });
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );
    if (fillImage != null) {
      final src = Rect.fromLTWH(
        0,
        0,
        fillImage!.width.toDouble(),
        fillImage!.height.toDouble(),
      );
      final dst = Rect.fromLTWH(0, 0, size.width, size.height);
      canvas.drawImageRect(fillImage!, src, dst, Paint());
    }
    _paintStrokes(canvas);
    if (lineArtImage != null) {
      final src = Rect.fromLTWH(
        0,
        0,
        lineArtImage!.width.toDouble(),
        lineArtImage!.height.toDouble(),
      );
      final dst = Rect.fromLTWH(0, 0, size.width, size.height);
      canvas.drawImageRect(lineArtImage!, src, dst, Paint());
    }
  }
  void _paintStrokes(Canvas canvas) {
    final all = [...strokes, ?currentStroke];
    for (final stroke in all) {
      if (stroke.points.length < 2) continue;
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      final path = Path()..moveTo(stroke.points[0].dx, stroke.points[0].dy);
      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }
  @override
  bool shouldRepaint(covariant _ColoringPainter old) => true;
}
