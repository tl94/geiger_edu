import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/screens/selection_screen.dart';
import 'package:geiger_edu/widgets/LessonDropdown.dart';

import 'package:geiger_edu/globals.dart' as globals;

class LessonSelectionScreen extends StatelessWidget {
  static const routeName = '/lessonselection';
  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879

  final String categoryTitle;
  final List<Lesson> lessons;

  const LessonSelectionScreen({
    Key? key,
    required this.categoryTitle,
    required this.lessons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(categoryTitle);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, SelectionScreen.routeName),
        ),
        title: Text(categoryTitle),
        centerTitle: true,
        backgroundColor: bckColor,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
                child: Row(children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width-40,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: this.lessons.length,
                        itemBuilder: (BuildContext context, int i) {
                          var lesson = this.lessons[i];
                          return Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: LessonDropdown(
                                lesson: lesson,
                                title: lesson.title[globals.language]!,
                                completed: lesson.completed,
                                motivation: lesson.motivation[globals.language],
                                duration: lesson.duration,
                                difficulty: lesson.difficulty.toString(),
                              )
                          );
                        }),
                  )])),
          ],
        ),
      ),
    );
  }
}