import 'package:get/get.dart';
import 'dream_sketch_photo_drawing_logic.dart';
class DreamSketchPhotoDrawingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchPhotoDrawingLogic());
  }
}
