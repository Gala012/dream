import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/index.dart';
class DreamSketchWatermarkLogic extends GetxController {
  final hasImage = false.obs;
  final watermarkText = ''.obs;
  final spacing = 'medium'.obs;
  final sizeValue = 16.0.obs;
  final angleValue = (-30.0).obs;
  final opacityValue = 0.5.obs;
  final isPickingImage = false.obs;
  final isSaving = false.obs;
  late final TextEditingController textController;
  final previewKey = GlobalKey();
  Uint8List? imageBytes;
  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
    textController.addListener(() {
      watermarkText.value = textController.text;
    });
  }
  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
  Future<void> onSelectImageTap() async {
    if (isPickingImage.value) return;
    try {
      isPickingImage.value = true;
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      imageBytes = await picked.readAsBytes();
      hasImage.value = true;
    } catch (e) {
      errorToast('Failed to pick image: ${e.toString()}');
    } finally {
      isPickingImage.value = false;
    }
  }
  void onTextChange(String v) => watermarkText.value = v;
  void onClearText() {
    textController.clear();
    watermarkText.value = '';
  }
  void onSpacingChange(String v) => spacing.value = v;
  void onSizeChange(double v) => sizeValue.value = v;
  void onAngleChange(double v) => angleValue.value = v;
  void onOpacityChange(double v) => opacityValue.value = v;
  double get spacingPixels {
    switch (spacing.value) {
      case 'small':
        return 20;
      case 'large':
        return 80;
      default:
        return 48;
    }
  }
  Future<void> onSaveTap() async {
    if (!hasImage.value) return;
    if (watermarkText.value.trim().isEmpty) {
      errorToast('Please enter watermark text');
      return;
    }
    if (isSaving.value) return;
    try {
      isSaving.value = true;
      final pngBytes = await _renderWatermarkedImage();
      if (pngBytes == null) {
        errorToast('Failed to generate image');
        return;
      }
      await Gal.putImageBytes(pngBytes, album: 'DreamSketch');
      successToast('Saved to gallery');
    } on GalException catch (e) {
      if (e.type == GalExceptionType.accessDenied) {
        _showPermissionDialog();
      } else {
        errorToast('Save failed: ${e.type.name}');
      }
    } catch (e) {
      errorToast('Save failed: ${e.toString()}');
    } finally {
      isSaving.value = false;
    }
  }
  Future<Uint8List?> _renderWatermarkedImage() async {
    try {
      final codec = await ui.instantiateImageCodec(imageBytes!);
      final frame = await codec.getNextFrame();
      final srcImage = frame.image;
      final w = srcImage.width.toDouble();
      final h = srcImage.height.toDouble();
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawImage(srcImage, Offset.zero, Paint());
      final scaleFactor = w / 375.0;
      final fontSize = sizeValue.value * scaleFactor;
      final gap = spacingPixels * scaleFactor;
      final radians = angleValue.value * math.pi / 180;
      final textSpan = TextSpan(
        text: watermarkText.value,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white.withValues(alpha: opacityValue.value),
          fontWeight: FontWeight.w500,
        ),
      );
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)
        ..layout();
      final diagonal = math.sqrt(w * w + h * h);
      canvas.save();
      canvas.translate(w / 2, h / 2);
      canvas.rotate(radians);
      final stepX = tp.width + gap;
      final stepY = tp.height + gap * 0.5;
      for (double y = -diagonal; y < diagonal; y += stepY) {
        for (double x = -diagonal; x < diagonal; x += stepX) {
          tp.paint(canvas, Offset(x, y));
        }
      }
      canvas.restore();
      final picture = recorder.endRecording();
      final finalImage = await picture.toImage(srcImage.width, srcImage.height);
      final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }
  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Please allow photo library access in Settings to save images.',
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Gal.open();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
