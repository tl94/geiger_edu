import 'package:geiger_edu/controller/chat_controller.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

/// This class handles all the business logic of the comments.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class CommentsController extends GetxController {
  var items = List.empty(growable: true).obs;
  RxBool hasComments = false.obs;
  final ChatController chatController = Get.find();

  /// This method gets all the comments (chat messages) from the db and puts
  /// them in a list.
  void getUserComments() {
    for (var comment in DB.getCommentBox().values) {
      if (comment.userId == DB.getDefaultUser()!.userId) {
        if (!items.contains(comment)) items.add(comment);
      }
    }
  }

  /// This method deletes a selected comment from the items list and requests
  /// deletion on the db and server.
  ///
  /// @param commentId The id a comment has.
  Future<void> deleteComment(String commentId) async {
    items.removeWhere((element) => element.id == commentId);
    chatController.deleteComment(commentId);
  }

  /// HELPER METHODS ///

  /// This method checks weather the user has any active messages.
  void checkHasComments() {
    getUserComments();
    hasComments(items.isNotEmpty);
  }

  /// This method shortens a string so it does not overflow.
  ///
  /// @param test String to be shortened.
  String getItemText(String text) {
    if (text.length > 90) {
      return text.substring(0, 90) + "...";
    }
    return text;
  }
}
