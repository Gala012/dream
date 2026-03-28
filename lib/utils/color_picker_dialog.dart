import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
const List<Color> _pickerColors = [
  Color(0xFFFFADAD), Color(0xFFFFD6A5), Color(0xFFFDFFB6),
  Color(0xFFCAFFBF), Color(0xFF9BF6FF), Color(0xFFBDB2FF),
  Color(0xFFFF6B6B), Color(0xFFFF9F43), Color(0xFFFECA57),
  Color(0xFF54A0FF), Color(0xFF5F27CD), Color(0xFFFF9FF3),
  Color(0xFFFF0000), Color(0xFFFF6B00), Color(0xFFFFEB3B),
  Color(0xFF4CAF50), Color(0xFF2196F3), Color(0xFF9C27B0),
  Color(0xFFE91E63), Color(0xFF00BCD4), Color(0xFF795548),
  Color(0xFFFF9EC1), Color(0xFFA3D9B8), Color(0xFFF4E8C1),
  Color(0xFF8B0000), Color(0xFF1B5E20), Color(0xFF0D47A1),
  Color(0xFF4A148C), Color(0xFF263238), Color(0xFF37474F),
  Color(0xFFFFFFFF), Color(0xFFE0E0E0), Color(0xFF9E9E9E),
  Color(0xFF616161), Color(0xFF212121), Color(0xFF000000),
];
Future<Color?> showColorPickerDialog(Color initialColor) async {
  final selectedColor = initialColor.obs;
  final opacityValue = (initialColor.a).obs;
  return await Get.dialog<Color>(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Select Color',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: Get.back,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.w,
              ),
              itemCount: _pickerColors.length,
              itemBuilder: (_, i) {
                final color = _pickerColors[i];
                return Obx(() {
                  final isSelected = selectedColor.value.toARGB32() == color.toARGB32();
                  return GestureDetector(
                    onTap: () => selectedColor.value = color,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF6A5ACD)
                              : Colors.grey.shade300,
                          width: isSelected ? 3 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF6A5ACD).withValues(alpha: 0.4),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  );
                });
              },
            ),
            SizedBox(height: 12.h),
            Obx(() => Row(
                  children: [
                    const Icon(Icons.opacity, size: 16),
                    SizedBox(width: 6.w),
                    Text('Opacity', style: TextStyle(fontSize: 12.sp)),
                    Expanded(
                      child: Slider(
                        value: opacityValue.value,
                        min: 0.1,
                        max: 1.0,
                        onChanged: (v) => opacityValue.value = v,
                      ),
                    ),
                    Text(
                      '${(opacityValue.value * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF6A5ACD),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Obx(() => Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: selectedColor.value.withValues(alpha: opacityValue.value),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      )),
                ),
                SizedBox(width: 12.w),
                ElevatedButton(
                  onPressed: () {
                    Get.back(
                      result: selectedColor.value.withValues(alpha: opacityValue.value),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5ACD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
