import 'package:get/get.dart';
import 'dream_sketch_tab_logic.dart';
import '../dream_sketch_home/dream_sketch_home_logic.dart';
import '../dream_sketch_coloring/dream_sketch_coloring_logic.dart';
import '../dream_sketch_settings/dream_sketch_settings_logic.dart';
class DreamSketchTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchTabLogic());
    Get.lazyPut(() => DreamSketchHomeLogic());
    Get.lazyPut(() => DreamSketchColoringLogic());
    Get.lazyPut(() => DreamSketchSettingsLogic());
  }
}
