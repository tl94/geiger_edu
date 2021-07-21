import 'package:hive/hive.dart';

import 'lessonObj.dart';

part 'lessonCategoryObj.g.dart';

@HiveType(typeId: 4)
class LessonCategory {

  @HiveField(0)
  String name;

  @HiveField(1)
  List<Lesson> lessonList;

  LessonCategory({
    required this.name,       //unique name of the lesson
    required this.lessonList,  //lesson is completed
  });
}