import 'dart:convert';

import 'package:geiger_edu/services/db.dart';
import 'package:hive/hive.dart';

part 'userObj.g.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

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

  User(
      {required this.userName,
      required this.userImagePath,
      this.userScore = 0,
      this.userId = "default",
      this.showAlias = true,
      this.showScore = true});

  //not used
  factory User.fromJson(Map<String, dynamic> json) => User(
        userName: json["username"],
        userImagePath: json["profileImage"],
        userScore: json["learnScore"],
    showAlias: json["isAnonymous"],
    showScore: json["showLearnScore"],
      );

  //not used
  Map<String, dynamic> toJson() => {
        'name': userName,
        'profileImage': userImagePath,
        'learnScore': userScore,
        'isAnonymous': showAlias,
        'showLearnScore': showScore
      };
}
