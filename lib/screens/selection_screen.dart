import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/profile_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/NavigationContainer.dart';

import 'lesson_screen.dart';
import 'package:geiger_edu/globals.dart';

class SelectionScreen extends StatelessWidget {
  static const routeName = '/selection';

  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879

  int categoryCount = 0;


  List<String> getList(){
    List<String> gst = <String>[];
    for(var key in DB.getLessonCategoryBox().keys){
      var g = DB.getLessonCategoryBox().get(key)!.name;
      categoryCount++;
      gst.add(g);
    }
    return gst;
  }

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
    var gst = getList();

    return Scaffold(
      appBar: AppBar(
        leading: new Container(),
        title: Text("GEIGER Mobile Learning"),
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
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: gst.length,
              itemBuilder: (BuildContext context, int i) {
                var lessonSpecs = getCompleted(gst[i]);
                return Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: NavigationContainer(
                      imagePath: "assets/img/password_icon.png",
                      text: gst[i].toString(),
                      passedRoute: HomeScreen.routeName,
                      currentValue: lessonSpecs["completed"]!,
                      maxValue: lessonSpecs["allLessons"]!,
                    ),
                );
              }),
        )])),

              ],
            ),

        ),
      );
  }
}