import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/dream_sketch_drawing_painter.dart';
import 'dream_sketch_canvas_logic.dart';
class DreamSketchCanvasView extends GetView<DreamSketchCanvasLogic> {
  const DreamSketchCanvasView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Canvas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: controller.isSaving.value
                  ? SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_alt_rounded),
              onPressed: controller.isSaving.value
                  ? null
                  : controller.onSaveTap,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(height: 1, color: Colors.grey.shade200),
          Expanded(child: _buildCanvas()),
          _buildToolbar(),
        ],
      ),
    );
  }
  Widget _buildCanvas() {
    return RepaintBoundary(
      key: controller.canvasKey,
      child: Container(
        color: Colors.white,
        child: Obx(() {
          controller.drawingUpdateTrigger.value;
          return GestureDetector(
            onPanStart: (d) => controller.startDrawing(d.localPosition),
            onPanUpdate: (d) => controller.updateDrawing(d.localPosition),
            onPanEnd: (_) => controller.endDrawing(),
            child: CustomPaint(
              painter: DrawingPainter(
                strokes: controller.strokes,
                currentStroke: controller.currentStroke,
                isEraserMode: controller.selectedTool.value == 'eraser',
                eraserPosition: controller.eraserPosition,
                eraserRadius: controller.strokeWidth.value * 2,
              ),
              child: const SizedBox.expand(),
            ),
          );
        }),
      ),
    );
  }
  Widget _buildToolbar() {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.showStrokeSlider.value) _buildStrokeSlider(),
          Container(
            height: 64.h,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                SizedBox(width: 6.w),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildToolBtn(
                        Icons.undo_rounded,
                        'Undo',
                        controller.canUndo ? controller.onUndoTap : null,
                      ),
                      _buildToolBtn(
                        Icons.redo_rounded,
                        'Redo',
                        controller.canRedo ? controller.onRedoTap : null,
                      ),
                      _buildActiveBtn(
                        Icons.brush_rounded,
                        'Pen',
                        controller.onPenTap,
                        isActive: controller.selectedTool.value == 'pen',
                      ),
                      _buildActiveBtn(
                        Icons.auto_fix_high_rounded,
                        'Eraser',
                        controller.onEraserTap,
                        isActive: controller.selectedTool.value == 'eraser',
                      ),
                      _buildToolBtn(
                        Icons.line_weight_rounded,
                        'Size',
                        controller.onBrushSizeTap,
                        isActive: controller.showStrokeSlider.value,
                      ),
                      _buildColorBtn(),
                      _buildToolBtn(
                        Icons.delete_outline_rounded,
                        'Clear',
                        controller.onClearTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStrokeSlider() {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FF),
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Icon(
            Icons.line_weight_rounded,
            size: 16.sp,
            color: const Color(0xFF6A5ACD),
          ),
          SizedBox(width: 8.w),
          Text(
            'Stroke Size',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Obx(
              () => SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4.h,
                  activeTrackColor: const Color(0xFF6A5ACD),
                  inactiveTrackColor: Colors.grey.shade200,
                  thumbColor: const Color(0xFF6A5ACD),
                  overlayColor: const Color(0xFF6A5ACD).withOpacity(0.15),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.w),
                ),
                child: Slider(
                  value: controller.strokeWidth.value,
                  min: 1.0,
                  max: 40.0,
                  onChanged: controller.onStrokeWidthChange,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(
            () => Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.w),
                border: Border.all(color: Colors.grey.shade300),
              ),
              alignment: Alignment.center,
              child: Text(
                '${controller.strokeWidth.value.toInt()}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF6A5ACD),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildColorBtn() {
    return Obx(
      () => InkWell(
        onTap: controller.onColorTap,
        borderRadius: BorderRadius.circular(8.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24.sp,
                height: 24.sp,
                decoration: BoxDecoration(
                  color: controller.selectedColor.value,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Color',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildToolBtn(
    IconData icon,
    String label,
    VoidCallback? onTap, {
    bool isActive = false,
  }) {
    final enabled = onTap != null;
    final shouldHighlight = isActive && enabled;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          color: shouldHighlight
              ? const Color(0xFF6A5ACD).withOpacity(0.08)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: shouldHighlight
                  ? const Color(0xFF6A5ACD)
                  : enabled
                  ? Colors.grey.shade700
                  : Colors.grey.shade300,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: shouldHighlight
                    ? const Color(0xFF6A5ACD)
                    : enabled
                    ? Colors.grey.shade600
                    : Colors.grey.shade300,
                fontWeight: shouldHighlight ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildActiveBtn(
    IconData icon,
    String label,
    VoidCallback onTap, {
    required bool isActive,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF6A5ACD).withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isActive ? const Color(0xFF6A5ACD) : Colors.grey.shade700,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: isActive
                    ? const Color(0xFF6A5ACD)
                    : Colors.grey.shade600,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
