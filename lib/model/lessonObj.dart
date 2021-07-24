import 'package:geiger_edu/model/difficultyLevelObj.dart';
import 'package:hive/hive.dart';

part 'lessonObj.g.dart';

@HiveType(typeId: 3)
class Lesson {

  @HiveField(0)
  String lessonId;

  @HiveField(1)
  String lessonCategoryId;

  @HiveField(2)
  Map<String, String> title;

  @HiveField(3)
  bool recommended;

  @HiveField(4)
  Map<String, String> motivation;

  @HiveField(5)
  int duration;

  @HiveField(6)
  Difficulty difficulty;

  @HiveField(7)
  int lastIndex = 0;

  @HiveField(8)
  int maxIndex;

  @HiveField(9)
  bool hasQuiz;

  @HiveField(10)
  bool completed;

  @HiveField(11)
  String path;

  @HiveField(12)
  String apiUrl;


  Lesson({
    required this.lessonId,         //unique id of the lesson
    required this.lessonCategoryId, //id of lesson category this lesson belongs to
    required this.title,            //map with lesson titles for all supported languages
    this.recommended = false,       //lesson is recommended to the user
    required this.motivation,       //map with motivation for the lesson in all supported languages
    required this.duration,         //length of lesson in minutes
    required this.difficulty,       //difficulty level of lesson
    required this.lastIndex,        //last index a user was on in this lesson
    required this.maxIndex,         //max index of the whole lesson
    required this.hasQuiz,          //whether lesson has a quiz or not
    required this.completed,        //lesson is completed
    required this.path,             //path to physical location of lesson directory
    required this.apiUrl,           //URL provided by the geiger toolbox
  });
}