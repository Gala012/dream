import 'package:dream_sketch/pages/dream_sketch_home/dream_sketch_home_point.dart';
import 'package:dream_sketch/pages/dream_sketch_mind/dream_sketch_mind_binding.dart';
import 'package:dream_sketch/pages/dream_sketch_mind/dream_sketch_mind_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/dream_sketch_tab/dream_sketch_tab_view.dart';
import '../pages/dream_sketch_tab/dream_sketch_tab_binding.dart';
import '../pages/dream_sketch_canvas/dream_sketch_canvas_view.dart';
import '../pages/dream_sketch_canvas/dream_sketch_canvas_binding.dart';
import '../pages/dream_sketch_trace_drawing/dream_sketch_trace_drawing_view.dart';
import '../pages/dream_sketch_trace_drawing/dream_sketch_trace_drawing_binding.dart';
import '../pages/dream_sketch_shape_drawing/dream_sketch_shape_drawing_view.dart';
import '../pages/dream_sketch_shape_drawing/dream_sketch_shape_drawing_binding.dart';
import '../pages/dream_sketch_photo_drawing/dream_sketch_photo_drawing_view.dart';
import '../pages/dream_sketch_photo_drawing/dream_sketch_photo_drawing_binding.dart';
import '../pages/dream_sketch_frosted_glass/dream_sketch_frosted_glass_view.dart';
import '../pages/dream_sketch_frosted_glass/dream_sketch_frosted_glass_binding.dart';
import '../pages/dream_sketch_watermark/dream_sketch_watermark_view.dart';
import '../pages/dream_sketch_watermark/dream_sketch_watermark_binding.dart';
import '../pages/dream_sketch_coloring_list/dream_sketch_coloring_list_view.dart';
import '../pages/dream_sketch_coloring_list/dream_sketch_coloring_list_binding.dart';
import '../pages/dream_sketch_coloring_canvas/dream_sketch_coloring_canvas_view.dart';
import '../pages/dream_sketch_coloring_canvas/dream_sketch_coloring_canvas_binding.dart';
import '../pages/dream_sketch_history/dream_sketch_history_view.dart';
import '../pages/dream_sketch_history/dream_sketch_history_binding.dart';
import 'db_dream_sketch/data.dart';
const primaryColor = Color(0xFF6A5ACD);
const lightPrimaryColor = Color(0xFFA78BFA);
const darkPrimaryColor = Color(0xFF4C3D9C);
const accentPink = Color(0xFFFF9EC1);
const accentGold = Color(0xFFF4E8C1);
const accentGreen = Color(0xFFA3D9B8);
const bgColor = Color(0xFFF8F6FF);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Get.putAsync(() async {
    final db = DreamSketchDatabase();
    await db.database;
    return db;
  });
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: Dream,
          initialRoute: '/',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: bgColor,
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              surface: Color(0xFFFFFFFF),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF1A1A2E),
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(size: 22, color: Color(0xFF1A1A2E)),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: primaryColor,
              unselectedItemColor: Color(0xFF9E9E9E),
              elevation: 0,
              backgroundColor: Color(0xFFFFFFFF),
            ),
            sliderTheme: const SliderThemeData(
              activeTrackColor: primaryColor,
              thumbColor: primaryColor,
              inactiveTrackColor: Color(0xFFDDD6FE),
            ),
            dividerTheme: DividerThemeData(
              thickness: 1,
              color: Colors.grey[200],
            ),
          ),
        );
      },
    );
  }
}
List<GetPage<dynamic>> Dream = [
  GetPage(
    name: '/',
    page: () => const DreamSketchMindView(),
    binding: DreamSketchMindBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/tab',
    page: () => const DreamSketchTabView(),
    binding: DreamSketchTabBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/canvas',
    page: () => const DreamSketchCanvasView(),
    binding: DreamSketchCanvasBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/home-point',
    page: () => const DreamSketchHomePoint(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/trace-drawing',
    page: () => const DreamSketchTraceDrawingView(),
    binding: DreamSketchTraceDrawingBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/shape-drawing',
    page: () => const DreamSketchShapeDrawingView(),
    binding: DreamSketchShapeDrawingBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/photo-drawing',
    page: () => const DreamSketchPhotoDrawingView(),
    binding: DreamSketchPhotoDrawingBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/frosted-glass',
    page: () => const DreamSketchFrostedGlassView(),
    binding: DreamSketchFrostedGlassBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/watermark',
    page: () => const DreamSketchWatermarkView(),
    binding: DreamSketchWatermarkBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/coloring-list',
    page: () => const DreamSketchColoringListView(),
    binding: DreamSketchColoringListBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/coloring-canvas',
    page: () => const DreamSketchColoringCanvasView(),
    binding: DreamSketchColoringCanvasBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/history',
    page: () => const DreamSketchHistoryView(),
    binding: DreamSketchHistoryBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
];