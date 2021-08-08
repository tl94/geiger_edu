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

class DB {
  static Box<User> userBox = Boxes.getUsers();
  static Box<Setting> settingBox = Boxes.getSettings();
  static Box<Lesson> lessonBox = Boxes.getLessons();
  static Box<LessonCategory> lessonCategoryBox = Boxes.getLessonCategories();
  static Box<Comment> commentBox = Boxes.getComments();

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
    // if(DB.getLessonCategoryBox().keys.isEmpty)
    print("LESSON CATEGORIES OPEN");

    if (!lessonsIsOpen) {
      await Hive.openBox<Lesson>('lessons');
    }
    // if (getLessonBox().isEmpty) { createTestLessons(); }

    if (!commentsIsOpen) {
      await Hive.openBox<Comment>('comments');
    }
    if (DB.getCommentBox().keys.isEmpty) {
      createTestComments();
    }
  }

  static Future<bool> databaseExists() async {
    print("DATABASE EXISTS?");
    return await Hive.boxExists('users') &&
        await Hive.boxExists('settings') &&
        await Hive.boxExists('lessons') &&
        await Hive.boxExists('lessonCategories');
  }

  static void updateLessonBox() {
    //TODO: validate lesson box on start check files for new lessons add them tho the lesson category
  }

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

  static void createTestComments() {
    addComment(Comment(
        id: "C001",
        text: "Gibt es ein Programm welches mir meine EMail bereinigt?",
        dateTime: DateTime.now(),
        lessonId: "LPW001",
        userId: "610ebdb0d6f3d93048080a79"));
    addComment(Comment(
        id: "C002",
        text: "Hab mir das neue Office geholt, ist das sicher?",
        dateTime: DateTime.now(),
        lessonId: "LPW001",
        userId: "610ebdb0d6f3d93048080a79"));
    addComment(Comment(
        id: "C003",
        text:
            "Wie habt ihr das gelöst mit der Verankerung des neuen Kaspersky-Cleaner??",
        dateTime: DateTime.now(),
        lessonId: "LPW003",
        userId: "610ebdb0d6f3d93048080a79"));

    //
    addComment(Comment(
        id: "C004",
        text:
        "Wie habt ihr das gelöst mit der Verankerung des neuen Kaspersky-Cleaner??",
        dateTime: DateTime.now(),
        lessonId: "LPW004",
        userId: "XYZ"));
    addComment(Comment(
        id: "C005",
        text:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        dateTime: DateTime.now(),
        lessonId: "LPW005",
        userId: "XYZ"));
    addComment(Comment(
        id: "C006",
        text:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        dateTime: DateTime.now(),
        lessonId: "LPW006",
        userId: "XYZ"));
    addComment(Comment(
        id: "C007",
        text:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        dateTime: DateTime.now(),
        lessonId: "LPW006",
        userId: "XYZ"));
    addComment(Comment(
        id: "C008",
        text:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        dateTime: DateTime.now(),
        lessonId: "LPW006",
        userId: "XYZ"));
    addComment(Comment(
        id: "C009",
        text:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        dateTime: DateTime.now(),
        lessonId: "LPW006",
        userId: "XYZ"));
    addComment(Comment(
        id: "C010",
        text:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        dateTime: DateTime.now(),
        lessonId: "LPW006",
        userId: "XYZ"));
    addComment(Comment(
        id: "C011",
        text:
        "Wie habt ihr das gelöst mit der Verankerung des neuen Kaspersky-Cleaner??",
        dateTime: DateTime.now(),
        lessonId: "LPW006",
        userId: "XYZ"));
    addComment(Comment(
        id: "C012",
        text:
        "Wie habt ihr das gelöst mit der Verankerung des neuen Kaspersky-Cleaner??",
        dateTime: DateTime.now(),
        lessonId: "LPW006",
        userId: "XYZ"));
  }

  static void addComment(Comment c) {
    getCommentBox().put(c.id, c);
  }

  static void deleteComment(String id){
    print("F:: " +id);
    print(getCommentBox().containsKey(id));
    getCommentBox().delete(id);
    print(getCommentBox().containsKey(id));
  }

  static void createTestLessons() {
    //TODO: replace with updateLessonBox
    Lesson l1 = new Lesson(
        lessonId: "LPW001",
        lessonCategoryId: "CID001",
        title: {"eng": "Password Safety", "ger": "Passwortsicherheit"},
        completed: true,
        recommended: false,
        lastIndex: 0,
        maxIndex: 6,
        motivation: {
          "eng": "Improve your password security!",
          "ger": "Verbessere deine Passwortsicherheit!"
        },
        difficulty: Difficulty.beginner,
        duration: 5,
        apiUrl: '',
        path: '',
        hasQuiz: true);
    Lesson l2 = new Lesson(
        lessonId: "LPW002",
        lessonCategoryId: "CID001",
        title: {"eng": "Password Safety", "ger": "Passwortsicherheit"},
        completed: false,
        recommended: false,
        lastIndex: 5,
        maxIndex: 8,
        motivation: {
          "eng": "Improve your password security!",
          "ger": "Verbessere deine Passwortsicherheit!"
        },
        difficulty: Difficulty.advanced,
        duration: 8,
        apiUrl: '',
        path: '',
        hasQuiz: false);
    Lesson l3 = new Lesson(
        lessonId: "LPW003",
        lessonCategoryId: "CID001",
        title: {"eng": "Password Safety", "ger": "Passwortsicherheit"},
        completed: false,
        recommended: false,
        lastIndex: 2,
        maxIndex: 4,
        motivation: {
          "eng": "Improve your password security!",
          "ger": "Verbessere deine Passwortsicherheit!"
        },
        difficulty: Difficulty.master,
        duration: 10,
        apiUrl: '',
        path: '',
        hasQuiz: false);
    List<Lesson> l = [l1, l2, l3];

    for (var lesson in l) {
      DB.getLessonBox().put(lesson.lessonId, lesson);
    }

    LessonCategory c1 = new LessonCategory(
      lessonCategoryId: "CID001",
      title: {"eng": "Passwords", "ger": "Passwörter"},
      path: "assets/lesson/password",
    );
    getLessonCategoryBox().put(c1.lessonCategoryId, c1);

    Lesson k1 = new Lesson(
        lessonId: "LMW001",
        lessonCategoryId: "CID002",
        title: {"eng": "Password Safety", "ger": "Passwortsicherheit"},
        completed: true,
        recommended: false,
        lastIndex: 0,
        maxIndex: 6,
        motivation: {
          "eng": "Improve your password security!",
          "ger": "Verbessere deine Passwortsicherheit!"
        },
        difficulty: Difficulty.beginner,
        duration: 5,
        apiUrl: '',
        path: '',
        hasQuiz: true);
    Lesson k2 = new Lesson(
        lessonId: "LMW002",
        lessonCategoryId: "CID002",
        title: {"eng": "Password Safety", "ger": "Passwortsicherheit"},
        completed: false,
        recommended: false,
        lastIndex: 5,
        maxIndex: 8,
        motivation: {
          "eng": "Improve your password security!",
          "ger": "Verbessere deine Passwortsicherheit!"
        },
        difficulty: Difficulty.advanced,
        duration: 8,
        apiUrl: '',
        path: '',
        hasQuiz: false);
    Lesson k3 = new Lesson(
        lessonId: "LMW003",
        lessonCategoryId: "CID002",
        title: {"eng": "Password Safety", "ger": "Passwortsicherheit"},
        completed: false,
        recommended: false,
        lastIndex: 2,
        maxIndex: 4,
        motivation: {
          "eng": "Improve your password security!",
          "ger": "Verbessere deine Passwortsicherheit!"
        },
        difficulty: Difficulty.master,
        duration: 10,
        apiUrl: '',
        path: '',
        hasQuiz: false);
    List<Lesson> k = [k1, k2, k3];

    for (var lesson in k) {
      DB.getLessonBox().put(lesson.lessonId, lesson);
    }

    LessonCategory c2 = new LessonCategory(
        lessonCategoryId: "CID002",
        title: {"eng": "Malware", "ger": "Malware"},
        path: "assets/lesson/password");
    getLessonCategoryBox().put(c2.lessonCategoryId, c2);
  }

  static void createDefaultUser() {
    //add default user to box
    User defaultUser = new User(
        userName: 'Daniel',
        userImagePath: 'assets/img/profile/default.png',
        userScore: 100,
        userId: "default");
    userBox.put("default", defaultUser);
  }

  static User? getDefaultUser() {
    return userBox.get("default");
  }

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

  static void modifyUserScore(int score) {
    User? tempUser = getDefaultUser();
    tempUser!.userScore += score;
    userBox.put("default", tempUser);
  }

  static void createDefaultSettings() {
    //add default settings to box
    Setting defaultSetting = new Setting(
        darkmode: false, language: 'ger');
    settingBox.put("default", defaultSetting);
  }

  static Setting? getDefaultSetting() {
    return settingBox.get("default");
  }


  static Box<User> getUserBox() {
    return userBox;
  }

  static Box<Setting> getSettingBox() {
    return settingBox;
  }

  static Box<Lesson> getLessonBox() {
    return lessonBox;
  }

  static Box<LessonCategory> getLessonCategoryBox() {
    return lessonCategoryBox;
  }

  static Box<Comment> getCommentBox() {
    return commentBox;
  }

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
