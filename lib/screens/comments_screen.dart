import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/widgets/NavigationContainer.dart';

class CommentsScreen extends StatelessWidget {
  static const routeName = '/commentsScreen';
  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new Container(),
        title: Text("My Comments"),
        centerTitle: true,
        backgroundColor: bckColor,
      ),
      body: Container(
          child: SingleChildScrollView(
            child:Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                                  NavigationContainer(
                                        imagePath: "assets/img/settings_icon.png",
                                        text: "HOME",
                                        passedRoute: HomeScreen.routeName
                                      )
                                  ]
                            )
                        )

                    )
            )
          );
  }
}