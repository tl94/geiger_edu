import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:geiger_edu/widgets/lesson/quiz_slide.dart';

class LessonCompleteSlide extends StatefulWidget {
  final String lessonPath;

  LessonCompleteSlide({required this.lessonPath});

  @override
  State<StatefulWidget> createState() => _LessonCompleteSlideState();
}

class _LessonCompleteSlideState extends State<LessonCompleteSlide> {
  static const String icon1 = "assets/img/congratulations_icon.svg";
  static const String icon2 = "assets/img/trophy_icon.svg";

  void checkSvg(String svgString) {
    final SvgParser parser = SvgParser();
    try {
      parser.parse(svgString, warningsAsErrors: true);
      print('SVG is supported');
    } catch (e) {
      print('SVG contains unsupported features');
    }
  }

  void _onPressed() {
    Navigator.pushNamed(
          context,
          QuizSlide.routeName
      );
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text("Congratulations!"),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SvgPicture.asset(
                  icon1,
                ),
              ),
              Expanded(
                child: SvgPicture.asset(
                  icon2,
                ),
              ),
              Column(children: [
                Center(child: Text("+25")),
                Center(
                  child: Text("Learn-Score"),
                )
              ])
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                    "If you now and in the future follow all the recommendations given in this tutorial your passwords will be safe."),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                    "It is recommended that you revisit this lesson in the future to keep practising."),
              )
            ],
          ),
          Row(
            children: [
              Text("Remind me:"),
              ElevatedButton(
                  onPressed: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.utc(2100, 12, 31)),
                  child: Text("Set Reminder"))
            ],
          ),
          ElevatedButton(
              onPressed: _onPressed,
              child: const Text("Finish Lesson"))
        ],
      ),
    );
  }
}
