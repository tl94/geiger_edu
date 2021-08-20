import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/model/commentObj.dart';
import 'package:geiger_edu/model/difficultyObj.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/settingObj.dart';
import 'package:geiger_edu/model/userObj.dart';
import 'package:geiger_edu/providers/boxes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// This class handles the main database interactions.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class DB {
  static Box<User> userBox = Boxes.getUsers();
  static Box<Setting> settingBox = Boxes.getSettings();
  static Box<Lesson> lessonBox = Boxes.getLessons();
  static Box<LessonCategory> lessonCategoryBox = Boxes.getLessonCategories();
  static Box<Comment> commentBox = Boxes.getComments();

  /// Initialisation method.
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
    Hive.registerAdapter(CommentAdapter());

    bool usersIsOpen = Hive.isBoxOpen('users');
    bool settingsIsOpen = Hive.isBoxOpen('settings');
    bool lessonsIsOpen = Hive.isBoxOpen('lessons');
    bool commentsIsOpen = Hive.isBoxOpen('comments');
    bool lessonCategoriesIsOpen = Hive.isBoxOpen('lessonCategories');

    if (!usersIsOpen) {
      await Hive.openBox<User>('users'); //user table
    }
    if (DB.getUserBox().keys.isEmpty) {
      //if it doesnt exist
      createDefaultUser();
    }

    if (!settingsIsOpen) {
      await Hive.openBox<Setting>('settings');
    }
    if (DB.getSettingBox().keys.isEmpty) {
      createDefaultSettings();
    }

    if (!lessonCategoriesIsOpen) {
      await Hive.openBox<LessonCategory>('lessonCategories');
    }

    if (!lessonsIsOpen) {
      await Hive.openBox<Lesson>('lessons');
    }

    if (!commentsIsOpen) {
      await Hive.openBox<Comment>('comments');
    }
  }

  /// This method validated if the database already exists.
  static Future<bool> databaseExists() async {
    return await Hive.boxExists('users') &&
        await Hive.boxExists('settings') &&
        await Hive.boxExists('lessons') &&
        await Hive.boxExists('lessonCategories');
  }

  /// This method returns the all the comments of a chatroom.
  ///
  /// @param lessonId The id of the lesson.
  static List<Comment> getComments(String lessonId){
    List<Comment> commentsOfLesson = [];
    for(var lesson in getCommentBox().values){
      if(lesson.lessonId == lessonId){
        commentsOfLesson.add(lesson);
      }
    }
    commentsOfLesson.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return commentsOfLesson;
  }

  /// This method adds a comment to the comment box in the db.
  ///
  /// @param c Comment to be added.
  static void addComment(Comment c) {
    getCommentBox().put(c.id, c);
  }

  /// This method deletes a comment from the comment box in the db.
  ///
  /// @param id Id of the comment to be deleted.
  static void deleteComment(String id){
    getCommentBox().delete(id);
  }

  /// This method creates a default user.
  static void createDefaultUser() {
    //add default user to box
    User defaultUser = new User(
        userName: 'user',
        userImagePath: 'assets/img/profile/default.png',
        userScore: 0,
        userId: "default");
    userBox.put("default", defaultUser);
  }

  /// This method gets the default user.
  static User? getDefaultUser() {
    return userBox.get("default");
  }

  /// This method edits the default user data.
  ///
  /// @param userName       The name of the user
  /// @param userImagePath  The path of the user image
  /// @param userScore      The user score
  /// @param showAlias      Variable to check if userName is shown in the
  /// chatroom
  /// @param showScore      Variable to check if userScore is shown in the
  /// chatroom
  static void editDefaultUser(
      String? userName, String? userImagePath, int? userScore, bool? showAlias, bool? showScore) {
    User? tempUser = getDefaultUser();

    if (tempUser!.userName != userName && null != userName)
      tempUser.userName = userName;

    if (tempUser.userImagePath != userImagePath && null != userImagePath)
      tempUser.userImagePath = userImagePath;

    if (tempUser.userScore != userScore && null != userScore)
      tempUser.userScore = userScore;

    if (tempUser.showAlias != showAlias && null != showAlias)
      tempUser.showAlias = showAlias;

    if (tempUser.showScore != showScore && null != showScore)
      tempUser.showScore = showScore;

    //persist modified User object to database
    userBox.put("default", tempUser);
  }

  /// This method edits the application settings.
  ///
  /// @param darkmode Variable to check if darkmode is enabled
  /// @param language The language
  static void editDefaultSetting(
      bool? darkmode, String? language) {
    Setting? tempSetting = getDefaultSetting();

    if (tempSetting!.darkmode != darkmode && null != darkmode)
      tempSetting.darkmode = darkmode;

    if (tempSetting.language != language && null != language) {
      tempSetting.language = language;
    }

    //persist modified Settings object to database
    settingBox.put("default", tempSetting);
  }

  /// The method adds score to the user.
  static void modifyUserScore(int score) {
    User? tempUser = getDefaultUser();
    tempUser!.userScore += score;
    userBox.put("default", tempUser);
  }

  /// This method saves current lesson state to db for later continuation.
  static void saveCurrentLesson(Lesson lesson) {
    User? tempUser = getDefaultUser();
    tempUser!.currentLesson = lesson;
    userBox.put("default", tempUser);
  }

  /// This method creates the default user.
  static void createDefaultSettings() {
    //add default settings to box
    Setting defaultSetting = new Setting(
        darkmode: false, language: 'ger');
    settingBox.put("default", defaultSetting);
  }

  /// This method gets the default settings.
  static Setting? getDefaultSetting() {
    return settingBox.get("default");
  }

  /// This method gets the user box.
  static Box<User> getUserBox() {
    return userBox;
  }

  /// This method gets the settings box.
  static Box<Setting> getSettingBox() {
    return settingBox;
  }

  /// This method gets the lesson box.
  static Box<Lesson> getLessonBox() {
    return lessonBox;
  }

  /// This method gets the box of the lesson categories
  static Box<LessonCategory> getLessonCategoryBox() {
    return lessonCategoryBox;
  }

  /// This method gets the comment box
  static Box<Comment> getCommentBox() {
    return commentBox;
  }

  /// Helper method to safely delete all boxes
  static void wipeDB() async {
    //delete the hive-boxes, clears the file content from the device
    await Hive.deleteBoxFromDisk('users');
    await Hive.deleteBoxFromDisk('settings');
    await Hive.deleteBoxFromDisk('lessons');
    await Hive.deleteBoxFromDisk('lessonCategories');
    await Hive.deleteBoxFromDisk('comments');
    // await Hive.deleteBoxFromDisk('xapis');
  }
}