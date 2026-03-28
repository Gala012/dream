import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dream_sketch_watermark_logic.dart';
class DreamSketchWatermarkView extends GetView<DreamSketchWatermarkLogic> {
  const DreamSketchWatermarkView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Watermark'),
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
                  : Icon(
                      Icons.save_alt_rounded,
                      color: controller.hasImage.value
                          ? const Color(0xFF6A5ACD)
                          : Colors.grey.shade400,
                    ),
              onPressed:
                  (controller.hasImage.value && !controller.isSaving.value)
                  ? controller.onSaveTap
                  : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPreview(),
            _buildSettings(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
  Widget _buildPreview() {
    return Obx(
      () => Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 260.h),
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: controller.hasImage.value && controller.imageBytes != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16.w),
                child: Stack(
                  children: [
                    Image.memory(controller.imageBytes!, fit: BoxFit.contain),
                    if (controller.watermarkText.value.isNotEmpty)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _WatermarkPainter(
                            text: controller.watermarkText.value,
                            fontSize: controller.sizeValue.value,
                            opacity: controller.opacityValue.value,
                            angle: controller.angleValue.value,
                            spacing: controller.spacingPixels,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 10.h,
                      right: 10.w,
                      child: GestureDetector(
                        onTap: controller.onSelectImageTap,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8.w),
                          ),
                          child: Icon(
                            Icons.swap_horiz_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48.sp,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 14.h),
                  GestureDetector(
                    onTap: controller.onSelectImageTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A5ACD),
                        borderRadius: BorderRadius.circular(20.w),
                      ),
                      child: Text(
                        'Select Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  Widget _buildSettings() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextInput(),
          SizedBox(height: 14.h),
          _buildSpacingRow(),
          SizedBox(height: 4.h),
          _buildSliderRow(
            'Size',
            controller.sizeValue,
            8,
            48,
            controller.onSizeChange,
          ),
          _buildSliderRow(
            'Angle',
            controller.angleValue,
            -90,
            90,
            controller.onAngleChange,
          ),
          _buildSliderRow(
            'Opacity',
            controller.opacityValue,
            0,
            1,
            controller.onOpacityChange,
          ),
        ],
      ),
    );
  }
  Widget _buildTextInput() {
    return Row(
      children: [
        SizedBox(
          width: 64.w,
          child: Text(
            'Text',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
          ),
        ),
        Expanded(
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F6FF),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                hintText: 'Enter watermark text',
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade400,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                alignLabelWithHint: true,
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 16.sp,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: controller.onClearText,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildSpacingRow() {
    final options = [
      ('Small', 'small'),
      ('Medium', 'medium'),
      ('Large', 'large'),
    ];
    return Row(
      children: [
        SizedBox(
          width: 64.w,
          child: Text(
            'Spacing',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
          ),
        ),
        Expanded(
          child: Obx(
            () => Row(
              children: options.map((opt) {
                final isSelected = controller.spacing.value == opt.$2;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.onSpacingChange(opt.$2),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      padding: EdgeInsets.symmetric(vertical: 7.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6A5ACD)
                            : const Color(0xFFF8F6FF),
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Text(
                        opt.$1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildSliderRow(
    String label,
    RxDouble value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          SizedBox(
            width: 64.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Obx(
              () => Slider(
                value: value.value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _WatermarkPainter extends CustomPainter {
  final String text;
  final double fontSize;
  final double opacity;
  final double angle;
  final double spacing;
  const _WatermarkPainter({
    required this.text,
    required this.fontSize,
    required this.opacity,
    required this.angle,
    required this.spacing,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white.withValues(alpha: opacity),
        fontWeight: FontWeight.w500,
        shadows: const [
          Shadow(color: Colors.black45, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)
      ..layout();
    final diagonal = math.sqrt(
      size.width * size.width + size.height * size.height,
    );
    final radians = angle * math.pi / 180;
    final stepX = tp.width + spacing;
    final stepY = tp.height + spacing * 0.5;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(radians);
    for (double y = -diagonal; y < diagonal; y += stepY) {
      for (double x = -diagonal; x < diagonal; x += stepX) {
        tp.paint(canvas, Offset(x, y));
      }
    }
    canvas.restore();
  }
  @override
  bool shouldRepaint(_WatermarkPainter old) =>
      text != old.text ||
      fontSize != old.fontSize ||
      opacity != old.opacity ||
      angle != old.angle ||
      spacing != old.spacing;
}
