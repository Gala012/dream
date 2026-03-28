import 'package:get/get.dart';
import 'dream_sketch_history_logic.dart';
class DreamSketchHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchHistoryLogic());
  }
}
