import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:get/get.dart';
import 'package:page_view_indicators/step_page_indicator.dart';

class LessonContainer extends StatelessWidget {
  final LessonController lessonController = Get.find();

  static const _buttonColor = Color.fromRGBO(0, 0, 0, 0.2);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Obx(() => Text(lessonController.currentTitle.value))),
        body: Container(
            child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: StepPageIndicator(
                  itemCount: lessonController.slides.length,
                  currentPageNotifier: lessonController.currentPageNotifier,
                  size: 16,
                  onPageSelected: (int index) {
                    lessonController.pageController.jumpToPage(index);
                  },
                ),
              ))
            ],
          ),
          Expanded(
              child: Stack(
            children: [
              PageView(
                controller: lessonController.pageController,
                children: lessonController.slides,
                onPageChanged: lessonController.onSlideChanged,
                allowImplicitScrolling: true,
              ),
              Obx(() {
                if (!lessonController.isOnFirstSlide.value) {
                  return Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                          color: Colors.transparent,
                          child: Ink(
                              decoration: const ShapeDecoration(
                                color: _buttonColor,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.chevron_left),
                                onPressed: () => lessonController.previousPage(),
                              ))));
                } else
                  return SizedBox.shrink();
              }),
              Obx(() {
                if (!lessonController.isOnLastSlide.value || !lessonController.getLesson().hasQuiz) {
                  return Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                          color: Colors.transparent,
                          child: Ink(
                              decoration: const ShapeDecoration(
                                color: _buttonColor,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () => lessonController.nextPage(),
                              ))));
                } else return SizedBox.shrink();
              }),
            ],
          ))
        ])));
  }
}
