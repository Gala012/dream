import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/dream_sketch_color_bar.dart';
import '../../components/dream_sketch_drawing_painter.dart';
import 'dream_sketch_photo_drawing_logic.dart';
class DreamSketchPhotoDrawingView
    extends GetView<DreamSketchPhotoDrawingLogic> {
  const DreamSketchPhotoDrawingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Photo Drawing'),
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
  Widget _buildCanvas() {
    return RepaintBoundary(
      key: controller.canvasKey,
      child: Obx(() {
        controller.drawingUpdateTrigger.value;
        if (!controller.hasPhoto.value) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 52.sp,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: controller.onSelectPhotoTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A5ACD),
                        borderRadius: BorderRadius.circular(24.w),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Select Photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final isEditing = controller.isEditingImage.value;
        return Stack(
          children: [
            Positioned.fill(
              child: isEditing
                  ? GestureDetector(
                      onScaleStart: controller.onImageScaleStart,
                      onScaleUpdate: controller.onImageScaleUpdate,
                      onScaleEnd: controller.onImageScaleEnd,
                      child: _buildImageLayer(),
                    )
                  : GestureDetector(
                      onPanStart: (d) =>
                          controller.startDrawing(d.localPosition),
                      onPanUpdate: (d) =>
                          controller.updateDrawing(d.localPosition),
                      onPanEnd: (_) => controller.endDrawing(),
                      child: Stack(
                        children: [
                          Positioned.fill(child: _buildImageLayer()),
                          Positioned.fill(
                            child: CustomPaint(
                              painter: DrawingPainter(
                                strokes: controller.strokes,
                                currentStroke: controller.currentStroke,
                                isEraserMode:
                                    controller.selectedTool.value == 'eraser',
                                eraserPosition: controller.eraserPosition,
                                eraserRadius: controller.strokeWidth.value * 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            if (isEditing)
              Positioned(
                top: 16.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A5ACD).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                    child: Text(
                      'Image Edit Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
  Widget _buildImageLayer() {
    return Obx(() {
      controller.drawingUpdateTrigger.value;
      final rotation = controller.imageRotation.value * 1.5708;
      final scale = controller.imageScale.value;
      final offsetX = controller.imageOffsetX.value;
      final offsetY = controller.imageOffsetY.value;
      ColorFilter? colorFilter;
      switch (controller.selectedFilter.value) {
        case 'grayscale':
          colorFilter = const ColorFilter.matrix([
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
          ]);
          break;
        case 'sepia':
          colorFilter = const ColorFilter.matrix([
            0.393,
            0.769,
            0.189,
            0,
            0,
            0.349,
            0.686,
            0.168,
            0,
            0,
            0.272,
            0.534,
            0.131,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]);
          break;
        case 'invert':
          colorFilter = const ColorFilter.matrix([
            -1,
            0,
            0,
            0,
            255,
            0,
            -1,
            0,
            0,
            255,
            0,
            0,
            -1,
            0,
            255,
            0,
            0,
            0,
            1,
            0,
          ]);
          break;
      }
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(offsetX, offsetY)
          ..rotateZ(rotation)
          ..scale(scale),
        child: colorFilter != null
            ? ColorFiltered(
                colorFilter: colorFilter,
                child: Image.memory(
                  controller.photoBytes!,
                  fit: BoxFit.contain,
                ),
              )
            : Image.memory(controller.photoBytes!, fit: BoxFit.contain),
      );
    });
  }
  Widget _buildToolbar() {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.showStrokeSlider.value) _buildStrokeSlider(),
          if (controller.showFilterPanel.value) _buildFilterPanel(),
          Container(
            height: 64.h,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: controller.isEditingImage.value
                ? _buildImageEditToolbar()
                : _buildDrawingToolbar(),
          ),
        ],
      ),
    );
  }
  Widget _buildDrawingToolbar() {
    return Row(
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
              _buildToolBtn(
                Icons.edit_rounded,
                'Image',
                controller.onImageEditTap,
              ),
              _buildToolBtn(
                Icons.delete_outline_rounded,
                'Clear',
                controller.onClearTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildImageEditToolbar() {
    return Row(
      children: [
        SizedBox(width: 6.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildToolBtn(
                Icons.photo_library_outlined,
                'Photo',
                controller.onSelectPhotoTap,
              ),
              _buildToolBtn(
                Icons.rotate_right_rounded,
                'Rotate',
                controller.onRotateTap,
              ),
              _buildToolBtn(
                Icons.filter_vintage_rounded,
                'Filter',
                controller.onFilterTap,
                isActive: controller.showFilterPanel.value,
              ),
              _buildActiveBtn(
                Icons.check_rounded,
                'Done',
                controller.onImageEditTap,
                isActive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildFilterPanel() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FF),
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Obx(
        () => ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          children: [
            _buildFilterItem('none', 'Original'),
            _buildFilterItem('grayscale', 'B&W'),
            _buildFilterItem('sepia', 'Sepia'),
            _buildFilterItem('invert', 'Invert'),
          ],
        ),
      ),
    );
  }
  Widget _buildFilterItem(String filterId, String label) {
    final isSelected = controller.selectedFilter.value == filterId;
    return GestureDetector(
      onTap: () => controller.onFilterSelect(filterId),
      child: Container(
        width: 64.w,
        margin: EdgeInsets.only(right: 12.w),
        child: Column(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6A5ACD)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.w),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6A5ACD)
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.filter_vintage_rounded,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 24.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: isSelected
                    ? const Color(0xFF6A5ACD)
                    : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
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
