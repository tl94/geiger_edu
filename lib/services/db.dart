import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/model/difficultyObj.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/settingObj.dart';
import 'package:geiger_edu/model/userObj.dart';
import 'package:geiger_edu/providers/boxes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geiger_edu/globals.dart' as globals;

class DB {
  static Box<User> userBox = Boxes.getUsers();
  static Box<Setting> settingBox = Boxes.getSettings();
  static Box<Lesson> lessonBox = Boxes.getLessons();
  static Box<LessonCategory> lessonCategoryBox = Boxes.getLessonCategories();

  static Future<void> init() async {
    //** Hive DB Setup **
    WidgetsFlutterBinding.ensureInitialized();
    //Initializes Hive with a valid directory in the app files
    await Hive.initFlutter();

    //Register adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(SettingAdapter());
    Hive.registerAdapter(LessonAdapter());
    Hive.registerAdapter(LessonCategoryAdapter());
    Hive.registerAdapter(DifficultyAdapter());

    bool usersIsOpen = Hive.isBoxOpen('users');
    bool settingsIsOpen = Hive.isBoxOpen('settings');
    bool lessonsIsOpen = Hive.isBoxOpen('lessons');
    bool lessonCategoriesIsOpen = Hive.isBoxOpen('lessonCategories');

    if(!usersIsOpen){
      await Hive.openBox<User>('users'); //user table
    }
    if (DB.getUserBox().keys.isEmpty){ //if it doesnt exist
      createDefaultUser();
    }

    if(!settingsIsOpen){ await Hive.openBox<Setting>('settings'); }
    if(DB.getSettingBox().keys.isEmpty){ createDefaultSettings(); }

    if(!lessonCategoriesIsOpen){ await Hive.openBox<LessonCategory>('lessonCategories'); }
    // if(DB.getLessonCategoryBox().keys.isEmpty)
  print("LESSON CATEGORIES OPEN");

    if(!lessonsIsOpen) { await Hive.openBox<Lesson>('lessons'); }
    // if (getLessonBox().isEmpty) { createTestLessons(); }

    runGeigerIndicator();
  }

  static void runGeigerIndicator(){
    var tempCompletedLessons = 0;
    var tempMaxLessons = getLessonBox().values.length;

    for(var lesson in getLessonBox().values){
      if (lesson.completed) {
        tempCompletedLessons++;
      }
    }

    globals.maxLessons = tempMaxLessons;
    globals.completedLessons = tempCompletedLessons;
  }

  static void incrementGeigerIndicator(){
    globals.completedLessons++;
  }

  static void updateLessonBox(){
    //TODO: validate lesson box on start check files for new lessons add them tho the lesson category
  }

