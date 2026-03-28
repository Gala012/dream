import 'package:get/get.dart';
import 'dream_sketch_settings_logic.dart';
class DreamSketchSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchSettingsLogic());
  }
}
