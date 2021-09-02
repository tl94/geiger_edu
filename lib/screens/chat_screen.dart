import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geiger_edu/controller/chat_controller.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/model/userObj.dart';
import 'package:geiger_edu/screens/image_view_full_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';
import 'package:hive_listener/hive_listener.dart';

/// ChatScreen Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class ChatScreen extends StatelessWidget {
  static const routeName = '/chatscreen';

  final ChatController chatController = Get.find();
  final GlobalController globalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("ChatTitle".tr + chatController.currentLessonId),
          centerTitle: true,
          backgroundColor: chatController.bckColor,
        ),
        body: Obx(
          () => Container(
              child: Column(children: [
            if (globalController.source.keys.toList().first ==
                ConnectivityResult.none)
              //** Internet Connection not available **
              Expanded(
                  child: Center(
                      child: Container(
                          width: context.width * 0.75,
                          child: Text(
                              "ChatNoInternetConnection".tr,
                              textAlign: TextAlign.left)))),
            if (globalController.source.keys.toList().first !=
                ConnectivityResult.none)
              //** Chat Messages **
              HiveListener(
                box: DB.getCommentBox(),
                builder: (box) {
                  var items = DB.getComments(chatController.currentLessonId);
                  var length = items.length;

                  return Expanded(
                    child: Container(
                        child: ListView.builder(
                          controller: chatController.scrollController,
                          itemCount: length,
                          itemBuilder: (context, index) {
                            chatController.setRequestedUserId(items[index].id);
                            var commentImagePath = chatController.getCommentImagePath(items[index].id);
                            return Container(
                                margin: EdgeInsets.all(10),
                                child: FutureBuilder(
                                  future: chatController.getRequestedUser(chatController.requestedUserId),
                                  builder: (context, AsyncSnapshot<User> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                      return Row(
                                        mainAxisAlignment:
                                        chatController.getMainAxisAlignment(),
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black54,
                                                      blurRadius: 4.0,
                                                      offset: Offset(0.0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipOval(
                                                    child: Image.asset(
                                                        snapshot.data!.userImagePath,
                                                        width: 50)),
                                              ),
                                              Text(chatController.getUserScore(snapshot.data!))
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: context.width / 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Color.fromRGBO(234, 240, 243, 1),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(snapshot.data!.userName),
                                                      SizedBox(height: 10),
                                                      //** COMMENT HAS IMAGE ATTACHED **
                                                      if (commentImagePath !=
                                                          "") //chatController.items[index].image
                                                        GestureDetector(
                                                          child: Container(
                                                            width: context.width,
                                                            child: Image.file(File(
                                                                commentImagePath)),
                                                          ),
                                                          onTap: () {
                                                            globalController.selectedImage =
                                                                commentImagePath;
                                                            Navigator.push(context,
                                                                MaterialPageRoute(
                                                                    builder: (_) {
                                                                      return ImageViewFullScreen();
                                                                    }));
                                                          },
                                                          onLongPress: () {
                                                            if (chatController.requestedUserId ==
                                                                chatController.getDefaultUserId()) {
                                                              showDialog(
                                                                context: context,
                                                                builder: (_) => AlertDialog(
                                                                  title:
                                                                  Text("ChatDeleteMessage".tr),
                                                                  content: Text(
                                                                      "ChatDeleteMessagePopup".tr),
                                                                  actions: [
                                                                    OutlinedButton(
                                                                        onPressed: () {
                                                                          //FocusScope.of(context).requestFocus(FocusNode());
                                                                          //SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                                          Navigator.of(context,rootNavigator:true).pop('dialog');
                                                                        },
                                                                        child: Text("ChatDeleteMessageNo".tr)),
                                                                    OutlinedButton(
                                                                        onPressed: () {
                                                                          chatController.deleteComment(items[index].id);
                                                                          Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                        },
                                                                        child: Text("ChatDeleteMessageYes".tr)),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),

                                                      //** COMMENT HAS NO IMAGE ATTACHED **
                                                      if (commentImagePath ==
                                                          "") //chatController.items[index].image
                                                        GestureDetector(
                                                          child: Container(
                                                            width: context.width,
                                                            child: Text(items[index].text),
                                                          ),
                                                          onLongPress: () {
                                                            if (chatController
                                                                .requestedUserId ==
                                                                chatController
                                                                    .getDefaultUserId()) {
                                                              showDialog(
                                                                context: context,
                                                                builder: (_) => AlertDialog(
                                                                  title:
                                                                  Text("ChatDeleteMessage".tr),
                                                                  content: Text(
                                                                      "ChatDeleteMessagePopup".tr),
                                                                  actions: [
                                                                    OutlinedButton(
                                                                        onPressed: () {
                                                                          Navigator.of(
                                                                              context,
                                                                              rootNavigator:
                                                                              true)
                                                                              .pop('dialog');
                                                                        },
                                                                        child: Text("ChatDeleteMessageNo".tr)),
                                                                    OutlinedButton(
                                                                        onPressed: () {
                                                                          chatController
                                                                              .deleteComment(
                                                                              items[index].id);
                                                                          Navigator.of(
                                                                              context,
                                                                              rootNavigator:
                                                                              true)
                                                                              .pop('dialog');
                                                                        },
                                                                        child: Text("ChatDeleteMessageYes".tr)),
                                                                    //OutlineButton("NO"),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(chatController.getCommentDate(items[index].id))
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                )

                              //child: ListTile(
                              //  title: Text(items[index].text),subtitle: Text(items[index].dateTime.toString()),
                              //)
                            );
                          },
                        )),
                  );
                },
              ),

            if (globalController.source.keys.toList().first !=
                ConnectivityResult.none)
              //** INPUT BAR **

              Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    children: [
                      if (chatController.currentImage.value != "")
                        Container(
                            height: 150,
                            child: Image.file(
                                File(chatController.currentImage.toString()))),
                      Text(chatController.currentImage.toString()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () => {chatController.getImage()},
                              child: Image.asset(
                                "assets/img/attachment.png",
                                width: 25,
                                color: Colors.grey,
                              )),
                          Container(
                            //height: 40,
                            width: context.width - 90,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              //Normal textInputField will be displayed
                              maxLines: 5,
                              // when user presses enter it will adapt to it
                              controller: chatController.msgController,
                              decoration: InputDecoration(
                                hintText: "ChatWriteMessage".tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                              ),
                              onSubmitted: (text) {
                                text = text + "\n";
                              },
                              onChanged: (text) {
                                chatController.message = text;
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                              chatController.sendMessage();
                              FocusScope.of(context).requestFocus(FocusNode());
                              },
                            child: Container(
                                child: InkWell(
                                    child: Image.asset(
                              "assets/img/arrow_send.png",
                              width: 30,
                              height: 50,
                              //color: Colors.blue,
                            ))),
                          )
                        ],
                      ),
                    ],
                  ))
          ])),
        ));
  }
}
