import 'dart:ui';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CommentsController extends GetxController {
  //var items = List<String>.generate(20, (i) => "CHATMOCK ${i + 1}").obs;
  //get items => this._items;
  var items = DB.getCommentBox().values.toList(growable: true).obs;

  void deleteComment(String id, int index){
    items.removeAt(index);
    DB.deleteComment(id);
  }
}
