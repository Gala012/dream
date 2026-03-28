import 'package:get/get.dart';
import 'dream_sketch_frosted_glass_logic.dart';
class DreamSketchFrostedGlassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchFrostedGlassLogic());
  }
}
