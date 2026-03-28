class TraceDrawingImage {
  final int? id;
  final String imagePath;
  final int displayOrder;
  const TraceDrawingImage({
    this.id,
    required this.imagePath,
    required this.displayOrder,
  });
  factory TraceDrawingImage.fromMap(Map<String, dynamic> map) {
    return TraceDrawingImage(
      id: map['id'] as int?,
      imagePath: map['image_path'] as String,
      displayOrder: map['display_order'] as int,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'image_path': imagePath,
      'display_order': displayOrder,
    };
  }
}
class ShapeDrawingImage {
  final int? id;
  final String imagePath;
  final String shapeName;
  final int displayOrder;
  const ShapeDrawingImage({
    this.id,
    required this.imagePath,
    required this.shapeName,
    required this.displayOrder,
  });
  factory ShapeDrawingImage.fromMap(Map<String, dynamic> map) {
    return ShapeDrawingImage(
      id: map['id'] as int?,
      imagePath: map['image_path'] as String,
      shapeName: map['shape_name'] as String,
      displayOrder: map['display_order'] as int,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'image_path': imagePath,
      'shape_name': shapeName,
      'display_order': displayOrder,
    };
  }
}
class ColoringTheme {
  final int? id;
  final String themeName;
  final String themeNameEn;
  final String thumbnailPath;
  final String displayType;
  final int displayOrder;
  const ColoringTheme({
    this.id,
    required this.themeName,
    required this.themeNameEn,
    required this.thumbnailPath,
    required this.displayType,
    required this.displayOrder,
  });
  factory ColoringTheme.fromMap(Map<String, dynamic> map) {
    return ColoringTheme(
      id: map['id'] as int?,
      themeName: map['theme_name'] as String,
      themeNameEn: map['theme_name_en'] as String,
      thumbnailPath: map['thumbnail_path'] as String,
      displayType: map['display_type'] as String,
      displayOrder: map['display_order'] as int,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'theme_name': themeName,
      'theme_name_en': themeNameEn,
      'thumbnail_path': thumbnailPath,
      'display_type': displayType,
      'display_order': displayOrder,
    };
  }
}
class ColoringImage {
  final int? id;
  final int themeId;
  final String imagePath;
  final int displayOrder;
  const ColoringImage({
    this.id,
    required this.themeId,
    required this.imagePath,
    required this.displayOrder,
  });
  factory ColoringImage.fromMap(Map<String, dynamic> map) {
    return ColoringImage(
      id: map['id'] as int?,
      themeId: map['theme_id'] as int,
      imagePath: map['image_path'] as String,
      displayOrder: map['display_order'] as int,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'theme_id': themeId,
      'image_path': imagePath,
      'display_order': displayOrder,
    };
  }
}
class DrawingHistory {
  final int? id;
  final String imagePath;
  final String drawingType;
  final String createdAt;
  const DrawingHistory({
    this.id,
    required this.imagePath,
    required this.drawingType,
    required this.createdAt,
  });
  factory DrawingHistory.fromMap(Map<String, dynamic> map) {
    return DrawingHistory(
      id: map['id'] as int?,
      imagePath: map['image_path'] as String,
      drawingType: map['drawing_type'] as String,
      createdAt: map['created_at'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'image_path': imagePath,
      'drawing_type': drawingType,
      'created_at': createdAt,
    };
  }
}
