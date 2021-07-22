import 'package:geiger_edu/model/difficultyLevelObj.dart';
import 'package:hive/hive.dart';

part 'lessonObj.g.dart';

@HiveType(typeId: 3)
class Lesson {

  @HiveField(0)
  String name;

  @HiveField(1)
  bool recommended;

  @HiveField(2)
  String motivation;

  @HiveField(3)
  int lengthInMinutes;

  @HiveField(4)
  DifficultyLevel difficultyLevel;

  @HiveField(5)
  int lastIndex = 0;

  @HiveField(6)
  int maxIndex;

  @HiveField(7)
  bool completed;

  @HiveField(8)
  String path;

  @HiveField(9)
  String apiUrl;



  Lesson({
    required this.name,             //unique name of the lesson
    this.recommended = false,       //lesson is recommended to the user
    required this.motivation,       //motivation for the lesson
    required this.lengthInMinutes,  //length of lesson in minutes
    required this.difficultyLevel,  //difficulty level of lesson
    required this.lastIndex,        //last index a user was on in this lesson
    required this.maxIndex,         //max index of the whole lesson
    required this.completed,        //lesson is completed
    required this.path,             //path to physical files
    required this.apiUrl,           //URL provided by the geiger toolbox
  });
}