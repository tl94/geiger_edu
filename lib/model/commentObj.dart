import 'package:hive/hive.dart';

part 'commentObj.g.dart';

/// This class models a comment object.
///
/// @author Felix Mayer
/// @author Turan Ledermann

@HiveType(typeId: 6)
class Comment extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String text;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  String? parentMsgId;

  @HiveField(4)
  List<String>? childMsgIds;

  @HiveField(5)
  String lessonId;

  // userid given by the server
  @HiveField(6)
  String userId;

  // image id on mongoDB
  @HiveField(7)
  String? imageId;

  // local image file path
  @HiveField(8)
  String? imageFilePath;

  /// Comment constructor.
  Comment(
      {required this.id,
      required this.text,
      required this.dateTime,
      this.parentMsgId,
      this.childMsgIds,
      required this.lessonId,
      required this.userId,
      this.imageId,
      this.imageFilePath});

  /// This method maps values to the object from a json.
  factory Comment.fromJson(Map<String, dynamic> parsedJson) {
    var roomId = parsedJson['roomId'];
    var dateTime = parsedJson['timestamp'];
    return Comment(
        id: parsedJson['id'],
        text: parsedJson['message'],
        parentMsgId: parsedJson['parentMsg'],
        childMsgIds: parsedJson['childMsgs'],
        dateTime: DateTime.parse(dateTime),
        lessonId: roomId,
        userId: parsedJson['userId'],
    imageId: parsedJson['imageId']);
  }

  /// This method maps values of an object to a json.
  Map<String, dynamic> toJson() => {
    'roomId': lessonId,
    'userId': userId,
    'parentMsg': parentMsgId,
    'childMsgs': childMsgIds,
    'message': text,
    'timestamp': dateTime.toString(),
    'imageId': imageId
  };
}
