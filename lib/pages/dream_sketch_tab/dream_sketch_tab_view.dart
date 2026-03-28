import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dream_sketch_home/dream_sketch_home_view.dart';
import '../dream_sketch_coloring/dream_sketch_coloring_view.dart';
import '../dream_sketch_settings/dream_sketch_settings_view.dart';
import 'dream_sketch_tab_logic.dart';
class DreamSketchTabView extends GetView<DreamSketchTabLogic> {
  const DreamSketchTabView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            DreamSketchHomeView(),
            DreamSketchColoringView(),
            DreamSketchSettingsView(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.onTabTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.palette_outlined),
                activeIcon: Icon(Icons.palette_rounded),
                label: 'Coloring',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
