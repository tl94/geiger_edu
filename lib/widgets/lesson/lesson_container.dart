import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/chat_controller.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:get/get.dart';
import 'package:page_view_indicators/step_page_indicator.dart';

/// LessonContainer Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class LessonContainer extends StatelessWidget {
  final LessonController lessonController = Get.find();
  final ChatController chatController = Get.find();

  static const _buttonColor = Color.fromRGBO(0, 0, 0, 0.2);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Container(
                child: GestureDetector(
                  child: Image.asset("assets/img/my_comments.png",
                      width: 30, color: Colors.black),
                  onTap: () async {
                    chatController.currentLessonId =
                        lessonController.currentLesson.lessonId;
                    chatController.navigateToChat(context);
                  },
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                      child: GestureDetector(
                          onTap: () => lessonController.previousPage(),
                          child: Container(
                              width: 25,
                              height: 75,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(198, 198, 198, 0.7),
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(50))),
                              child: Icon(Icons.chevron_left))));
                  /*child: Material(
                          color: Colors.red,

                                  child: ClipPath(
                                      clipper: ClipPathClass(),
                              child: IconButton(
                                padding: const EdgeInsets.fromLTRB(20, 8,8, 8),
                                icon: Icon(Icons.chevron_left),
                                onPressed: () =>
                                    lessonController.previousPage(),
                              ))));*/
                } else
                  return SizedBox.shrink();
              }),
              Obx(() {
                if (!lessonController.isOnLastSlide.value ||
                    !lessonController.getCurrentLesson().hasQuiz) {
                  return Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () => lessonController.nextPage(),
                          child: Container(
                              width: 25,
                              height: 75,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(198, 198, 198, 0.7),
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(50))),
                              child: Icon(Icons.chevron_right))));
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

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
