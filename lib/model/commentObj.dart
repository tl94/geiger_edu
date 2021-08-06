import 'package:hive/hive.dart';

part 'commentObj.g.dart';

@HiveType(typeId: 6)
class Comment extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String text;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  bool reply;

  @HiveField(4)
  String lessonId;

  //userid given by the server
  @HiveField(5)
  String userId;

  Comment({
    required this.id,
    required this.text,
    required this.dateTime,
    this.reply = false,
    required this.lessonId,
    required this.userId,
  });

}
