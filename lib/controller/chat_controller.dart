import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/controller/io_controller.dart';
import 'package:geiger_edu/model/commentObj.dart';
import 'package:geiger_edu/model/userObj.dart';
import 'package:geiger_edu/providers/chat_api.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ChatController extends GetxController {


  final GlobalController globalController = Get.find();
  final IOController ioController = Get.find();

  final ImagePicker _picker = ImagePicker();
  var currentImage = "".obs;
  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      currentImage ( pickedFile.path.toString() );
    } else {
      print('No image selected.');
    }
  }

  var bckColor = GlobalController.bckColor;
  var message = "";
  var lastMessageId = 0;
  var currentLessonId = "LPW001";
  var msgController = TextEditingController();
  var image = "";

  String getCommentImagePath(String commentId){
    var imageFilePath = DB.getCommentBox().get(commentId)!.imageFilePath;
    if(imageFilePath != null){
      return image = imageFilePath;
    }
    return image = "";
  }

  /*var items = List<Comment>.generate(5, (i) => new Comment(
      id: "C00"+i.toString(),
      text:
      "Text: $i",
      dateTime: DateTime.now(),
      lessonId: "LPW001",
      userId: "default")).obs;*/
  var scrollController = ScrollController();

  //unused
  List<Comment> loadLessons() {
    return DB.getComments("LPW001");
  }

  // var items = DB.getComments("LPW001").obs;

  var requestedUserId = "XYZ";

  String getDefaultUserId() {
    return DB.getDefaultUser()!.userId;
  }

  String getUserImagePath() {
    //print(DB.getComments("LPW001").length);

    if (requestedUserId == getDefaultUserId()) {
      return DB.getDefaultUser()!.userImagePath.toString();
    } else {
      //TODO: SERVER REQUEST)
      return "assets/img/profile/user-09.png";
    }
  }

  void setRequestedUserId(String commentId) {
    requestedUserId = DB.getCommentBox().get(commentId)!.userId;
  }

  Future<String> getUserName() async {
    if (requestedUserId == getDefaultUserId()) {
      if(!DB.getDefaultUser()!.showAlias){
        return ("Anonymous");
      }
      return DB.getDefaultUser()!.userName;
    } else {
      User requestedUser = await getRequestedUser(requestedUserId);

      //TODO: SERVER REQUEST)
      return requestedUser.userName;
    }
  }
  String getUserScore() {
    var defaultUserId = DB.getDefaultUser()!.userId;
    if (requestedUserId == getDefaultUserId()) {
      if(!DB.getDefaultUser()!.showScore){
        return ("");
      }
      return DB.getDefaultUser()!.userScore.toString();
    } else {
      //TODO: SERVER REQUEST)
      return "???";
    }
  }

  //if its a comment of the user messages are displayed right
  MainAxisAlignment getMainAxisAlignment(){
    //if (requestedUserId == defaultUserId) {
    //  return MainAxisAlignment.end;
    //}else{
    return MainAxisAlignment.start;
    //}
  }

  String getCommentDate(String commentId) {
    return DateFormat.yMMMd().format(DB.getCommentBox().get(commentId)!.dateTime);
  }

  Future<void> deleteComment(String commentId) async {
    var comment = DB.getCommentBox().get(commentId);
    if (comment!.imageFilePath != null && comment.imageFilePath != '') {
      await ioController.deleteFile(File(comment.imageFilePath!));
    }
    DB.deleteComment(commentId);
    ChatAPI.deleteMessage(commentId);
  }

  Future<String> getFilePath() async {
    var fileName = currentImage.value.split("/");

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/'+ fileName.last;
//geiger_edu/$currentLessonId
    return filePath;
  }

  void saveImageLocally() async {
    final File file = File( currentImage.value );
    file.copy(await getFilePath());
  }

  Future<void> sendMessage() async {
    if (message != "" || currentImage.value != "") {
      //add message
      var attachedImage;
      var imageId = '';
      if(currentImage.value != ""){
        attachedImage = await getFilePath();
        imageId = await ChatAPI.sendImage(currentImage.value, currentLessonId);
        saveImageLocally();

      }else{
        attachedImage = null;
      }

      //generate comment object
      Comment comment = new Comment(
          id: "C00_"+DateTime.now().toString(), //TODO: SERVER RESPONSE
          text: message,
          dateTime: DateTime.now(),
          lessonId: currentLessonId,
          userId: DB.getDefaultUser()!.userId,
          imageId: imageId,
          imageFilePath: attachedImage);
      // items.add(comment);
      ChatAPI.sendMessage(comment);

      //print("MATRIXX::: " + DB.commentBox.get(comment)!.imageFilePath!);
      //clear text input
      msgController.clear();
      message="";
      currentImage.value = "" ;
      //scroll to the bottom of the list view
      scrollController.animateTo(
        scrollController.position.maxScrollExtent, //+height of new item
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<User> getRequestedUser(String requestedUserId) async {
    User user = await ChatAPI.getForeignUserData(requestedUserId);
    return user;
  }

/*
//unused
  Expanded getContentWidget(){
    if(globalController.source.keys.toList()[0] == ConnectivityResult.none){
      return Expanded(child: Text("NO INTERNET CONNECTION AVAILABLE"));
    }
    return Expanded(
      child: Container(
          child: ListView.builder(
            controller: scrollController,
            itemCount: items.length,
            itemBuilder: (context, index) {
              setRequestedUserId(index);
              return Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: getMainAxisAlignment(),
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
                                child: Image.asset(getUserImagePath(),
                                    width: 50)),
                          ),
                          Text(getUserScore())
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
                                  Text(getUserName()),
                                  Container(
                                    width: context.width,
                                    child: Text(items[index].text),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Antworten"),
                                Text(getCommentDate(index))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )
                //child: ListTile(
                //  title: Text(items[index].text),subtitle: Text(items[index].dateTime.toString()),
                //)
              );
            },
          )),
    );
  }
*/

}
