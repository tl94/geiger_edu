import 'package:hive/hive.dart';

import 'lessonObj.dart';

part 'lessonCategoryObj.g.dart';

@HiveType(typeId: 4)
class LessonCategory {

  @HiveField(0)
  String id;

  @HiveField(1)
  Map<String, String> title;

  @HiveField(2)
  String path;

  LessonCategory({
    required this.id,       //unique id of the lesson category
    required this.title,    //map with lesson category titles for all supported languages
    required this.path,     //path to physical location of lesson category directory
  });
}