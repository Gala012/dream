import 'package:get/get.dart';

import 'dream_sketch_mind_logic.dart';

class DreamSketchMindBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      DreamSketchMindLogic(),
      permanent: true,
    );
  }
}
