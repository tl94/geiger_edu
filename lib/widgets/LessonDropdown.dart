import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/globals.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/lesson_screen.dart';

import 'package:geiger_edu/globals.dart' as globals;
import 'package:geiger_edu/services/lesson_loader.dart';
import 'package:get/get.dart';

class LessonDropdown extends StatefulWidget {

  final LessonController lessonController = Get.find();
  final SettingsController settingsController = Get.find();

  Lesson lesson;

  final String title;
  final bool completed;

  //**Dropdown opened**
  final String? motivation;
  final int? duration;
  final String? difficulty;

  LessonDropdown(
      { required this.lesson,
        required this.title,
        required this.completed,
        this.motivation = "-",
        this.duration = 0,
        this.difficulty = "Beginner"})
      : super();

  _LessonDropdownState createState() => _LessonDropdownState();
}

class _LessonDropdownState extends State<LessonDropdown> {
  bool _isOpened = false;
  static final _titleColor = const Color(0xff748ea0);
  final double _dropDownHeight = 300;
  final double _fontSize = 18;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _isOpened ? 90+_dropDownHeight : 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
      child: new GestureDetector(
        onTap: () {
          setState(() {
            _isOpened = !_isOpened;
          });
        },
        child: Column(children: [Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Container(
                margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                width: 5,
                height: 50,
                decoration: BoxDecoration(
                color: widget.completed ? Colors.green : Colors.orange,
                borderRadius:
                BorderRadius.circular(2))),
                  SizedBox(width: 20),
                  Text(
                    widget.title,
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
                  Image.asset(
                    _isOpened ? "assets/img/arrow_up.png" :  "assets/img/arrow_down.png",
                    width: 20,
                    key: UniqueKey(),
                  )
                ])),

          //** DROP-DOWN **
          if(_isOpened)
                Container(
                    padding: EdgeInsets.all(20.0),
                    height: _dropDownHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Image.asset(
                            "assets/img/motivation_icon.png",
                            height: 40,
                            key: UniqueKey(),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text("Motivation",
                                style: TextStyle(color: _titleColor,fontSize: _fontSize)
                            ),
                            Container(width: 200,
                                child: Text(
                                    widget.motivation.toString(),
                                    style: TextStyle(fontSize: _fontSize)
                                ))
                          ],)
                        ],),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/img/duration_icon.png",
                              height: 40,
                              key: UniqueKey(),
                            ),
                            SizedBox(width: 20),
                            Text("Länge",
                                style: TextStyle(color: _titleColor,fontSize: _fontSize)
                            ),
                            Expanded(child: SizedBox(width: 1)),
                            Text(
                                widget.duration.toString()+"'",
                                style: TextStyle(fontSize: _fontSize)
                            )
                          ],),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Image.asset(
                            "assets/img/difficulty_level_icon.png",
                            height: 40,
                            key: UniqueKey(),
                          ),
                          SizedBox(width: 20),
                          Text("Difficulty", style: TextStyle(color: _titleColor,fontSize: _fontSize)),
                          Expanded(child: SizedBox(width: 1)),
                          Text(widget.difficulty.toString(),style: TextStyle(fontSize: _fontSize))
                        ],),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 110.0,
                              height: 40.0,
                              child:
                            OutlinedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.pressed))
                                        return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                                      return Colors.green;
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)))    ,
                              ),
                              onPressed: () async {
                                //TODO: Put this in its own function
                                print("SETTING LESSON TO: " + widget.lesson.title[widget.settingsController.language]!);
                                await widget.lessonController.setLesson(context, widget.lesson);
                                Navigator.pushNamed(
                                context,
                                LessonScreen.routeName,
                                arguments: {'title': widget.title});
                                },
                              child: Text('Start',style: TextStyle(fontSize: 20, color: Colors.white)),
                            ),
                            )
                          ])
                      ])
                )
        ])
        )
    );
  }
}
