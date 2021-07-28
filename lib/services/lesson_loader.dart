import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/globals.dart' as globals;
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/model/difficultyObj.dart';
import 'package:geiger_edu/controller/io_controller.dart';
import 'package:get/get.dart';

class LessonLoader {

  static LessonController lessonController = Get.find();



  static void test() async {
    String filename = "lesson_category_meta.json";
    String s = "sfsefefef/fniebqiueifuqi/lesson_category_meta.json";
    RegExp regExp = RegExp(r'.*lesson_category_meta.json');
    RegExp regExp2 = RegExp(r'.*' + filename);
    print(regExp.hasMatch(s));
    print(regExp2.hasMatch(s));
  }
}
