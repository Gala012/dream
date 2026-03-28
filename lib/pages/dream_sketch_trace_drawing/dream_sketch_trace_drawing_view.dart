import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/dream_sketch_color_bar.dart';
import '../../components/dream_sketch_drawing_painter.dart';
import 'dream_sketch_trace_drawing_logic.dart';
class DreamSketchTraceDrawingView
    extends GetView<DreamSketchTraceDrawingLogic> {
  const DreamSketchTraceDrawingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
        title: Text('Trace Drawing'),
      ),
      body: Column(
        children: [
          _buildImageSelector(),
          Expanded(child: _buildCanvas()),
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
  Widget _buildImageSelector() {
    return Container(
      height: 88.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FF),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        itemCount: DreamSketchTraceDrawingLogic.images.length,
        itemBuilder: (_, i) => _buildImageItem(i),
      ),
    );
  }
  Widget _buildImageItem(int index) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      return GestureDetector(
        onTap: () => controller.onImageSelect(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 64.w,
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF6A5ACD)
                  : Colors.grey.shade300,
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF6A5ACD).withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.w),
            child: Image.asset(
              DreamSketchTraceDrawingLogic.images[index],
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, stack) => Container(
                color: const Color(0xFFF0EDF8),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF6A5ACD),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
  Widget _buildCanvas() {
    return RepaintBoundary(
      key: controller.canvasKey,
      child: Obx(() {
        controller.drawingUpdateTrigger.value;
        final idx = controller.selectedIndex.value;
        final showBg = controller.showBackground.value;
        return GestureDetector(
          onPanStart: idx >= 0
              ? (d) => controller.startDrawing(d.localPosition)
              : null,
          onPanUpdate: idx >= 0
              ? (d) => controller.updateDrawing(d.localPosition)
              : null,
          onPanEnd: idx >= 0 ? (_) => controller.endDrawing() : null,
          child: Stack(
            children: [
              if (idx < 0)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        size: 44.sp,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Select a trace image above to start',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                if (showBg)
                  Positioned.fill(
                    child: Center(
                      child: Transform.scale(
                        scale: 0.7,
                        child: Opacity(
                          opacity: 0.28,
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.matrix([
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                            ]),
                            child: Image.asset(
                              DreamSketchTraceDrawingLogic.images[idx],
                              fit: BoxFit.contain,
                              errorBuilder: (ctx, err, stack) =>
                                  Container(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: DrawingPainter(
                      strokes: controller.strokes,
                      currentStroke: controller.currentStroke,
                      drawBackground: !showBg,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
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
                SizedBox(width: 8.w),
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
                      _buildToolBtn(
                        Icons.brush_rounded,
                        'Brush',
                        controller.onStrokeTap,
                        isActive: controller.showStrokeSlider.value,
                      ),
                      _buildToolBtn(
                        Icons.delete_outline_rounded,
                        'Clear',
                        controller.onClearTap,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 32.h,
                  color: Colors.grey.shade200,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                ),
                _buildSaveBtn(),
                SizedBox(width: 8.w),
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
            Icons.brush_rounded,
            size: 16.sp,
            color: const Color(0xFF6A5ACD),
          ),
          SizedBox(width: 8.w),
          Text(
            'Brush Size',
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
                  max: 12.0,
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
  Widget _buildSaveBtn() {
    return Obx(
      () => Material(
        color: controller.isSaving.value
            ? Colors.grey.shade300
            : const Color(0xFF6A5ACD),
        borderRadius: BorderRadius.circular(10.w),
        child: InkWell(
          onTap: controller.isSaving.value ? null : controller.onSaveTap,
          borderRadius: BorderRadius.circular(10.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.isSaving.value)
                  SizedBox(
                    width: 16.sp,
                    height: 16.sp,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                else
                  Icon(
                    Icons.save_alt_rounded,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                SizedBox(width: 6.w),
                Text(
                  controller.isSaving.value ? 'Saving...' : 'Save',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
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
            SizedBox(height: 3.h),
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
}
