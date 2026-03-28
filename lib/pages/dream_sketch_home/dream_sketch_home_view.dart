import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dream_sketch_home_logic.dart';
class DreamSketchHomeView extends GetView<DreamSketchHomeLogic> {
  const DreamSketchHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2FF),
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 24.h),
                _buildSectionLabel('Drawing Modes'),
                SizedBox(height: 12.h),
                _buildDrawingModeCards(),
                SizedBox(height: 28.h),
                _buildSectionLabel('Quick Tools'),
                SizedBox(height: 12.h),
                _buildToolBanners(),
                SizedBox(height: 32.h),
              ]),
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
              color: const Color(0xFF667EEA).withOpacity(0.25),
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
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
                Positioned(
                  right: 80.w,
                  bottom: 10.w,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14.w),
                              ),
                              child: Icon(
                                Icons.color_lens_rounded,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Text(
                              'DreamSketch',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'What would you like to create today?',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
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
  Widget _buildSectionLabel(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: const Color(0xFF5A47C9),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
  Widget _buildDrawingModeCards() {
    return Row(
      children: [
        Expanded(
          child: _buildModeCard(
            title: 'Trace\nDrawing',
            imagePath: 'assets/icons/drawing/trace_drawing.png',
            overlayColor: const Color(0xFF6A5ACD),
            onTap: controller.onTraceDrawingTap,
            imageTopOffset: -20.h,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildModeCard(
            title: 'Shape\nDrawing',
            imagePath: 'assets/icons/drawing/shape_drawing.png',
            overlayColor: const Color(0xFF4C3D9C),
            onTap: controller.onShapeDrawingTap,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildModeCard(
            title: 'Photo\nDrawing',
            imagePath: 'assets/icons/drawing/photo_drawing.png',
            overlayColor: const Color(0xFFD45E8A),
            onTap: controller.onPhotoDrawingTap,
            imageTopOffset: -18.h,
          ),
        ),
      ],
    );
  }
  Widget _buildModeCard({
    required String title,
    required String imagePath,
    required Color overlayColor,
    required VoidCallback onTap,
    double? imageTopOffset,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.w),
        child: Container(
          height: 130.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: overlayColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Transform.translate(
                offset: Offset(0, imageTopOffset ?? 0),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      overlayColor.withOpacity(0.15),
                      overlayColor.withOpacity(0.72),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 14.h,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildToolBanners() {
    return Column(
      children: [
        _buildBannerCard(
          title: 'Canvas',
          subtitle: 'Free drawing on blank canvas',
          imagePath: 'assets/icons/quicktool/bg_1.png',
          overlayColor: const Color(0xFF4C3D9C),
          onTap: controller.onCanvasTap,
        ),
        SizedBox(height: 12.h),
        _buildBannerCard(
          title: 'Frosted Glass',
          subtitle: 'Apply blur effects to photos',
          imagePath: 'assets/icons/quicktool/bg_2.jpg',
          overlayColor: const Color(0xFF2E7D6E),
          onTap: controller.onFrostedGlassTap,
        ),
        SizedBox(height: 12.h),
        _buildBannerCard(
          title: 'Watermark',
          subtitle: 'Add custom watermark to photos',
          imagePath: 'assets/icons/quicktool/bg_3.jpg',
          overlayColor: const Color(0xFF9B7D2A),
          onTap: controller.onWatermarkTap,
        ),
      ],
    );
  }
  Widget _buildBannerCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required Color overlayColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.w),
        child: SizedBox(
          height: 88.h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      overlayColor.withOpacity(0.75),
                      overlayColor.withOpacity(0.45),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                  children: [
                    Container(
                      width: 46.w,
                      height: 46.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14.w),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.35),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        _iconForTitle(title),
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white.withOpacity(0.75),
                      size: 14.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  IconData _iconForTitle(String title) {
    switch (title) {
      case 'Canvas':
        return Icons.brush_rounded;
      case 'Frosted Glass':
        return Icons.blur_on_rounded;
      case 'Watermark':
        return Icons.water_drop_outlined;
      default:
        return Icons.star_rounded;
    }
  }
}
