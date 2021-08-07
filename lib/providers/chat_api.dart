import 'dart:convert';

import 'package:geiger_edu/model/commentObj.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:http/http.dart' as http;

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
      Uri request =
      Uri.parse(baseUri + "/users");

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

    print(json.encode(comment.toJson()));
    // print(response.body);

    if (response.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(json.decode(response.body));
      Comment c = Comment.fromJson(json.decode(response.body));
      comment.id = c.id;
      DB.addComment(comment);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to send message');
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

  static void saveMessagesToDB(Future<Messages> messages) async {
    var msgs = await messages;
    msgs.messages.forEach((element) {
      if (!DB.getCommentBox().keys.contains(element.id)) DB.addComment(element);
    });
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
