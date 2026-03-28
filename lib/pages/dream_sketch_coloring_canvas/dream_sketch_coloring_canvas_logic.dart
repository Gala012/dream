import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../components/dream_sketch_color_bar.dart';
import '../../components/dream_sketch_drawing_painter.dart';
import '../../utils/color_picker_dialog.dart';
import '../../utils/drawing_save_helper.dart';
import '../../utils/index.dart';
enum ColoringMode { bucket, brush }
abstract class _CanvasAction {}
class _FillAction extends _CanvasAction {
  final List<int> changedPixels;
  final List<int> oldColors;
  final int newColor;
  _FillAction(this.changedPixels, this.oldColors, this.newColor);
}
class _BrushAction extends _CanvasAction {
  final DrawingStroke stroke;
  _BrushAction(this.stroke);
}
class DreamSketchColoringCanvasLogic extends GetxController {
  late String theme;
  late int imageId;
  late String imagePath;
  final colorIndex = 0.obs;
  final selectedColor = Rx<Color>(kPresetColors[0]);
  final mode = ColoringMode.bucket.obs;
  final isLoading = true.obs;
  final isFilling = false.obs;
  final isSaving = false.obs;
  final repaint = 0.obs;
  final canvasKey = GlobalKey();
  final transformationController = TransformationController();
  ui.Image? lineArtImage;
  int imgWidth = 0;
  int imgHeight = 0;
  Uint8List? _lineArtPixels;
  Uint32List? fillLayer;
  ui.Image? fillRenderImage;
  final List<DrawingStroke> strokes = [];
  DrawingStroke? currentStroke;
  Offset? pendingTapPos;
  final Set<int> _activePointers = {};
  final _undoStack = <_CanvasAction>[];
  final _redoStack = <_CanvasAction>[];
  bool get canUndo {
    repaint.value;
    return _undoStack.isNotEmpty;
  }
  bool get canRedo {
    repaint.value;
    return _redoStack.isNotEmpty;
  }
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    theme = args['theme'] as String? ?? '';
    imageId = args['imageId'] as int? ?? 0;
    imagePath = args['imagePath'] as String? ?? '';
    _loadLineArt();
  }
  @override
  void onClose() {
    transformationController.dispose();
    super.onClose();
  }
  Future<void> _loadLineArt() async {
    if (imagePath.isEmpty) {
      isLoading.value = false;
      return;
    }
    try {
      final data = await rootBundle.load(imagePath);
      final bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      lineArtImage = frame.image;
      imgWidth = lineArtImage!.width;
      imgHeight = lineArtImage!.height;
      final bd = await lineArtImage!.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      _lineArtPixels = bd!.buffer.asUint8List();
      fillLayer = Uint32List(imgWidth * imgHeight);
      isLoading.value = false;
      repaint.value++;
    } catch (e) {
      isLoading.value = false;
      errorToast('Failed to load image');
    }
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
  void onBucketTap() => mode.value = ColoringMode.bucket;
  void onBrushTap() => mode.value = ColoringMode.brush;
  Future<void> onCanvasTap(Offset localPos, Size canvasSize) async {
    if (fillLayer == null || _lineArtPixels == null) return;
    if (isFilling.value) return;
    final imageX = (localPos.dx / canvasSize.width * imgWidth)
        .round()
        .clamp(0, imgWidth - 1);
    final imageY = (localPos.dy / canvasSize.height * imgHeight)
        .round()
        .clamp(0, imgHeight - 1);
    isFilling.value = true;
    await _floodFill(imageX, imageY, selectedColor.value);
    isFilling.value = false;
  }
  Future<void> _floodFill(int startX, int startY, Color fillColor) async {
    final fillColorInt = fillColor.toARGB32();
    final startIdx = startY * imgWidth + startX;
    final targetColor = fillLayer![startIdx];
    if (targetColor == fillColorInt) return;
    if (_isLineBoundary(startIdx)) return;
    final changedPixels = <int>[];
    final oldColors = <int>[];
    final queue = Queue<int>();
    final visited = <int>{};
    queue.add(startIdx);
    visited.add(startIdx);
    while (queue.isNotEmpty) {
      final idx = queue.removeFirst();
      if (fillLayer![idx] != targetColor) continue;
      if (_isLineBoundary(idx)) continue;
      changedPixels.add(idx);
      oldColors.add(fillLayer![idx]);
      fillLayer![idx] = fillColorInt;
      final x = idx % imgWidth;
      final y = idx ~/ imgWidth;
      for (final d in [
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
      ]) {
        final nx = x + d[0];
        final ny = y + d[1];
        if (nx >= 0 && nx < imgWidth && ny >= 0 && ny < imgHeight) {
          final nIdx = ny * imgWidth + nx;
          if (visited.add(nIdx)) {
            queue.add(nIdx);
          }
        }
      }
    }
    if (changedPixels.isEmpty) return;
    _undoStack.add(_FillAction(changedPixels, oldColors, fillColorInt));
    _redoStack.clear();
    await _regenerateFillImage();
  }
  bool _isLineBoundary(int pixelIdx) {
    final b = pixelIdx * 4;
    final r = _lineArtPixels![b];
    final g = _lineArtPixels![b + 1];
    final bl = _lineArtPixels![b + 2];
    final a = _lineArtPixels![b + 3];
    return a > 128 && r < 100 && g < 100 && bl < 100;
  }
  Future<void> _regenerateFillImage() async {
    if (fillLayer == null) return;
    final bytes = Uint8List(imgWidth * imgHeight * 4);
    for (int i = 0; i < fillLayer!.length; i++) {
      final c = fillLayer![i];
      bytes[i * 4] = (c >> 16) & 0xFF;
      bytes[i * 4 + 1] = (c >> 8) & 0xFF;
      bytes[i * 4 + 2] = c & 0xFF;
      bytes[i * 4 + 3] = (c >> 24) & 0xFF;
    }
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      bytes,
      imgWidth,
      imgHeight,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    fillRenderImage = await completer.future;
    repaint.value++;
  }
  void onPointerDown(PointerDownEvent event) {
    _activePointers.add(event.pointer);
    if (mode.value == ColoringMode.brush && _activePointers.length == 1) {
      _redoStack.clear();
      currentStroke = DrawingStroke(
        points: [event.localPosition],
        color: selectedColor.value,
        width: 8.0,
      );
      repaint.value++;
    }
  }
  void onPointerMove(PointerMoveEvent event, Size canvasSize) {
    if (mode.value == ColoringMode.brush &&
        _activePointers.length == 1 &&
        currentStroke != null) {
      currentStroke!.points.add(event.localPosition);
      repaint.value++;
    }
  }
  void onPointerUp(PointerUpEvent event) {
    _activePointers.remove(event.pointer);
    if (mode.value == ColoringMode.brush && _activePointers.isEmpty) {
      if (currentStroke != null && currentStroke!.points.length > 1) {
        strokes.add(currentStroke!);
        _undoStack.add(_BrushAction(currentStroke!));
      }
      currentStroke = null;
      repaint.value++;
    }
  }
  void startBrush(Offset pos) {
    _redoStack.clear();
    currentStroke = DrawingStroke(
      points: [pos],
      color: selectedColor.value,
      width: 8.0,
    );
    repaint.value++;
  }
  void updateBrush(Offset pos) {
    currentStroke?.points.add(pos);
    repaint.value++;
  }
  void endBrush() {
    if (currentStroke != null && currentStroke!.points.length > 1) {
      strokes.add(currentStroke!);
      _undoStack.add(_BrushAction(currentStroke!));
    }
    currentStroke = null;
    repaint.value++;
  }
  Future<void> onUndoTap() async {
    if (_undoStack.isEmpty) return;
    final action = _undoStack.removeLast();
    _redoStack.add(action);
    if (action is _FillAction) {
      for (int i = 0; i < action.changedPixels.length; i++) {
        fillLayer![action.changedPixels[i]] = action.oldColors[i];
      }
      await _regenerateFillImage();
    } else if (action is _BrushAction) {
      strokes.remove(action.stroke);
      repaint.value++;
    }
  }
  Future<void> onRedoTap() async {
    if (_redoStack.isEmpty) return;
    final action = _redoStack.removeLast();
    _undoStack.add(action);
    if (action is _FillAction) {
      for (final idx in action.changedPixels) {
        fillLayer![idx] = action.newColor;
      }
      await _regenerateFillImage();
    } else if (action is _BrushAction) {
      strokes.add(action.stroke);
      repaint.value++;
    }
  }
  void onClearTap() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Canvas'),
        content: const Text('Remove all coloring? This cannot be undone.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _doClear();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  Future<void> _doClear() async {
    if (fillLayer != null) fillLayer = Uint32List(imgWidth * imgHeight);
    strokes.clear();
    _undoStack.clear();
    _redoStack.clear();
    fillRenderImage = null;
    repaint.value++;
  }
  void onResetZoom() {
    transformationController.value = Matrix4.identity();
  }
  Future<void> onSaveTap() async {
    if (isSaving.value) return;
    isSaving.value = true;
    try {
      final savedMatrix = transformationController.value.clone();
      transformationController.value = Matrix4.identity();
      await WidgetsBinding.instance.endOfFrame;
      await saveCanvasToGallery(canvasKey, drawingType: 'coloring');
      transformationController.value = savedMatrix;
    } finally {
      isSaving.value = false;
    }
  }
}
