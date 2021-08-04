import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CommentsController extends GetxController {
  var items = DB.getCommentBox().values.toList(growable: true).obs;
  RxBool hasComments = DB.getCommentBox().isEmpty.obs;


  void deleteComment(String id) {
    DB.deleteComment(id);
  }

  void checkHasComments(){
    hasComments(DB.getCommentBox().isEmpty);
  }

  String getItemText(String text) {
    if (text.length > 90) {
      return text.substring(0, 90) + "...";
    }
    return text;
  }
}
