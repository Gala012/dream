import 'package:get/get.dart';
import 'dream_sketch_canvas_logic.dart';
class DreamSketchCanvasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchCanvasLogic());
  }
}