  static void createTestLessons(){
    //TODO: replace with updateLessonBox

    Lesson l1 = new Lesson(lessonId: "LPW001", lessonCategoryId: "CID001", title: {
      "eng": "Password Safety",
      "ger": "Passwortsicherheit"
    }, completed: true,recommended: false,lastIndex: 0,maxIndex: 6, motivation: {
      "eng": "Improve your password security!",
      "ger": "Verbessere deine Passwortsicherheit!"
    }, difficulty: Difficulty.beginner, duration: 5, apiUrl: '', path: '', hasQuiz: true);
    Lesson l2 = new Lesson(lessonId: "LPW002", lessonCategoryId: "CID001", title: {
      "eng": "Password Safety",
      "ger": "Passwortsicherheit"
    }, completed: false,recommended: false,lastIndex: 5,maxIndex: 8, motivation: {
      "eng": "Improve your password security!",
      "ger": "Verbessere deine Passwortsicherheit!"
    }, difficulty: Difficulty.advanced, duration: 8, apiUrl: '', path: '', hasQuiz: false);
    Lesson l3 = new Lesson(lessonId: "LPW003", lessonCategoryId: "CID001", title: {
      "eng": "Password Safety",
      "ger": "Passwortsicherheit"
    }, completed: false,recommended: false,lastIndex: 2,maxIndex: 4, motivation: {
      "eng": "Improve your password security!",
      "ger": "Verbessere deine Passwortsicherheit!"
    }, difficulty: Difficulty.master, duration: 10, apiUrl: '', path: '', hasQuiz: false);
    List<Lesson> l = [l1,l2,l3];

    for (var lesson in l) {
      DB.getLessonBox().put(lesson.lessonId, lesson);
    }

    LessonCategory c1 = new LessonCategory(lessonCategoryId: "CID001", title: {
      "eng":"Passwords",
      "ger":"Passwörter"
    }, path: "assets/lesson/password", );
    getLessonCategoryBox().put(c1.lessonCategoryId,c1);

    Lesson k1 = new Lesson(lessonId: "LMW001", lessonCategoryId: "CID002", title: {
      "eng": "Password Safety",
      "ger": "Passwortsicherheit"
    }, completed: true,recommended: false,lastIndex: 0,maxIndex: 6, motivation: {
      "eng": "Improve your password security!",
      "ger": "Verbessere deine Passwortsicherheit!"
    }, difficulty: Difficulty.beginner, duration: 5, apiUrl: '', path: '', hasQuiz: true);
    Lesson k2 = new Lesson(lessonId: "LMW002", lessonCategoryId: "CID002", title: {
      "eng": "Password Safety",
      "ger": "Passwortsicherheit"
    }, completed: false,recommended: false,lastIndex: 5,maxIndex: 8, motivation: {
      "eng": "Improve your password security!",
      "ger": "Verbessere deine Passwortsicherheit!"
    }, difficulty: Difficulty.advanced, duration: 8, apiUrl: '', path: '', hasQuiz: false);
    Lesson k3 = new Lesson(lessonId: "LMW003", lessonCategoryId: "CID002", title: {
      "eng": "Password Safety",
      "ger": "Passwortsicherheit"
    }, completed: false,recommended: false,lastIndex: 2,maxIndex: 4, motivation: {
      "eng": "Improve your password security!",
      "ger": "Verbessere deine Passwortsicherheit!"
    }, difficulty: Difficulty.master, duration: 10, apiUrl: '', path: '', hasQuiz: false);
    List<Lesson> k = [k1,k2,k3];

    for (var lesson in k) {
      DB.getLessonBox().put(lesson.lessonId, lesson);
    }

    LessonCategory c2 = new LessonCategory(lessonCategoryId: "CID002", title:{
      "eng":"Malware",
      "ger":"Malware"
    }, path: "assets/lesson/password");
    getLessonCategoryBox().put(c2.lessonCategoryId,c2);
  }

  static Box<LessonCategory> getLessonCategoryBox(){ return lessonCategoryBox; }

  static Box<Lesson> getLessonBox() { return lessonBox; }


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

  static void editDefaultSetting(bool? darkmode, bool? showAlias, bool? showScore, String? language){
    Setting? tempSetting = getDefaultSetting();

    if(tempSetting!.darkmode != darkmode && null != darkmode)
      tempSetting.darkmode = darkmode;

    if(tempSetting.showAlias != showAlias && null != showAlias)
      tempSetting.showAlias = showAlias;

    if(tempSetting.showScore != showScore && null != showScore)
      tempSetting.showScore = showScore;

    if(tempSetting.language != language && null != language) {
      tempSetting.language = language;
    }

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
    Setting defaultSetting = new Setting(darkmode: false, showAlias: true, showScore: false, language: 'ger');
    settingBox.put("default", defaultSetting);
  }

  static Setting? getDefaultSetting(){
    return settingBox.get("default");
  }

  static Box<Setting> getSettingBox() {return settingBox;}


  static void wipeDB() async{
    //delete the hive-boxes, clears the file content from the device
    await Hive.deleteBoxFromDisk('users');
    await Hive.deleteBoxFromDisk('settings');
    await Hive.deleteBoxFromDisk('lessons');
    await Hive.deleteBoxFromDisk('lessonCategories');
    // await Hive.deleteBoxFromDisk('xapis');
  }
}