import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/controller/lesson_category_selection_controller.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/globals.dart' as globals;
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/lesson_selection_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/navigation_container.dart';
import 'package:get/get.dart';

class LessonCategorySelectionScreen extends StatelessWidget {
  static const routeName = '/lessoncategoryselection';

  final SettingsController settingsController = Get.find();
  final LessonCategorySelectionController lessonCategorySelectionController = Get.find();


  @override
  Widget build(BuildContext context) {
    var categories = lessonCategorySelectionController.getLessonCategories();
    var bckColor = GlobalController.bckColor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("LessonTopicSelection".tr),
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
                      var lessonSpecs = lessonCategorySelectionController.getCompletedLessonsForCategory(categories[i].lessonCategoryId);
                      return Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: NavigationContainer(
                          imagePath: "assets/img/password_icon.png",
                          text: categories[i].title[settingsController.language]!,
                          passedRoute: LessonSelectionScreen.routeName,
                          currentValue: lessonSpecs["completed"]!,
                          maxValue: lessonSpecs["allLessons"]!,
                          passedLessons: lessonCategorySelectionController.getLessonListForCategory(categories[i].lessonCategoryId),
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
