import 'package:hive/hive.dart';
import 'lessonObj.dart';

part 'userObj.g.dart';

/// This class models a user object.
///
/// @author Felix Mayer
/// @author Turan Ledermann

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String userName;

  @HiveField(1)
  String userImagePath;

  @HiveField(2)
  int userScore;

  @HiveField(3)
  String userId;

  @HiveField(4)
  bool showAlias;

  @HiveField(5)
  bool showScore;

  @HiveField(6)
  Lesson? currentLesson;

  /// User object constructor.
  User(
      {required this.userName,
      required this.userImagePath,
      this.userScore = 0,
      this.userId = "default",
      this.showAlias = false,
      this.showScore = true,
      this.currentLesson});

  /// This method maps values to the object from a json.
  factory User.fromJson(Map<String, dynamic> json) => User(
        userName: json["name"],
        userImagePath: json["profileImage"],
        userScore: json["learnScore"],
    showAlias: json["isAnonymous"],
    showScore: json["showLearnScore"],
      );

  /// This method maps values of an object to a json.
  Map<String, dynamic> toJson() => {
        'name': userName,
        'profileImage': userImagePath,
        'learnScore': userScore,
        'isAnonymous': showAlias,
        'showLearnScore': showScore
      };
}
