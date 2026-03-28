import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dream_sketch_coloring_list_logic.dart';
class DreamSketchColoringListView
    extends GetView<DreamSketchColoringListLogic> {
  const DreamSketchColoringListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2FF),
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                _buildImageItem,
                childCount: controller.imagePaths.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 14.h,
                childAspectRatio: 0.85,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSliverHeader() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32.w),
            bottomRight: Radius.circular(32.w),
          ),
          boxShadow: [
            BoxShadow(
              color: controller.themeColor.withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32.w),
            bottomRight: Radius.circular(32.w),
          ),
          child: Container(
            height: 220.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  controller.coverPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          controller.themeColor,
                          controller.themeColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        controller.themeColor.withOpacity(0.65),
                        controller.themeColor.withOpacity(0.85),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  right: -20.w,
                  top: -20.w,
                  child: Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned(
                  left: -30.w,
                  bottom: -40.w,
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: Get.back,
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.w),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16.w),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                controller.themeIcon,
                                color: Colors.white,
                                size: 28.sp,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.themeTitle,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${controller.imagePaths.length} coloring pages',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildImageItem(BuildContext context, int index) {
    final path = controller.imagePaths[index];
    return GestureDetector(
      onTap: () => controller.onImageTap(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.w),
          boxShadow: [
            BoxShadow(
              color: controller.themeColor.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: path != null
                  ? _buildAssetImage(path, index)
                  : _buildComingSoon(),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: controller.themeColor.withOpacity(0.08),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.w),
                  bottomRight: Radius.circular(16.w),
                ),
              ),
              child: Center(
                child: Text(
                  '${controller.themeTitle} ${index + 1}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: controller.themeColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAssetImage(String path, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.w),
        topRight: Radius.circular(16.w),
      ),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(8.w),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          errorBuilder: (context, e, stack) => _buildPlaceholder(index),
        ),
      ),
    );
  }
  Widget _buildPlaceholder(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_outlined,
          size: 40.sp,
          color: Colors.grey.shade300,
        ),
        SizedBox(height: 8.h),
        Text(
          'Image ${index + 1}',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  Widget _buildComingSoon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.hourglass_top_rounded,
          size: 36.sp,
          color: Colors.grey.shade300,
        ),
        SizedBox(height: 10.h),
        Text(
          'Coming Soon',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
