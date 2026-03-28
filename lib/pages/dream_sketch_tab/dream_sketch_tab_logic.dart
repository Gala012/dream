import 'package:get/get.dart';
class DreamSketchTabLogic extends GetxController {
  final currentIndex = 0.obs;
  void onTabTap(int index) => currentIndex.value = index;
}
