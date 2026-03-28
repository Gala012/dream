import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/index.dart';
class DreamSketchFrostedGlassLogic extends GetxController {
  final hasImage = false.obs;
  final blurValue = 5.0.obs;
  final isPickingImage = false.obs;
  final isSaving = false.obs;
  final previewKey = GlobalKey();
  Uint8List? imageBytes;
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
  void onBlurChange(double value) => blurValue.value = value;
  Future<void> onSaveTap() async {
    if (!hasImage.value || imageBytes == null) return;
    if (isSaving.value) return;
    try {
      isSaving.value = true;
      final pngBytes = await _renderBlurredImage();
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
  Future<Uint8List?> _renderBlurredImage() async {
    try {
      final codec = await ui.instantiateImageCodec(imageBytes!);
      final frame = await codec.getNextFrame();
      final srcImage = frame.image;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawImage(srcImage, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final blurRecorder = ui.PictureRecorder();
      final blurCanvas = Canvas(blurRecorder);
      final blurPaint = Paint()
        ..imageFilter = ui.ImageFilter.blur(
          sigmaX: blurValue.value * srcImage.width / 375,
          sigmaY: blurValue.value * srcImage.width / 375,
          tileMode: TileMode.clamp,
        );
      final tempImage = await picture.toImage(srcImage.width, srcImage.height);
      blurCanvas.drawImage(tempImage, Offset.zero, blurPaint);
      final blurPicture = blurRecorder.endRecording();
      final finalImage = await blurPicture.toImage(srcImage.width, srcImage.height);
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
