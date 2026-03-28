import 'package:get/get.dart';
import 'dream_sketch_coloring_logic.dart';
class DreamSketchColoringBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchColoringLogic());
  }
}
