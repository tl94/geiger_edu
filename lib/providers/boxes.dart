import 'package:geiger_edu/model/commentObj.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/settingObj.dart';
import 'package:geiger_edu/model/xApis.dart';
import 'package:hive/hive.dart';
import 'package:geiger_edu/model/userObj.dart';

/// This class handles all HiveDB box logic.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class Boxes {
  /// This method gets the user box.
  static Box<User> getUsers() =>
      Hive.box<User>('users');

  /// This method gets the settings box.
  static Box<Setting> getSettings() =>
      Hive.box<Setting>('settings');

  /// This method gets the lessons box.
  static Box<Lesson> getLessons() =>
      Hive.box<Lesson>('lessons');

  /// This method gets the lessons categories box.
  static Box<LessonCategory> getLessonCategories() =>
      Hive.box<LessonCategory>('lessonCategories');

  /// This method gets the comments box.
  static Box<Comment> getComments() =>
      Hive.box<Comment>('comments');

  /// This method gets the xApis box.
  static Box<XApis> getxApis() =>
      Hive.box<XApis>('xapis');
}