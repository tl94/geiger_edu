import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/chat_controller.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/providers/chat_api.dart';
import 'package:geiger_edu/screens/chat_screen.dart';
import 'package:get/get.dart';
import 'package:page_view_indicators/step_page_indicator.dart';

class LessonContainer extends StatelessWidget {
  final LessonController lessonController = Get.find();
  final ChatController chatController = Get.find();

  static const _buttonColor = Color.fromRGBO(0, 0, 0, 0.2);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  chatController.currentLessonId = lessonController.currentLesson.lessonId;
                  ChatAPI.authenticateUser();
                  ChatAPI.saveMessagesToDB(ChatAPI.fetchMessages(chatController.currentLessonId));
                  Navigator.pushNamed(context, ChatScreen.routeName);
                }
                ,
              )
            ],
            title: Obx(() => Text(lessonController.currentTitle.value)),
            centerTitle: true),
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
                                onPressed: () =>
                                    lessonController.previousPage(),
                              ))));
                } else
                  return SizedBox.shrink();
              }),
              Obx(() {
                if (!lessonController.isOnLastSlide.value ||
                    !lessonController.getCurrentLesson().hasQuiz) {
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
                } else
                  return SizedBox.shrink();
              }),
            ],
          ))
        ])));
  }
}
