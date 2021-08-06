import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/chat_controller.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/model/commentObj.dart';
import 'package:geiger_edu/screens/lesson_category_selection_screen.dart';
import 'package:geiger_edu/screens/profile_screen.dart';
import 'package:geiger_edu/screens/settings_screen.dart';
import 'package:geiger_edu/widgets/indicator.dart';
import 'package:geiger_edu/widgets/navigation_container.dart';
import 'package:get/get.dart';

import 'comments_screen.dart';
import 'home_screen.dart';
import 'lesson_screen.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chatScreen';

  final ChatController chatController = Get.find();

  var bckColor = GlobalController.bckColor;
  var message = "";
  var lastMessageId = 0;
  var currentLessonId = "LPW001";
  var msgController = TextEditingController();
  var items = List<Comment>.generate(20, (i) => new Comment(
      id: "C00"+i.toString(),
      text:
      "Text: $i",
      dateTime: DateTime.now(),
      lessonId: "LPW001")).obs;
  var scrollController = ScrollController();

  void sendMessage(){
    if(message!="") {
      //add message
      Comment comment = new Comment(
          id: "C00"+(lastMessageId++).toString(),
          text: message,
          dateTime: DateTime.now(),
          lessonId: currentLessonId);
      items.add(comment);
      //clear text input
      msgController.clear();
      //scroll to the bottom of the list view
      scrollController.animateTo(
        scrollController.position.maxScrollExtent+50, //+height of new item
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),
        ),
        title: Text("Chat"),
        centerTitle: true,
        backgroundColor: bckColor,
      ),
      body: Obx (()=> Container(
          child: Column(children: [

              Expanded(
                child: Container(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(child: ListTile(
                        title: Text(items[index].text),subtitle: Text(items[index].dateTime.toString()),
                      )
                      );
                    },
                  )
                ),
              ),


              //** INPUT BAR **
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
                        width: context.width - 90,
                        child: TextField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,//Normal textInputField will be displayed
                            maxLines: 5,// when user presses enter it will adapt to it
                            controller: msgController,
                            decoration: InputDecoration(
                              hintText: "Write a comment...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        ),
                            onSubmitted:(text) { print(text); text=text+"\n"; }, onChanged:(text){ message = text;},),
                    ),
                GestureDetector(
                  onTap: () => { sendMessage() },
                  child:
                      Container(width: 20, height: 20,child:
                    Image.asset(
                      "assets/img/arrow_right.png",
                      width: 10,
                      color: Colors.blue,
                    )),
                )
                  ],
                ),
              )
          ])
      ),
    )
    );

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