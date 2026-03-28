import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../db_dream_sketch/data.dart';
import '../db_dream_sketch/db_dream_sketch_entity.dart';
import 'index.dart';
Future<bool> saveCanvasToGallery(GlobalKey repaintKey, {String drawingType = 'canvas', bool navigateBack = true}) async {
  try {
    final boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      errorToast('Unable to capture canvas');
      return false;
    }
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      errorToast('Failed to generate image');
      return false;
    }
    final Uint8List pngBytes = byteData.buffer.asUint8List();
    await Gal.putImageBytes(pngBytes, album: 'DreamSketch');
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final historyDir = Directory('${appDir.path}/drawing_history');
      if (!historyDir.existsSync()) {
        historyDir.createSync(recursive: true);
      }
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final localFile = File('${historyDir.path}/$fileName');
      await localFile.writeAsBytes(pngBytes);
      final db = Get.find<DreamSketchDatabase>();
      await db.insertDrawingHistory(DrawingHistory(
        imagePath: localFile.path,
        drawingType: drawingType,
        createdAt: DateTime.now().toIso8601String(),
      ));
    } catch (e) {
    }
    successToast('Saved to gallery');
    if (navigateBack) {
      Get.back();
    }
    return true;
  } on GalException catch (e) {
    if (e.type == GalExceptionType.accessDenied) {
      _showPermissionDialog();
    } else {
      errorToast('Save failed: ${e.type.name}');
    }
    return false;
  } catch (e) {
    errorToast('Save failed: ${e.toString()}');
    return false;
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
        TextButton(
          onPressed: Get.back,
          child: const Text('Cancel'),
        ),
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
