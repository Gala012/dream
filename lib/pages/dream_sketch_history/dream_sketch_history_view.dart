import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dream_sketch_history_logic.dart';
class DreamSketchHistoryView extends GetView<DreamSketchHistoryLogic> {
  const DreamSketchHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),
      appBar: AppBar(
        title: const Text('Drawing History'),
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.historyList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_rounded, size: 80.sp, color: Colors.grey.shade300),
                SizedBox(height: 16.h),
                Text(
                  'No drawing history yet',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade500),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Save your drawings to see them here',
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.historyList.length,
            itemBuilder: (context, index) {
              final item = controller.historyList[index];
              return _buildHistoryItem(item);
            },
          ),
        );
      }),
    );
  }
  Widget _buildHistoryItem(item) {
    final date = DateTime.parse(item.createdAt);
    final formattedDate = DateFormat('MMM dd, yyyy HH:mm').format(date);
    final typeLabel = controller.getDrawingTypeLabel(item.drawingType);
    final typeColor = controller.getDrawingTypeColor(item.drawingType);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.w)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: File(item.imagePath).existsSync()
                  ? Image.file(
                      File(item.imagePath),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          size: 40.sp,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.w),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: typeColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => controller.onDeleteTap(item),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red.shade400,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
