import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/model/settingObj.dart';
import 'package:geiger_edu/model/userObj.dart';
import 'package:geiger_edu/providers/boxes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

 Box<User> userBox = Boxes.getUsers();
 Box<Setting> settingBox = Boxes.getSettings();

class DB {
  //generate boxes


  static void init() async {
    //** Hive DB Setup **
    WidgetsFlutterBinding.ensureInitialized();
    //Initializes Hive with a valid directory in the app files
    await Hive.initFlutter();

    //Register adapters
    Hive.registerAdapter(UserAdapter());

    await Hive.deleteBoxFromDisk('users'); //TODO REMOVE IN PRODUCTION ENV
    await Hive.deleteBoxFromDisk('settings'); //TODO REMOVE IN PRODUCTION ENV

    bool exists = await Hive.boxExists('users');
    if(!exists){//if it doesnt exist
      await Hive.openBox<User>('users'); //user table
      createDefaultUser();
    }
  }

  static void createDefaultUser(){
    //add default user to box
    User defaultUser = new User(userName: 'Turan', userImagePath: 'assets/img/profile/default.png', userScore: 20);
    userBox.put("default", defaultUser);
  }

  static User? getDefaultUser(){
    return userBox.get("default");
  }

  static void editDefaultUser(String? userName, String? userImagePath, int? userScore){
    User? tempUser = getDefaultUser();

    if(tempUser!.userName != userName && null != userName)
      tempUser.userName = userName;

    if(tempUser.userImagePath != userImagePath && null != userImagePath)
      tempUser.userImagePath = userImagePath;

    if(tempUser.userScore != userScore && null != userScore)
      tempUser.userScore = userScore;

    //persist modified User object to database
    userBox.put("default", tempUser);
  }

  static void modifyUserScore(int score){
    User? tempUser = getDefaultUser();
    tempUser!.userScore += score;
    userBox.put("default", tempUser);
  }

  static void createDefaultSettings(){
    //add default settings to box
    Setting defaultSetting = new Setting(darkmode: false, showAlias: true, showScore: false);
    settingBox.put("settings", defaultSetting);
  }
}