import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dream_sketch_frosted_glass_logic.dart';
class DreamSketchFrostedGlassView
    extends GetView<DreamSketchFrostedGlassLogic> {
  const DreamSketchFrostedGlassView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Frosted Glass'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildPreview()),
          _buildControls(),
        ],
      ),
    );
  }
  Widget _buildPreview() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Obx(() {
        if (!controller.hasImage.value || controller.imageBytes == null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.blur_on_rounded,
                  size: 56.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Select an image to apply effect',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.w),
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: controller.blurValue.value,
              sigmaY: controller.blurValue.value,
              tileMode: TileMode.clamp,
            ),
            child: Image.memory(
              controller.imageBytes!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      }),
    );
  }
  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Blur',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              Expanded(
                child: Obx(
                  () => Slider(
                    value: controller.blurValue.value,
                    min: 0,
                    max: 25,
                    divisions: 25,
                    onChanged: controller.onBlurChange,
                  ),
                ),
              ),
              Obx(
                () => SizedBox(
                  width: 28.w,
                  child: Text(
                    controller.blurValue.value.toStringAsFixed(0),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF6A5ACD),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Select Image'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6A5ACD),
                    side: const BorderSide(color: Color(0xFF6A5ACD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                  ),
                  onPressed: controller.onSelectImageTap,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Obx(
                  () => ElevatedButton.icon(
                    icon: controller.isSaving.value
                        ? SizedBox(
                            width: 18.sp,
                            height: 18.sp,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.save_alt_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                    label: const Text('Save Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.hasImage.value
                          ? const Color(0xFF6A5ACD)
                          : Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      elevation: 0,
                    ),
                    onPressed:
                        (controller.hasImage.value &&
                            !controller.isSaving.value)
                        ? controller.onSaveTap
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
