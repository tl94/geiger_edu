import 'package:geiger_edu/model/difficultyLevelObj.dart';
import 'package:hive/hive.dart';

part 'lessonObj.g.dart';

@HiveType(typeId: 3)
class Lesson {

  @HiveField(0)
  String lessonId;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool recommended;

  @HiveField(3)
  String motivation;

  @HiveField(4)
  int duration;

  @HiveField(5)
  Difficulty difficulty;

  @HiveField(6)
  int lastIndex = 0;

  @HiveField(7)
  int maxIndex;

  @HiveField(8)
  bool hasQuiz;

  @HiveField(9)
  bool completed;

  @HiveField(10)
  String path;

  @HiveField(11)
  String apiUrl;


  Lesson({
    required this.lessonId,         //unique id of the lesson
    required this.name,             //name of the lesson
    this.recommended = false,       //lesson is recommended to the user
    required this.motivation,       //motivation for the lesson
    required this.duration,  //length of lesson in minutes
    required this.difficulty,  //difficulty level of lesson
    required this.lastIndex,        //last index a user was on in this lesson
    required this.maxIndex,         //max index of the whole lesson
    required this.hasQuiz,          //whether lesson has a quiz or not
    required this.completed,        //lesson is completed
    required this.path,             //path to physical files
    required this.apiUrl,           //URL provided by the geiger toolbox
  });
}