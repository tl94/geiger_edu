import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/globals.dart' as globals;
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/lesson_selection_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/NavigationContainer.dart';
import 'package:get/get.dart';

class SelectionScreen extends StatelessWidget {
  static const routeName = '/selection';

  final SettingsController settingsController = Get.find();

  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879

  int categoryCount = 0;

  List<LessonCategory> getList() {
    var lessonCategories = DB.getLessonCategoryBox().values.toList();
    return lessonCategories;
  }

  List<Lesson> getLessonListForCategory(String lessonCategoryId) {
    var lessonList = DB
        .getLessonBox()
        .values
        .where((lesson) => lesson.lessonCategoryId == lessonCategoryId)
        .toList();
    return lessonList;
  }

  Map<String, int> getCompleted(String lessonCategoryId) {
    Map<String, int> result = {};
    int completedCount = 0;

    var lessonList = getLessonListForCategory(lessonCategoryId);

    for (var lesson in lessonList) {
      if (lesson.completed) completedCount++;
    }
    print(lessonCategoryId);
    print(lessonList);
    result["completed"] = completedCount;
    result["allLessons"] = lessonList.length;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var categories = getList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),
        ),
        title: Text("Topic Selection"),
        centerTitle: true,
        backgroundColor: bckColor,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
                child: Row(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int i) {
                      var lessonSpecs = getCompleted(categories[i].lessonCategoryId);
                      return Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: NavigationContainer(
                          imagePath: "assets/img/password_icon.png",
                          text: categories[i].title[settingsController.language]!,
                          passedRoute: LessonSelectionScreen.routeName,
                          currentValue: lessonSpecs["completed"]!,
                          maxValue: lessonSpecs["allLessons"]!,
                          passedLessons: getLessonListForCategory(categories[i].lessonCategoryId),
                        ),
                      );
                    }),
              )
            ])),
          ],
        ),
      ),
    );
  }
}
