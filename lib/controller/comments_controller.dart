import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CommentsController extends GetxController {
  var items = List<String>.generate(20, (i) => "ChatItem ${i + 1}").obs;
  //get items => this._items;
}
