import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/model/commentObj.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ChatController extends GetxController {


  final GlobalController globalController = Get.find();

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

  String getCommentImagePath(int index){
    var imageFilePath = DB.getCommentBox().get(items[index].id)!.imageFilePath;
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

  var items = DB.getComments("LPW001").obs;

  var requestedUserId = "XYZ";
  var defaultUserId = DB.getDefaultUser()!.userId;

  String getUserImagePath() {
    //print(DB.getComments("LPW001").length);
    if (requestedUserId == defaultUserId) {
      return DB.getDefaultUser()!.userImagePath.toString();
    } else {
      //TODO: SERVER REQUEST)
      return "assets/img/profile/user-09.png";
    }
  }

  void setRequestedUserId(int index) {
    requestedUserId = items[index].userId;
  }

  String getUserName() {
    if (requestedUserId == defaultUserId) {
      if(!DB.getDefaultSetting()!.showAlias){
        return ("Anonymous");
      }
      return DB.getDefaultUser()!.userName;
    } else {
      //TODO: SERVER REQUEST)
      return "???";
    }
  }
  String getUserScore() {
    if (requestedUserId == defaultUserId) {
      if(!DB.getDefaultSetting()!.showScore){
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

  String getCommentDate(int index) {
    return DateFormat.yMMMd().format(items[index].dateTime);
  }

  void deleteComment(int index){
    DB.deleteComment(items[index].id);
    //TODO: FIX THIS WORKAROUND::
    items.removeAt(index); // = DB.getComments(currentLessonId);
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
      if(currentImage.value != ""){
        attachedImage = await getFilePath();
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
          imageFilePath: attachedImage);
      items.add(comment);
      DB.addComment(comment);

      //print("MATRIXX::: " + DB.commentBox.get(comment)!.imageFilePath!);
      //clear text input
      msgController.clear();
      message="";
      currentImage.value = "" ;
      //scroll to the bottom of the list view
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 150, //+height of new item
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
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
