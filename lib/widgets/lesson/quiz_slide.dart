import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/quiz_controller.dart';
import 'package:get/get.dart';

/// QuizSlide Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class QuizSlide extends StatelessWidget {
  final QuizController quizController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(30),
        child: FutureBuilder<List<Widget>>(
            future: quizController.getQuestionGroups(context),
            builder:
                (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
              List<Widget> children;

              if (snapshot.hasData) {
                children = [
                  Text(
                    quizController.introText,
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // add QuestionGroups
                  for (var qg in snapshot.data!) qg,
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5);
                          return Colors.green;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                    onPressed: quizController.finishQuiz,
                    child: Text('QuizFinishQuiz'.tr,
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  )
                ];
              } else {
                children = <Widget>[Container(color: Colors.white)];
              }
              return ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    return children[index];
                  });
            }));
  }
}
