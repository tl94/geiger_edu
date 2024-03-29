import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/chat_controller.dart';
import 'package:geiger_edu/controller/comments_controller.dart';
import 'package:geiger_edu/model/commentObj.dart';
import 'package:get/get.dart';

/// CommentsScreen Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class CommentsScreen extends StatelessWidget {
  static const routeName = '/commentsScreen';

  final CommentsController commentsController = Get.find();
  final ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    commentsController.checkHasComments();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("MyCommentsTitle".tr),
          centerTitle: true,
        ),
        body: Obx(() => Column(children: [
              if (commentsController.hasComments.value)
                Expanded(
                  child: ListView.builder(
                    itemCount: commentsController.items.length,
                    itemBuilder: (context, index) {
                      final Comment item = commentsController
                          .items[index]; //commentsController.items[index];
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
                                      content: Text(item.text +
                                          'MyCommentsDismissed'.tr)));
                            },
                            child: Container(
                                height: 90,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.blueGrey,
                                  width: .5,
                                )),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            Text("MyCommentsTopic".tr +
                                                item.lessonId),
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
                        onTap: () async {
                          chatController.currentLessonId = item.lessonId;
                          await chatController.navigateToChat(context);
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
                          child: Text("MyCommentsNoComments".tr,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)))
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
                          child: Text("MyCommentsDismissInstruction".tr,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)))
                    ],
                  ),
                )
            ])));
  }
}
