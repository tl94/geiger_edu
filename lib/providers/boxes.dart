import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/settingObj.dart';
import 'package:geiger_edu/model/xApis.dart';
import 'package:hive/hive.dart';
import 'package:geiger_edu/model/userObj.dart';

class Boxes {
  static Box<User> getUsers() =>
      Hive.box<User>('users');

  static Box<Setting> getSettings() =>
      Hive.box<Setting>('settings');

  static Box<XApis> getxApis() =>
      Hive.box<XApis>('xapis');

  static Box<List<Lesson>> getLessons() =>
      Hive.box<List<Lesson>>('lessons');
}
