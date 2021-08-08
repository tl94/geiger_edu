import 'package:geiger_edu/providers/chat_api.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CommentsController extends GetxController {
  var items = List.empty(growable: true).obs;
  RxBool hasComments = false.obs;

  void getUserComments() {
    for (var comment in DB.getCommentBox().values) {
      if (comment.userId == DB.getDefaultUser()!.userId) {
        if (!items.contains(comment)) items.add(comment);
        // print(comment.text);
        // print("comment.userId: " + comment.userId + " DB.getDefaultUser()!.userId: " + DB.getDefaultUser()!.userId);
      }
    }
    print("PRINTING ITEMS");
    for (var comment in items) {
      print(comment.text);
    }
  }

  void deleteComment(String id) {
    items.removeWhere((element) => element.id == id);
    DB.deleteComment(id);
    ChatAPI.deleteMessage(id);
  }

  void checkHasComments() {
    getUserComments();
    hasComments(items.isNotEmpty);
  }

  String getItemText(String text) {
    if (text.length > 90) {
      return text.substring(0, 90) + "...";
    }
    return text;
  }
}
