import 'package:get/get.dart';
import 'dream_sketch_shape_drawing_logic.dart';
class DreamSketchShapeDrawingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchShapeDrawingLogic());
  }
}
