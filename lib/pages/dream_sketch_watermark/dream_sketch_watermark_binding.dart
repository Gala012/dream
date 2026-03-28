import 'package:get/get.dart';
import 'dream_sketch_watermark_logic.dart';
class DreamSketchWatermarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchWatermarkLogic());
  }
}
