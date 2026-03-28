import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/dream_sketch_color_bar.dart';
import '../../components/dream_sketch_drawing_painter.dart';
import '../../utils/color_picker_dialog.dart';
import '../../utils/drawing_save_helper.dart';
import '../../utils/index.dart';
class DreamSketchPhotoDrawingLogic extends GetxController {
  final hasPhoto = false.obs;
  final colorIndex = 0.obs;
  final selectedColor = kPresetColors[0].obs;
  final selectedTool = 'pen'.obs;
  final strokeWidth = 6.0.obs;
  final drawingUpdateTrigger = 0.obs;
  final isSaving = false.obs;
  final isPickingPhoto = false.obs;
  final showStrokeSlider = false.obs;
  final isEditingImage = false.obs;
  final showFilterPanel = false.obs;
  final imageScale = 1.0.obs;
  final imageOffsetX = 0.0.obs;
  final imageOffsetY = 0.0.obs;
  final imageRotation = 0.obs;
  final selectedFilter = 'none'.obs;
  final canvasKey = GlobalKey();
  Uint8List? photoBytes;
  final List<DrawingStroke> strokes = [];
  final List<DrawingStroke> _undoBuffer = [];
  DrawingStroke? currentStroke;
  Offset? eraserPosition;
  Offset? _lastFocalPoint;
  double? _lastScale;
  bool get canUndo {
    drawingUpdateTrigger.value;
    return strokes.isNotEmpty;
  }
  bool get canRedo {
    drawingUpdateTrigger.value;
    return _undoBuffer.isNotEmpty;
  }
  Future<void> onSelectPhotoTap() async {
    if (isPickingPhoto.value) return;
    try {
      isPickingPhoto.value = true;
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      photoBytes = await picked.readAsBytes();
      strokes.clear();
      _undoBuffer.clear();
      _resetImageTransform();
      hasPhoto.value = true;
      drawingUpdateTrigger.value++;
    } catch (e) {
      errorToast('Failed to pick photo: ${e.toString()}');
    } finally {
      isPickingPhoto.value = false;
    }
  }
  void _resetImageTransform() {
    imageScale.value = 1.0;
    imageOffsetX.value = 0.0;
    imageOffsetY.value = 0.0;
    imageRotation.value = 0;
    selectedFilter.value = 'none';
  }
  void onImageEditTap() {
    isEditingImage.value = !isEditingImage.value;
    showStrokeSlider.value = false;
    showFilterPanel.value = false;
  }
  void onRotateTap() {
    imageRotation.value = (imageRotation.value + 1) % 4;
    drawingUpdateTrigger.value++;
  }
  void onFilterTap() {
    showFilterPanel.value = !showFilterPanel.value;
    showStrokeSlider.value = false;
  }
  void onFilterSelect(String filter) {
    selectedFilter.value = filter;
    drawingUpdateTrigger.value++;
  }
  void onImageScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
    _lastScale = imageScale.value;
  }
  void onImageScaleUpdate(ScaleUpdateDetails details) {
    if (_lastScale != null && _lastFocalPoint != null) {
      imageScale.value = (_lastScale! * details.scale).clamp(0.5, 3.0);
      final delta = details.focalPoint - _lastFocalPoint!;
      imageOffsetX.value += delta.dx;
      imageOffsetY.value += delta.dy;
      _lastFocalPoint = details.focalPoint;
    }
    drawingUpdateTrigger.value++;
  }
  void onImageScaleEnd(ScaleEndDetails details) {
    _lastFocalPoint = null;
    _lastScale = null;
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
  void onColorSelect(int index) {
    colorIndex.value = index;
    selectedColor.value = kPresetColors[index];
    if (selectedTool.value == 'eraser') {
      selectedTool.value = 'pen';
    }
  }
  Future<void> onCustomColorTap() async {
    final picked = await showColorPickerDialog(selectedColor.value);
    if (picked != null) {
      selectedColor.value = picked;
      colorIndex.value = -1;
      if (selectedTool.value == 'eraser') {
        selectedTool.value = 'pen';
      }
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
    if (!hasPhoto.value) {
      errorToast('Please select a photo first');
      return;
    }
    if (isSaving.value) return;
    isSaving.value = true;
    await saveCanvasToGallery(canvasKey, drawingType: 'photo');
    isSaving.value = false;
  }
}
