import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_dream_sketch_entity.dart';
class DreamSketchDatabase extends GetxService {
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'dream_sketch.db');
    return await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS drawing_history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          image_path TEXT NOT NULL,
          drawing_type TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
  }
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trace_drawing_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        display_order INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE shape_drawing_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        shape_name TEXT NOT NULL,
        display_order INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE coloring_themes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        theme_name TEXT NOT NULL,
        theme_name_en TEXT NOT NULL,
        thumbnail_path TEXT NOT NULL,
        display_type TEXT NOT NULL,
        display_order INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE coloring_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        theme_id INTEGER NOT NULL,
        image_path TEXT NOT NULL,
        display_order INTEGER NOT NULL,
        FOREIGN KEY (theme_id) REFERENCES coloring_themes (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE drawing_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        drawing_type TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }
  Future<List<TraceDrawingImage>> getTraceDrawingImages() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'trace_drawing_images',
        orderBy: 'display_order ASC, id ASC',
      );
      return List.generate(maps.length, (i) {
        return TraceDrawingImage.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }
  Future<int> insertTraceDrawingImage(TraceDrawingImage image) async {
    try {
      final db = await database;
      return await db.insert('trace_drawing_images', image.toMap());
    } catch (e) {
      return -1;
    }
  }
  Future<List<ShapeDrawingImage>> getShapeDrawingImages() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'shape_drawing_images',
        orderBy: 'display_order ASC, id ASC',
      );
      return List.generate(maps.length, (i) {
        return ShapeDrawingImage.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }
  Future<int> insertShapeDrawingImage(ShapeDrawingImage image) async {
    try {
      final db = await database;
      return await db.insert('shape_drawing_images', image.toMap());
    } catch (e) {
      return -1;
    }
  }
  Future<List<ColoringTheme>> getColoringThemes() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'coloring_themes',
        orderBy: 'display_order ASC, id ASC',
      );
      return List.generate(maps.length, (i) {
        return ColoringTheme.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }
  Future<int> insertColoringTheme(ColoringTheme theme) async {
    try {
      final db = await database;
      return await db.insert('coloring_themes', theme.toMap());
    } catch (e) {
      return -1;
    }
  }
  Future<List<ColoringImage>> getColoringImagesByThemeId(int themeId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'coloring_images',
        where: 'theme_id = ?',
        whereArgs: [themeId],
        orderBy: 'display_order ASC, id ASC',
      );
      return List.generate(maps.length, (i) {
        return ColoringImage.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }
  Future<int> insertColoringImage(ColoringImage image) async {
    try {
      final db = await database;
      return await db.insert('coloring_images', image.toMap());
    } catch (e) {
      return -1;
    }
  }
  Future<void> batchInsertTraceDrawingImages(
    List<TraceDrawingImage> images,
  ) async {
    try {
      final db = await database;
      final batch = db.batch();
      for (var image in images) {
        batch.insert('trace_drawing_images', image.toMap());
      }
      await batch.commit(noResult: true);
    } catch (e) {
    }
  }
  Future<void> batchInsertShapeDrawingImages(
    List<ShapeDrawingImage> images,
  ) async {
    try {
      final db = await database;
      final batch = db.batch();
      for (var image in images) {
        batch.insert('shape_drawing_images', image.toMap());
      }
      await batch.commit(noResult: true);
    } catch (e) {
    }
  }
  Future<void> batchInsertColoringThemes(List<ColoringTheme> themes) async {
    try {
      final db = await database;
      final batch = db.batch();
      for (var theme in themes) {
        batch.insert('coloring_themes', theme.toMap());
      }
      await batch.commit(noResult: true);
    } catch (e) {
    }
  }
  Future<void> batchInsertColoringImages(List<ColoringImage> images) async {
    try {
      final db = await database;
      final batch = db.batch();
      for (var image in images) {
        batch.insert('coloring_images', image.toMap());
      }
      await batch.commit(noResult: true);
    } catch (e) {
    }
  }
  Future<List<DrawingHistory>> getDrawingHistory() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'drawing_history',
        orderBy: 'created_at DESC, id DESC',
      );
      return List.generate(maps.length, (i) {
        return DrawingHistory.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }
  Future<int> insertDrawingHistory(DrawingHistory history) async {
    try {
      final db = await database;
      return await db.insert('drawing_history', history.toMap());
    } catch (e) {
      return -1;
    }
  }
  Future<int> deleteDrawingHistory(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'drawing_history',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return 0;
    }
  }
}
