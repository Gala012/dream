import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DreamSketchColoringListLogic extends GetxController {
  late String theme;
  late String themeTitle;
  late List<String?> imagePaths;
  late Color themeColor;
  late IconData themeIcon;
  late String coverPath;
  static const Map<String, int> _themeImageCount = {
    'flower': 6,
    'cartoon': 7,
    'traffic': 6,
    'food': 7,
    'animal': 6,
    'nature': 7,
    'fruit': 6,
    'number': 10,
  };
  static const Map<String, Color> _themeColors = {
    'flower': Color(0xFFE91E63),
    'cartoon': Color(0xFF9C27B0),
    'traffic': Color(0xFF2196F3),
    'food': Color(0xFFFF9800),
    'animal': Color(0xFF4CAF50),
    'nature': Color(0xFF009688),
    'fruit': Color(0xFFFF5722),
    'number': Color(0xFF673AB7),
  };
  static const Map<String, IconData> _themeIcons = {
    'flower': Icons.local_florist_rounded,
    'cartoon': Icons.face_rounded,
    'traffic': Icons.directions_car_rounded,
    'food': Icons.restaurant_rounded,
    'animal': Icons.pets_rounded,
    'nature': Icons.nature_rounded,
    'fruit': Icons.apple_rounded,
    'number': Icons.numbers_rounded,
  };
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    theme = args['theme'] as String? ?? 'cartoon';
    themeTitle = theme[0].toUpperCase() + theme.substring(1);
    themeColor = _themeColors[theme] ?? const Color(0xFF667EEA);
    themeIcon = _themeIcons[theme] ?? Icons.palette_rounded;
    coverPath = 'assets/coloring/$theme/cover.jpg';
    _buildImagePaths();
  }
  void _buildImagePaths() {
    final count = _themeImageCount[theme] ?? 0;
    if (count > 0) {
      if (theme == 'number') {
        imagePaths = List.generate(
          count,
          (i) => 'assets/coloring/$theme/${theme}_$i.png',
        );
      } else {
        imagePaths = List.generate(
          count,
          (i) => 'assets/coloring/$theme/${theme}_${i + 1}.png',
        );
      }
    } else {
      imagePaths = List.generate(6, (_) => null);
    }
  }
  void onImageTap(int index) {
    final path = imagePaths[index];
    if (path == null) return;
    Get.toNamed(
      '/coloring-canvas',
      arguments: {'theme': theme, 'imageId': index, 'imagePath': path},
    );
  }
}
