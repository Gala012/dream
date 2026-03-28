import 'package:get/get.dart';
import 'dream_sketch_home_logic.dart';
class DreamSketchHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchHomeLogic());
  }
}
