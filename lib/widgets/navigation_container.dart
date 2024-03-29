import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/controller/lesson_category_selection_controller.dart';
import 'package:geiger_edu/controller/lesson_selection_controller.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:get/get.dart';

/// NavigationContainer Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class NavigationContainer extends StatelessWidget {
  final LessonSelectionController lessonSelectionController = Get.find();
  final LessonCategorySelectionController lessonCategorySelectionController =
      Get.find();

  final String passedRoute;
  final String text;
  final String imagePath;

  final int currentValue;
  final int maxValue;

  final List<Lesson>? passedLessons;
  final Function? continueLessonFunction;

  final double _indicatorHeight = 10;

  NavigationContainer(
      {required this.passedRoute,
      required this.text,
      required this.imagePath,
      this.currentValue = -1,
      this.maxValue = -1,
      this.passedLessons,
      this.continueLessonFunction})
      : super();

  @override
  Widget build(BuildContext context) {
    var txtColor = GlobalController.txtColor;

    return Container(
      height: 75,
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: new GestureDetector(
        onTap: () async {
          /// check if lessons were passed for lesson selection route
          if (passedLessons != null) {
            lessonSelectionController.setCategoryTitle(text);
            lessonSelectionController.setLessons(passedLessons!);
          }
          /// check if current lesson is null for continue lesson
          /// (lesson screen) route
          var currentLessonIsNull = false;
          if (continueLessonFunction != null) {
            currentLessonIsNull = await continueLessonFunction!();
          }
          // TODO: this makes the button do nothing in certain cases,
          //  however in the future button should just be disabled and
          //  display as such instead
          if (passedLessons != null || !currentLessonIsNull) {
            Navigator.pushNamed(
              context,
              passedRoute,
              arguments: {'title': text},
            );
          }
        },
        child: Container(
            padding: EdgeInsets.all(20.0),
            //margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    imagePath,
                    height: 40,
                    key: UniqueKey(),
                  ),
                  SizedBox(width: 15),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: txtColor,
                      fontFamily: "Fontin",
                    ),
                  ),
                  Expanded(
                    child: SizedBox(width: 1),
                  ),
                  if (currentValue != -1)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            currentValue.toString() + "/" + maxValue.toString(),
                            style: TextStyle(fontSize: 20.0)),
                        Expanded(
                          child: Row(children: [
                            Container(
                              height: _indicatorHeight,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: currentValue,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Container(
                                        margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                        width: lessonCategorySelectionController
                                            .calcCompletedLessonIndicatorWidth(
                                                currentValue, maxValue),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(2)));
                                  }),
                            ),
                            Container(
                                height: _indicatorHeight,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: maxValue - currentValue,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Container(
                                          margin:
                                              EdgeInsets.fromLTRB(4, 0, 0, 0),
                                          width: lessonCategorySelectionController
                                              .calcCompletedLessonIndicatorWidth(
                                                  currentValue, maxValue),
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(2)));
                                    }))
                          ]),
                        )
                      ],
                    ),
                  Expanded(
                    child: SizedBox(width: 1),
                  ),
                  Image.asset(
                    "assets/img/arrow_right.png",
                    height: 20,
                    key: UniqueKey(),
                  )
                ])),
      ),
    );
  }
}
