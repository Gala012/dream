import 'package:get/get.dart';
class DreamSketchColoringLogic extends GetxController {
  void onThemeTap(String theme) {
    Get.toNamed('/coloring-list', arguments: {'theme': theme});
  }
}
