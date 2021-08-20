import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:geiger_edu/model/commentObj.dart';
import 'package:geiger_edu/model/userObj.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

/// This class handles all communication with the communications server.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class ChatAPI {

  static String serverIp = "86.119.42.103";
  static int port = 3000;
  static String serviceAddress = "http://" + serverIp + ":" + port.toString() + "/geiger-edu-chat";

  /// This method authenticates the user on the server.
  static Future<void> authenticateUser() async {
    var user = DB.getDefaultUser();

    if (user!.userId == 'default') {
      Uri request = Uri.parse(serviceAddress + "/users");

      final response = await http.post(request,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(user.toJson()));
      user.userId = json.decode(response.body);
      DB.getUserBox().put('default', user);
    }
  }

  /// This method sends a comment to the server.
  ///
  /// @param comment The comment object that is to be sent.
  static Future<void> sendMessage(Comment comment) async {
    Uri request =
        Uri.parse(serviceAddress + "/rooms/" + comment.lessonId + "/messages");

    final response = await http.post(request,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(comment.toJson()));

    if (response.statusCode == 201) {
      // If the server did return a 201 OK response,
      // then parse the JSON.
      Comment c = Comment.fromJson(json.decode(response.body));
      comment.id = c.id;
      DB.addComment(comment);
    } else {
      // If the server did not return a 201 OK response,
      // then throw an exception.
      throw Exception('Failed to send message');
    }
  }

  /// This method sends the selected image to the server.
  static Future<String> sendImage(
      String imageFilePath, String currentLessonId) async {
    var imageFile = File(imageFilePath);

    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(serviceAddress + "/rooms/" + currentLessonId + "/images");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    var basename = imageFile.path.split('/').last;

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename, contentType: MediaType('multipart', 'form-data'));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();

    if (response.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final completer = Completer<String>();
      final contents = StringBuffer();
      response.stream.transform(utf8.decoder).listen((data) {
        contents.write(data);
      }, onDone: () => completer.complete(contents.toString()));
      return completer.future;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to send image');
    }
  }

  /// This method obtains all the comments from the server.
  ///
  /// @param roomId The id of the selected chatroom.
  static Future<Messages> fetchMessages(String roomId) async {
    // Uri request = Uri(host: host, port: port, path: "/geiger-edu-chat/rooms/" + roomId + "/messages");
    Uri request = Uri.parse(serviceAddress + "/rooms/" + roomId + "/messages");

    final response = await http.get(request);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Messages messages = Messages.fromJson(json.decode(response.body));

      return messages;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load messages');
    }
  }

  /// This method obtains all the comments of a specific user from the server.
  ///
  /// @param userId The id of the user
  static Future<Messages> fetchUserMessages(String userId) async {
    // Uri request = Uri(host: host, port: port, path: "/geiger-edu-chat/rooms/" + roomId + "/messages");
    Uri request = Uri.parse(serviceAddress + "/users/" + userId + "/messages");

    final response = await http.get(request);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Messages messages = Messages.fromJson(json.decode(response.body));

      return messages;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load messages');
    }
  }

  /// This method obtains an image from the server.
  ///
  /// @param imageId The id of the image
  static Future<List<int>> fetchImage(String imageId) async {
    Uri request = Uri.parse(serviceAddress + "/images/" + imageId);

    final response = await http.get(request);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body);
      List<int> bytes = data['img']['data']['data'].cast<int>();
      return bytes;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load image');
    }
  }

  /// This method saves all the comments to the database.
  ///
  /// @param messages Messages to be saved
  static void saveMessagesToDB(Future<Messages> messages) async {
    var msgs = await messages;

    msgs.messages.forEach((element) async {
      if (element.imageId != null && element.imageId != '') {
        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String appDocumentsPath = appDocumentsDirectory.path;
        String filePath = '$appDocumentsPath/' + element.imageId! + '.png';
        File imageFile = File(filePath);
        if (!imageFile.existsSync()) {
          List<int> imageBytes = await fetchImage(element.imageId!);
          imageFile = await imageFile.writeAsBytes(imageBytes);
          element.imageFilePath = imageFile.path;
        }
      }
      // if the db doesn't contain the element then persist it to the db
      if (!DB.getCommentBox().keys.contains(element.id)) DB.addComment(element);
    });
  }

  /// This method deletes a comment from the server.
  ///
  /// @param commentId The id of the comment to be deleted
  static void deleteMessage(String commentId) async {
    Uri request = Uri.parse(serviceAddress + "/messages/" + commentId);
    final response = await http.delete(request);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete message');
    }
  }

  /// This method gets the user data of a requested user from the server.
  ///
  /// @param requestedUserId The id of the user to be requested
  static Future<User> getForeignUserData(String requestedUserId) async {
    Uri request = Uri.parse(serviceAddress + "/users/" + requestedUserId);
    final response = await http.get(request);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      User user = User.fromJson(json.decode(response.body));
      return user;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  /// This method updates the user data on the server.
  static void sendUpdatedUserData() async {
    await authenticateUser();

    User user = DB.getDefaultUser()!;

    Uri request = Uri.parse(serviceAddress + "/users/" + user.userId);

    var data = json.encode(user.toJson());
    final response = await http.put(request,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update user');
    }
  }
}

/// This class  all HiveDB box logic.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class Messages {
  final List<Comment> messages;

  /// Messages constructor.
  Messages({required this.messages});

  /// This method generates a new messages object with parsed json data.
  factory Messages.fromJson(List<dynamic> json) {
    return Messages(messages: parseMessages(json));
  }

  /// This method parses a list of comments from json data.
  static List<Comment> parseMessages(messagesJson) {
    var list = messagesJson as List;
    List<Comment> messagesList =
        list.map((data) => Comment.fromJson(data)).toList();
    return messagesList;
  }
}