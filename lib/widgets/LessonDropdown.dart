import 'package:flutter/material.dart';
import 'package:geiger_edu/globals.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/globals.dart' as globals;

class LessonDropdown extends StatefulWidget {
  final String title;
  final bool completed;

  //**Dropdown opened**
  final String? motivation;
  final int? lengthInMinutes;
  final String? difficultyLevel;

  LessonDropdown(
      {required this.title,
        required this.completed,
        this.motivation,
        this.lengthInMinutes,
        this.difficultyLevel})
      : super();

  _LessonDropdownState createState() => _LessonDropdownState();
}

class _LessonDropdownState extends State<LessonDropdown> {
  bool _isOpened = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: new GestureDetector(
        onTap: () {
          setState(() {
            _isOpened = !_isOpened;
          });
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
                    _isOpened ? "assets/img/arrow_down.png" : "assets/img/arrow_up.png",
                    width: 20,
                    key: UniqueKey(),
                  )
                ])),
      ),
    );
  }
}
