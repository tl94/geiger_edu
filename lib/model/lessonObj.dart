import 'package:hive/hive.dart';

part 'lessonObj.g.dart';

@HiveType(typeId: 3)
class Lesson {

  @HiveField(0)
  String name;

  @HiveField(1)
  bool completed;

  @HiveField(2)
  bool? recommended = false;

  @HiveField(3)
  String? apiUrl;

  @HiveField(4)
  int lastIndex = 0;

  @HiveField(5)
  int maxIndex;

  Lesson({
    required this.name,       //unique name of the lesson
    required this.completed,  //lesson is completed
    this.recommended,         //lesson is recommended to the user
    this.apiUrl,              //URL Provided by the geiger toolbox
    required this.lastIndex,  //last index a user was on in this lesson
    required this.maxIndex    //max index of the whole lesson
  });
}