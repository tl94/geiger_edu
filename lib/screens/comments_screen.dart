import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/chat_controller.dart';
import 'package:geiger_edu/controller/comments_controller.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/model/commentObj.dart';
import 'package:geiger_edu/providers/chat_api.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';
import 'package:hive_listener/hive_listener.dart';

import 'chat_screen.dart';

class CommentsScreen extends StatelessWidget {
  static const routeName = '/commentsScreen';

  final CommentsController commentsController = Get.find();
  final ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    var bckColor = GlobalController.bckColor;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("My Comments"),
          centerTitle: true,
          backgroundColor: bckColor,
        ),
        body: Obx(() => Column(children: [
              if (commentsController.hasComments.value)
                Expanded(child:
                       ListView.builder(
                        itemCount: commentsController.items.length,
                        itemBuilder: (context, index) {
                          final Comment item = commentsController.items[index]; //commentsController.items[index];
                          return GestureDetector(
                            child: Dismissible(
                              // Each Dismissible must contain a Key. Keys allow Flutter to
                              // uniquely identify widgets.
                                direction: DismissDirection.endToStart,
                                key: Key(item.id),
                                background: Container(
                                  color: Colors.green,
                                  child: Icon(Icons.check),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red,
                                  child: Container(
                                      child: Align(
                                          child: Image.asset(
                                              "assets/img/delete_icon.png",
                                              width: 20),
                                          alignment: Alignment.centerRight),
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0)),
                                ),
                                // Provide a function that tells the app
                                // what to do after an item has been swiped away.
                                onDismissed: (direction) {
                                  commentsController.deleteComment(item.id);
                                  commentsController.checkHasComments();
                                  // Then show a snackbar.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                          Text(item.text + ' dismissed')));
                                },
                                child: Container(
                                    height: 90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blueGrey,
                                          width: .5,
                                        )),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 20),
                                          Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text("Topic: " + item.lessonId),
                                                Container(
                                                    width: context.width - 80,
                                                    child: Text(commentsController
                                                        .getItemText(item.text)))
                                              ]),
                                          Expanded(
                                              child: SizedBox(
                                                width: 10,
                                              )),
                                          Image.asset(
                                            "assets/img/arrow_right.png",
                                            height: 20,
                                            key: UniqueKey(),
                                          ),
                                          SizedBox(width: 20)
                                        ]))),
                            onTap: () {
                              chatController.currentLessonId = item.lessonId;
                              ChatAPI.authenticateUser();
                              ChatAPI.saveMessagesToDB(ChatAPI.fetchMessages(chatController.currentLessonId));
                              Navigator.pushNamed(context, ChatScreen.routeName);
                            },
                          );

                        },
                      ),
                  ),

              if (!commentsController.hasComments.value)
                Expanded(
                    child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/img/my_comments.png",
                        width: 20,
                        color: Colors.grey,
                      ),
                      Container(
                          width: context.width - 80,
                          child: Text(
                              "Your comments written in the different lessons will appear here. \n \nSo far you have either not written any or dismissed them all",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)
                          )
                      )
                    ],
                  ),
                )),
              if (commentsController.hasComments.value)
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/img/delete_icon.png",
                        width: 20,
                        color: Colors.grey,
                      ),
                      Container(
                          width: context.width - 70,
                          child: Text(
                              "To dismiss comments drag them to the all the way to the left",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)))
                    ],
                  ),
                )
            ])));
  }
}
