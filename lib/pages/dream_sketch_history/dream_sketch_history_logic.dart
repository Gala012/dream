import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_dream_sketch/data.dart';
import '../../db_dream_sketch/db_dream_sketch_entity.dart';
import '../../utils/index.dart';
class DreamSketchHistoryLogic extends GetxController {
  final isLoading = true.obs;
  final historyList = <DrawingHistory>[].obs;
  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }
  Future<void> _loadHistory() async {
    try {
      isLoading.value = true;
      final db = Get.find<DreamSketchDatabase>();
      final list = await db.getDrawingHistory();
      historyList.value = list;
    } catch (e) {
      errorToast('Failed to load history: ${e.toString()}');
      historyList.value = [];
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> onRefresh() async {
    await _loadHistory();
  }
  void onDeleteTap(DrawingHistory item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete History'),
        content: const Text('Remove this item from history? The image in your gallery will not be deleted.'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _deleteHistory(item);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  Future<void> _deleteHistory(DrawingHistory item) async {
    try {
      final db = Get.find<DreamSketchDatabase>();
      final result = await db.deleteDrawingHistory(item.id!);
      if (result > 0) {
        historyList.remove(item);
        successToast('Deleted successfully');
      } else {
        errorToast('Failed to delete');
      }
    } catch (e) {
      errorToast('Failed to delete: ${e.toString()}');
    }
  }
  String getDrawingTypeLabel(String type) {
    switch (type) {
      case 'canvas':
        return 'Free Drawing';
      case 'trace':
        return 'Trace Drawing';
      case 'shape':
        return 'Shape Drawing';
      case 'photo':
        return 'Photo Drawing';
      case 'coloring':
        return 'Coloring';
      default:
        return 'Drawing';
    }
  }
  Color getDrawingTypeColor(String type) {
    switch (type) {
      case 'canvas':
        return const Color(0xFF667EEA);
      case 'trace':
        return const Color(0xFF4CAF50);
      case 'shape':
        return const Color(0xFF9C27B0);
      case 'photo':
        return const Color(0xFF2196F3);
      case 'coloring':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF667EEA);
    }
  }
}
