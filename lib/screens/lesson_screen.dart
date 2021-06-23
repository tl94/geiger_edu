import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'home_screen.dart';

class LessonScreen extends StatelessWidget {
  static const routeName = '/lessonscreen';

  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),
        ),
        title: Text("Password Safety"),
        centerTitle: true,
        backgroundColor: bckColor,
      ),
      body: Container(

        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30),
        child:

            //TODO REPLACE WITH CONTENT
            WebViewPlus(
              //javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                controller.loadUrl('assets/lesson/password/password_safety/eng/slide_0.html');
              },
            )

        ),
      );

  }
}