import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geiger_edu/controller/chat_controller.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/model/userObj.dart';
import 'package:geiger_edu/providers/chat_api.dart';
import 'package:geiger_edu/screens/image_view_full_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';
import 'package:hive_listener/hive_listener.dart';

import 'home_screen.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chatScreen';

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
                            // print(chatController.requestedUserId);
                            var commentImagePath = chatController.getCommentImagePath(items[index].id);
                            return Container(
                                margin: EdgeInsets.all(10),
                                child: FutureBuilder(
                                  future: chatController.getRequestedUser(chatController.requestedUserId),
                                  builder: (context, AsyncSnapshot<User> snapshot) {
                                    // print(chatController.requestedUserId);
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

/*
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/chatScreen";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path ?? ''),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path ?? '',
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    //simulate server response
    final response = await rootBundle.loadString('assets/messages.json');

    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        messages: _messages,
        onAttachmentPressed: _handleAtachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }
}
 */
