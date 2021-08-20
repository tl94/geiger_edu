import 'package:hive/hive.dart';

part 'lessonCategoryObj.g.dart';

/// This class models a lessonCategory object.
///
/// @author Felix Mayer
/// @author Turan Ledermann

@HiveType(typeId: 4)
class LessonCategory {

  @HiveField(0)
  String lessonCategoryId;

  @HiveField(1)
  Map<String, String> title;

  @HiveField(2)
  String path;

  /// LessonCategory constructor.
  LessonCategory({
    required this.lessonCategoryId,       //unique id of the lesson category
    required this.title,    //map with lesson category titles for all supported languages
    required this.path,     //path to physical location of lesson category directory
  });

}