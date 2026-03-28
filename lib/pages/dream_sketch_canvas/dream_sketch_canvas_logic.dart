import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/dream_sketch_drawing_painter.dart';
import '../../utils/color_picker_dialog.dart';
import '../../utils/drawing_save_helper.dart';
class DreamSketchCanvasLogic extends GetxController {
  final selectedTool = 'pen'.obs;
  final strokeWidth = 6.0.obs;
  final selectedColor = const Color(0xFF000000).obs;
  final drawingUpdateTrigger = 0.obs;
  final isSaving = false.obs;
  final showStrokeSlider = false.obs;
  final canvasKey = GlobalKey();
  final List<DrawingStroke> strokes = [];
  final List<DrawingStroke> _undoBuffer = [];
  DrawingStroke? currentStroke;
  Offset? eraserPosition;
  bool get canUndo {
    drawingUpdateTrigger.value;
    return strokes.isNotEmpty;
  }
  bool get canRedo {
    drawingUpdateTrigger.value;
    return _undoBuffer.isNotEmpty;
  }
  void onPenTap() => selectedTool.value = 'pen';
  void onEraserTap() => selectedTool.value = 'eraser';
  void onBrushSizeTap() {
    showStrokeSlider.value = !showStrokeSlider.value;
  }
  void onStrokeWidthChange(double value) {
    strokeWidth.value = value;
  }
  void startDrawing(Offset pos) {
    if (selectedTool.value == 'eraser') {
      eraserPosition = pos;
      _eraseAt(pos);
    } else {
      _undoBuffer.clear();
      currentStroke = DrawingStroke(
        points: [pos],
        color: selectedColor.value,
        width: strokeWidth.value,
      );
    }
    drawingUpdateTrigger.value++;
  }
  void updateDrawing(Offset pos) {
    if (selectedTool.value == 'eraser') {
      eraserPosition = pos;
      _eraseAt(pos);
    } else {
      currentStroke?.points.add(pos);
    }
    drawingUpdateTrigger.value++;
  }
  void endDrawing() {
    if (currentStroke != null && currentStroke!.points.length > 1) {
      strokes.add(currentStroke!);
    }
    currentStroke = null;
    eraserPosition = null;
    drawingUpdateTrigger.value++;
  }
  void _eraseAt(Offset pos) {
    final radius = strokeWidth.value * 2;
    strokes.removeWhere((s) => s.containsPoint(pos, radius));
  }
  void onUndoTap() {
    if (strokes.isEmpty) return;
    _undoBuffer.add(strokes.removeLast());
    drawingUpdateTrigger.value++;
  }
  void onRedoTap() {
    if (_undoBuffer.isEmpty) return;
    strokes.add(_undoBuffer.removeLast());
    drawingUpdateTrigger.value++;
  }
  void onClearTap() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Canvas'),
        content: const Text('Clear all drawings?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              strokes.clear();
              _undoBuffer.clear();
              currentStroke = null;
              drawingUpdateTrigger.value++;
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  Future<void> onSaveTap() async {
    if (isSaving.value) return;
    isSaving.value = true;
    await saveCanvasToGallery(canvasKey, drawingType: 'canvas');
    isSaving.value = false;
  }
  Future<void> onColorTap() async {
    final picked = await showColorPickerDialog(selectedColor.value);
    if (picked != null) {
      selectedColor.value = picked;
      if (selectedTool.value == 'eraser') {
        selectedTool.value = 'pen';
      }
    }
  }
}
