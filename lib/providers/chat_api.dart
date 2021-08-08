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

class ChatAPI {
  static String host = "10.0.2.2";
  static int port = 3000;

  static String baseUri = "http://10.0.2.2:3000/geiger-edu-chat";

  String getChatServerAddress() {
    return host + ":" + port.toString() + "/geiger-edu-chat";
  }

  static Future<void> authenticateUser() async {
    var user = DB.getDefaultUser();

    if (user!.userId == 'default') {
      Uri request = Uri.parse(baseUri + "/users");

      final response = await http.post(request,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(user.toJson()));
      user.userId = json.decode(response.body);
      DB.getUserBox().put('default', user);
      // user.save();
    }
  }

  static Future<void> sendMessage(Comment comment) async {
    Uri request =
        Uri.parse(baseUri + "/rooms/" + comment.lessonId + "/messages");

    final response = await http.post(request,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(comment.toJson()));

    // print(response.body);

    if (response.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Comment c = Comment.fromJson(json.decode(response.body));
      comment.id = c.id;
      DB.addComment(comment);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to send message');
    }
  }

  static Future<String> sendImage(
      String imageFilePath, String currentLessonId) async {
    var imageFile = File(imageFilePath);

    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(baseUri + "/rooms/" + currentLessonId + "/images");

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

  static Future<Messages> fetchMessages(String roomId) async {
    // Uri request = Uri(host: host, port: port, path: "/geiger-edu-chat/rooms/" + roomId + "/messages");
    Uri request = Uri.parse(baseUri + "/rooms/" + roomId + "/messages");

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

  static Future<List<int>> fetchImage(String imageId) async {
    Uri request = Uri.parse(baseUri + "/images/" + imageId);

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

      if (!DB.getCommentBox().keys.contains(element.id)) DB.addComment(element);
    });
  }

  static Future<User> getForeignUserData(String requestedUserId) async {
    Uri request = Uri.parse(baseUri + "/users/" + requestedUserId);

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

  static void sendUpdatedUserData() async {
    User user = DB.getDefaultUser()!;

    Uri request = Uri.parse(baseUri + "/users/" + user.userId);

    var data = json.encode(user.toJson());
    print(data);
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

class Messages {
  final List<Comment> messages;

  Messages({required this.messages});

  factory Messages.fromJson(List<dynamic> json) {
    return Messages(messages: parseMessages(json));
  }

  static List<Comment> parseMessages(messagesJson) {
    var list = messagesJson as List;
    List<Comment> messagesList =
        list.map((data) => Comment.fromJson(data)).toList();
    return messagesList;
  }
}
