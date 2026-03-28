import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
const List<Color> kPresetColors = [
  Color(0xFFFF0000),
  Color(0xFFFF6B00),
  Color(0xFFFFD700),
  Color(0xFF4CAF50),
  Color(0xFF00BCD4),
  Color(0xFF2196F3),
  Color(0xFF6A5ACD),
  Color(0xFFA78BFA),
  Color(0xFFFF9EC1),
  Color(0xFF9C27B0),
  Color(0xFFE91E63),
  Color(0xFFFF8A65),
  Color(0xFF795548),
  Color(0xFF000000),
  Color(0xFFFFFFFF),
  Color(0xFF9E9E9E),
  Color(0xFFA3D9B8),
  Color(0xFFF4E8C1),
];
class DreamSketchColorBar extends StatefulWidget {
  final List<Color> colors;
  final int selectedIndex;
  final Function(int) onColorTap;
  final VoidCallback? onCustomColor;
  const DreamSketchColorBar({
    super.key,
    this.colors = kPresetColors,
    required this.selectedIndex,
    required this.onColorTap,
    this.onCustomColor,
  });
  @override
  State<DreamSketchColorBar> createState() => _DreamSketchColorBarState();
}
class _DreamSketchColorBarState extends State<DreamSketchColorBar> {
  final _scrollCtrl = ScrollController();
  void _scrollLeft() => _scrollCtrl.animateTo(
        (_scrollCtrl.offset - 100).clamp(0, double.infinity),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
  void _scrollRight() => _scrollCtrl.animateTo(
        _scrollCtrl.offset + 100,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          _buildArrow(Icons.chevron_left, _scrollLeft),
          Expanded(
            child: ListView.separated(
              controller: _scrollCtrl,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              itemCount: widget.colors.length + 1,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, index) {
                if (index == widget.colors.length) return _buildCustomBtn();
                return _buildColorDot(index);
              },
            ),
          ),
          _buildArrow(Icons.chevron_right, _scrollRight),
        ],
      ),
    );
  }
  Widget _buildArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 64.h,
        color: Colors.white,
        child: Icon(icon, size: 20.sp, color: Colors.grey.shade500),
      ),
    );
  }
  Widget _buildColorDot(int index) {
    final isSelected = index == widget.selectedIndex;
    final color = widget.colors[index];
    return GestureDetector(
      onTap: () => widget.onColorTap(index),
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFF6A5ACD) : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6A5ACD).withOpacity(0.35),
                    blurRadius: 6,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
      ),
    );
  }
  Widget _buildCustomBtn() {
    return GestureDetector(
      onTap: widget.onCustomColor,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: const BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green,
              Colors.blue,
              Colors.purple,
              Colors.red,
            ],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
