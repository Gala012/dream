import 'package:get/get.dart';
import 'dream_sketch_trace_drawing_logic.dart';
class DreamSketchTraceDrawingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DreamSketchTraceDrawingLogic());
  }
}
