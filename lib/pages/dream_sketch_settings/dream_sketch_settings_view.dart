import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dream_sketch_settings_logic.dart';
class DreamSketchSettingsView extends GetView<DreamSketchSettingsLogic> {
  const DreamSketchSettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.w),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05), blurRadius: 6,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  leading: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Icon(Icons.history_rounded, color: Colors.white, size: 20.sp),
                  ),
                  title: Text(
                    'Drawing History',
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A2E)),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, size: 24.sp, color: Colors.grey.shade400),
                  onTap: controller.onHistoryTap,
                ),
                Divider(height: 1.h, thickness: 1.h, indent: 16.w, endIndent: 16.w),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  title: Text(
                    'Version',
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A2E)),
                  ),
                  trailing: Text(
                    controller.version,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Center(
            child: Column(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA78BFA), Color(0xFF6A5ACD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  child: Icon(Icons.palette_rounded, color: Colors.white, size: 30.sp),
                ),
                SizedBox(height: 10.h),
                Text(
                  'DreamSketch',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6A5ACD)),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Creative Drawing App',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
