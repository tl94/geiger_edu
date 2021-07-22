import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/screens/selection_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/LessonDropdown.dart';

import 'lesson_screen.dart';
import 'package:geiger_edu/globals.dart' as globals;

class LessonSelectionScreen extends StatelessWidget {
  static const routeName = '/lessonSelection';
  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879

  final String? title;
  final List<Lesson>? lessons;

  const LessonSelectionScreen({
    Key? key,
    required this.title,
    required this.lessons,
  }) : super(key: key);

  Map<String, int> getCompleted(var key){
    Map<String, int> result = {};
    int completedCount = 0;

    var lessonList = DB.getLessonCategoryBox().get(key)!.lessonList;

    for(var lesson in lessonList ){
      if(lesson.completed)
        completedCount++;
    }

    result["completed"]=completedCount;
    result["allLessons"]=lessonList.length;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, SelectionScreen.routeName),
        ),
        title: Text(title!),
        centerTitle: true,
        backgroundColor: bckColor,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                        itemCount: this.lessons!.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child:LessonDropdown(
                                title: this.lessons![i].name,
                                completed: this.lessons![i].completed,
                                //TODO: ADD MISSING LESSON PARAMETERS
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