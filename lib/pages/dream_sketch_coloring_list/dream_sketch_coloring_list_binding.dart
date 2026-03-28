import 'package:get/get.dart';
import 'dream_sketch_coloring_list_logic.dart';
class DreamSketchColoringListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchColoringListLogic());
  }
}
