import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/controller/lesson_category_selection_controller.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/lesson_selection_controller.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/screens/lesson_category_selection_screen.dart';
import 'package:geiger_edu/widgets/lesson_dropdown.dart';
import 'package:get/get.dart';

class LessonSelectionScreen extends StatelessWidget {
  static const routeName = '/lessonselection';

  final LessonSelectionController lessonSelectionController = Get.find();

  LessonSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bckColor = GlobalController.bckColor;

    print(lessonSelectionController.categoryTitle);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(lessonSelectionController.categoryTitle),
        centerTitle: true,
        backgroundColor: bckColor,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
                child: Row(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: lessonSelectionController.lessons.length,
                    itemBuilder: (BuildContext context, int i) {
                      var lesson = lessonSelectionController.lessons[i];
                      return Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: LessonDropdown(lesson: lesson));
                    }),
              )
            ])),
          ],
        ),
      ),
    );
  }
}
