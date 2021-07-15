import 'dart:convert';
import 'package:hive/hive.dart';

part 'userObj.g.dart';

User userFromJson(String str)=> User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

@HiveType(typeId: 0)
class User extends HiveObject{
  @HiveField(0)
  String userName;

  @HiveField(1)
  String userImagePath;

  @HiveField(2)
  int userScore;

  User({
    required this.userName,
    required this.userImagePath,
    this.userScore = 0
  });

  //not used
  factory User.fromJson(Map<String, dynamic> json)=> User(
    userName: json["username"],
    userImagePath: json["image"],
    userScore: json["score"],
  );

  //not used
  Map<String, dynamic> toJson() => {
      'username': userName,
      'image': userImagePath,
      'score': userScore
    };
}