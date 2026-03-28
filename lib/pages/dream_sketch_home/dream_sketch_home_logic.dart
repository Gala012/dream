import 'package:get/get.dart';
class DreamSketchHomeLogic extends GetxController {
  void onTraceDrawingTap() => Get.toNamed('/trace-drawing');
  void onShapeDrawingTap() => Get.toNamed('/shape-drawing');
  void onPhotoDrawingTap() => Get.toNamed('/photo-drawing');
  void onCanvasTap() => Get.toNamed('/canvas');
  void onFrostedGlassTap() => Get.toNamed('/frosted-glass');
  void onWatermarkTap() => Get.toNamed('/watermark');
}
