import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/dream_sketch_color_bar.dart';
import '../../components/dream_sketch_drawing_painter.dart';
import '../../utils/color_picker_dialog.dart';
import '../../utils/drawing_save_helper.dart';
import '../../utils/index.dart';
class DreamSketchShapeDrawingLogic extends GetxController {
  final selectedIndex = (-1).obs;
  final colorIndex = 0.obs;
  final selectedColor = kPresetColors[0].obs;
  final strokeWidth = 4.0.obs;
  final drawingUpdateTrigger = 0.obs;
  final isSaving = false.obs;
  final showStrokeSlider = false.obs;
  final showBackground = true.obs;
  final canvasKey = GlobalKey();
  final List<DrawingStroke> strokes = [];
  final List<DrawingStroke> _undoBuffer = [];
  DrawingStroke? currentStroke;
  bool get canUndo {
    drawingUpdateTrigger.value;
    return strokes.isNotEmpty;
  }
  bool get canRedo {
    drawingUpdateTrigger.value;
    return _undoBuffer.isNotEmpty;
  }
  void onShapeSelect(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      strokes.clear();
      _undoBuffer.clear();
      drawingUpdateTrigger.value++;
    }
  }
  void startDrawing(Offset pos) {
    _undoBuffer.clear();
    currentStroke = DrawingStroke(
      points: [pos],
      color: selectedColor.value,
      width: strokeWidth.value,
    );
    drawingUpdateTrigger.value++;
  }
  void updateDrawing(Offset pos) {
    currentStroke?.points.add(pos);
    drawingUpdateTrigger.value++;
  }
  void endDrawing() {
    if (currentStroke != null && currentStroke!.points.length > 1) {
      strokes.add(currentStroke!);
    }
    currentStroke = null;
    drawingUpdateTrigger.value++;
  }
  void onColorSelect(int index) {
    colorIndex.value = index;
    selectedColor.value = kPresetColors[index];
  }
  Future<void> onCustomColorTap() async {
    final picked = await showColorPickerDialog(selectedColor.value);
    if (picked != null) {
      selectedColor.value = picked;
      colorIndex.value = -1;
    }
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
    strokes.clear();
    _undoBuffer.clear();
    currentStroke = null;
    drawingUpdateTrigger.value++;
  }
  void onStrokeTap() {
    showStrokeSlider.value = !showStrokeSlider.value;
  }
  void onStrokeWidthChange(double value) {
    strokeWidth.value = value;
  }
  Future<void> onSaveTap() async {
    if (selectedIndex.value < 0) {
      errorToast('Please select a shape first');
      return;
    }
    if (isSaving.value) return;
    isSaving.value = true;
    showBackground.value = false;
    await Future.delayed(const Duration(milliseconds: 100));
    await saveCanvasToGallery(canvasKey, drawingType: 'shape');
    showBackground.value = true;
    isSaving.value = false;
  }
}
