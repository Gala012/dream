import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dream_sketch_mind_logic.dart';

class DreamSketchMindView extends GetView<DreamSketchMindLogic> {
  const DreamSketchMindView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.acrbwvux.value
              ? const CircularProgressIndicator(color: Colors.deepPurple)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.aqle();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
