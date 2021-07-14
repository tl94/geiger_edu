import 'package:hive/hive.dart';
import 'package:geiger_edu/model/userObj.dart';

class Boxes { //local db "tables"
  static Box<User> getUsers() =>
      Hive.box<User>('users');
}