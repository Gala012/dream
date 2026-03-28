import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dream_sketch_coloring_logic.dart';

class DreamSketchColoringView extends GetView<DreamSketchColoringLogic> {
  const DreamSketchColoringView({super.key});
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
                _buildSectionLabel('Popular Themes'),
                SizedBox(height: 12.h),
                _buildBasicThemes(),
                SizedBox(height: 28.h),
                _buildSectionLabel('Featured Collections'),
                SizedBox(height: 12.h),
                _buildFeaturedThemes(),
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
                colors: [Color(0xFFE91E63), Color(0xFFFF6F00)],
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
                                Icons.palette_rounded,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Text(
                              'Coloring Book',
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
                          'Choose your favorite theme to start',
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

  Widget _buildBasicThemes() {
    final themes = [
      ('Cartoon', Icons.face_rounded, const Color(0xFF9C27B0), 'cartoon'),
      (
        'Flower',
        Icons.local_florist_rounded,
        const Color(0xFFE91E63),
        'flower',
      ),
      (
        'Traffic',
        Icons.directions_car_rounded,
        const Color(0xFF2196F3),
        'traffic',
      ),
      ('Food', Icons.restaurant_rounded, const Color(0xFFFF9800), 'food'),
      ('Animal', Icons.pets_rounded, const Color(0xFF4CAF50), 'animal'),
      ('Nature', Icons.nature_rounded, const Color(0xFF009688), 'nature'),
    ];
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.35,
      ),
      itemCount: themes.length,
      itemBuilder: (_, i) => _buildThemeCard(
        title: themes[i].$1,
        icon: themes[i].$2,
        color: themes[i].$3,
        themeId: themes[i].$4,
        onTap: () => controller.onThemeTap(themes[i].$4),
      ),
    );
  }

  Widget _buildThemeCard({
    required String title,
    required IconData icon,
    required Color color,
    required String themeId,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.w),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/coloring/$themeId/cover.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.7), color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.25), color.withOpacity(0.75)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                left: 12.w,
                right: 12.w,
                bottom: 12.h,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10.w),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(icon, color: Colors.white, size: 20.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
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
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white.withOpacity(0.8),
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

  Widget _buildFeaturedThemes() {
    final themes = [
      (
        'Fruit',
        Icons.apple_rounded,
        const Color(0xFFFF5722),
        const Color(0xFFFF8A65),
        'fruit',
      ),
      (
        'Number',
        Icons.numbers_rounded,
        const Color(0xFF673AB7),
        const Color(0xFF9575CD),
        'number',
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 0.85,
      ),
      itemCount: themes.length,
      itemBuilder: (_, i) => _buildFeaturedCard(
        title: themes[i].$1,
        icon: themes[i].$2,
        color1: themes[i].$3,
        color2: themes[i].$4,
        themeId: themes[i].$5,
        onTap: () => controller.onThemeTap(themes[i].$5),
      ),
    );
  }

  Widget _buildFeaturedCard({
    required String title,
    required IconData icon,
    required Color color1,
    required Color color2,
    required String themeId,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.w),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: color1.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/coloring/$themeId/cover.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color1, color2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color1.withOpacity(0.3), color1.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: -30.w,
                right: -30.w,
                child: Container(
                  width: 110.w,
                  height: 110.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -20.w,
                left: -20.w,
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  child: Text(
                    'Featured',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12.w),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24.sp),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Explore collection',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
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
}
