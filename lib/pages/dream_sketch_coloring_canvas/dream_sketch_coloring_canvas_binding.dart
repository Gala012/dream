import 'package:get/get.dart';
import 'dream_sketch_coloring_canvas_logic.dart';
class DreamSketchColoringCanvasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchColoringCanvasLogic());
  }
}
