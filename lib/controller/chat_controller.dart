import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/controller/io_controller.dart';
import 'package:geiger_edu/model/commentObj.dart';
import 'package:geiger_edu/model/userObj.dart';
import 'package:geiger_edu/services/chat_api.dart';
import 'package:geiger_edu/screens/chat_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// This class handles all the business logic of the chat.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class ChatController extends GetxController {
  final GlobalController globalController = Get.find();
  final IOController ioController = Get.find();
  final ImagePicker _picker = ImagePicker();
  var msgController = TextEditingController();
  var scrollController = ScrollController();
  var bckColor = GlobalController.bckColor;
  var lastMessageId = 0;
  var currentImage = "".obs;
  var currentLessonId = "";
  var message = "";
  var image = "";
  var requestedUserId = "";

  /// This method lets a user select an image from the gallery.
  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      currentImage(pickedFile.path.toString());
    }
  }

  /// This method gets the file path of a comment containing a image.
  ///
  /// @param commentId The id a comment has.
  String getCommentImagePath(String commentId) {
    var imageFilePath = DB.getCommentBox().get(commentId)!.imageFilePath;
    if (imageFilePath != null) {
      return image = imageFilePath;
    }
    return image = "";
  }

  /// This method sets the author id of the comment.
  ///
  /// @param commentId The id a comment has.
  void setRequestedUserId(String commentId) {
    requestedUserId = DB.getCommentBox().get(commentId)!.userId;
  }

  /// This method gets the author name of a comment.
  Future<String> getUserName() async {
    if (requestedUserId == getDefaultUserId()) {
      if (!DB.getDefaultUser()!.showAlias) {
        return ("Anonymous");
      }
      return DB.getDefaultUser()!.userName;
    } else {
      User requestedUser = await getRequestedUser(requestedUserId);
      return requestedUser.userName;
    }
  }

  /// This method gets the user score of the comments author.
  ///
  /// @param user The user object of a comment.
  String getUserScore(User user) {
    if (!user.showScore) {
      return ("-");
    } else {
      return user.userScore.toString();
    }
  }

  ///This method sets the position of an element to either the left or the right
  /// of the screen.
  MainAxisAlignment getMainAxisAlignment() {
    //if (requestedUserId == defaultUserId) {
    //  return MainAxisAlignment.end;
    //}else{
    return MainAxisAlignment.start;
    //}
  }

  /// This method gets the date of the individual comment from the db.
  ///
  /// @param commentId The id a comment has.
  String getCommentDate(String commentId) {
    return DateFormat.yMMMd()
        .format(DB.getCommentBox().get(commentId)!.dateTime);
  }

  /// This method deletes selected comment from the db and requests deletion on
  /// the server.
  ///
  /// @param commentId The id a comment has.
  Future<void> deleteComment(String commentId) async {
    var comment = DB.getCommentBox().get(commentId);
    if (comment!.imageFilePath != null && comment.imageFilePath != '') {
      await ioController.deleteFile(File(comment.imageFilePath!));
    }
    DB.deleteComment(commentId);
    ChatAPI.deleteMessage(commentId);
  }

  /// This method saves a image locally.
  void saveImageLocally() async {
    final File file = File(currentImage.value);
    file.copy(await getFilePath());
  }

  /// This method gets the file path of the application.
  Future<String> getFilePath() async {
    var fileName = currentImage.value.split("/");
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/' + fileName.last;
    return filePath;
  }

  /// This method sends the message to the server and resets the input field.
  Future<void> sendMessage() async {
    if (message != "" || currentImage.value != "") {
      //add message
      var attachedImage;
      var imageId = '';
      if (currentImage.value != "") {
        attachedImage = await getFilePath();
        imageId = await ChatAPI.sendImage(currentImage.value, currentLessonId);
        saveImageLocally();
      } else {
        attachedImage = null;
      }

      //generate comment object
      Comment comment = new Comment(
          id: "C00_" + DateTime.now().toString(), //TODO: SERVER RESPONSE
          text: message,
          dateTime: DateTime.now(),
          lessonId: currentLessonId,
          userId: DB.getDefaultUser()!.userId,
          imageId: imageId,
          imageFilePath: attachedImage);
      ChatAPI.sendMessage(comment);

      //clear text input
      msgController.clear();
      message = "";
      currentImage.value = "";

      //scroll to the bottom of the list view
      scrollController.animateTo(
        scrollController.position.maxScrollExtent, //+height of new item
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  /// This method navigates to the chat of the currently selected lesson.
  ///
  /// @param context The context of the parent widget.
  Future<void> navigateToChat(BuildContext context) async {
    await ChatAPI.authenticateUser();
    ChatAPI.saveMessagesToDB(ChatAPI.fetchMessages(currentLessonId));
    Navigator.pushNamed(context, ChatScreen.routeName);
  }

  /// HELPER METHODS ///

  /// This method returns the user of a comment.
  ///
  /// @param requestedUserId The id of the requested user.
  Future<User> getRequestedUser(String requestedUserId) async {
    User user = await ChatAPI.getForeignUserData(requestedUserId);
    return user;
  }

  /// This method get the default user id.
  String getDefaultUserId() {
    return DB.getDefaultUser()!.userId;
  }
}
