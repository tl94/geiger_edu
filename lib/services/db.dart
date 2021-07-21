import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/settingObj.dart';
import 'package:geiger_edu/model/userObj.dart';
import 'package:geiger_edu/providers/boxes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DB {
  static Box<User> userBox = Boxes.getUsers();
  static Box<Setting> settingBox = Boxes.getSettings();
  static Box<LessonCategory> lessonCategoryBox = Boxes.getLessonCategories();

  static void init() async {
    //** Hive DB Setup **
    WidgetsFlutterBinding.ensureInitialized();
    //Initializes Hive with a valid directory in the app files
    await Hive.initFlutter();

    //Register adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(SettingAdapter());
    Hive.registerAdapter(LessonAdapter());
    Hive.registerAdapter(LessonCategoryAdapter());

    bool usersIsOpen = Hive.isBoxOpen('users');
    bool settingsIsOpen = Hive.isBoxOpen('settings');
    bool lessonIsOpen = Hive.isBoxOpen('lessonCategories');

    if(!usersIsOpen){
      await Hive.openBox<User>('users'); //user table
    }
    if(DB.getUserBox().keys.isEmpty){ //if it doesnt exist
      createDefaultUser();
    }

    if(!settingsIsOpen){ await Hive.openBox<Setting>('settings'); }
    if(DB.getSettingBox().keys.isEmpty){ createDefaultSettings(); }

    if(!lessonIsOpen){ await Hive.openBox<LessonCategory>('lessonCategories'); }
    if(DB.getLessonCategoryBox().keys.isEmpty){ createTestLessons(); }

    print(":: "+DB.lessonCategoryBox.keys.length.toString());
  }

  static void updateLessonBox(){
    //TODO: validate lesson box on start check files for new lessons add them tho the lesson category
  }

  static void createTestLessons(){
    //TODO: replace with updateLessonBox

    Lesson l1 = new Lesson(name: "L1", completed: true,recommended: false,lastIndex: 0,maxIndex: 8);
    Lesson l2 = new Lesson(name: "L2", completed: false,recommended: false,lastIndex: 4,maxIndex: 8);
    Lesson l3 = new Lesson(name: "L3", completed: true,recommended: false,lastIndex: 4,maxIndex: 8);
    List<Lesson> l = [l1,l2,l3];
    LessonCategory c1 = new LessonCategory(name: "Passwords", lessonList: l);
    getLessonCategoryBox().put(c1.name,c1);

    Lesson k1 = new Lesson(name: "k1", completed: false,recommended: false,lastIndex: 0,maxIndex: 8);
    Lesson k2 = new Lesson(name: "k2", completed: false,recommended: false,lastIndex: 4,maxIndex: 8);
    Lesson k3 = new Lesson(name: "k3", completed: false,recommended: false,lastIndex: 4,maxIndex: 8);
    List<Lesson> k = [k1,k2,k3];

    LessonCategory c2 = new LessonCategory(name: "Malware", lessonList: k);
    getLessonCategoryBox().put(c2.name,c2);
  }

  static Box<LessonCategory> getLessonCategoryBox(){ return lessonCategoryBox; }

  static void wipeDB() async{
    //delete the hive-boxes, clears the file content from the device
    await Hive.deleteBoxFromDisk('users');
    await Hive.deleteBoxFromDisk('settings');
    await Hive.deleteBoxFromDisk('lessonCategories');
  }

  static void createDefaultUser(){
    //add default user to box
    User defaultUser = new User(userName: 'Daniel', userImagePath: 'assets/img/profile/default.png', userScore: 100);
    userBox.put("default", defaultUser);
  }

  static User? getDefaultUser(){
    return userBox.get("default");
  }

  static Box<User> getUserBox(){ return userBox; }

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

  static void editDefaultSetting(bool? darkmode, bool? showAlias, bool? showScore){
    Setting? tempSetting = getDefaultSetting();

    if(tempSetting!.darkmode != darkmode && null != darkmode)
      tempSetting.darkmode = darkmode;

    if(tempSetting.showAlias != showAlias && null != showAlias)
      tempSetting.showAlias = showAlias;

    if(tempSetting.showScore != showScore && null != showScore)
      tempSetting.showScore = showScore;

    //persist modified Settings object to database
    settingBox.put("default", tempSetting);
  }

  static void modifyUserScore(int score){
    User? tempUser = getDefaultUser();
    tempUser!.userScore += score;
    userBox.put("default", tempUser);
  }

  static void createDefaultSettings(){
    //add default settings to box
    Setting defaultSetting = new Setting(darkmode: false, showAlias: true, showScore: false);
    settingBox.put("default", defaultSetting);
  }

  static Setting? getDefaultSetting(){
    return settingBox.get("default");
  }

  static Box<Setting> getSettingBox() {return settingBox;}
}