import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geiger_edu/widgets/ImageSelector.dart';
import 'package:geiger_edu/widgets/LabeledTextField.dart';
import 'package:geiger_edu/widgets/NavigationContainer.dart';

import 'package:flutter/foundation.dart';

import 'home_screen.dart';
import '../globals.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profilescreen';

  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879
  static const borderColor = const Color(0xff0085ff);
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {

    const List<String> _imagePaths = ["assets/img/profile/default.png",
                                      "assets/img/profile/user-01.png",
                                      "assets/img/profile/user-02.png",
                                      "assets/img/profile/user-03.png",
                                      "assets/img/profile/user-05.png",
                                      "assets/img/profile/user-06.png",
                                      "assets/img/profile/user-07.png",
                                      "assets/img/profile/user-08.png",
                                      "assets/img/profile/user-09.png",
                                      "assets/img/profile/user-04.png",
                                      "assets/img/profile/user-10.png"];

    final VoidCallback onEditingComplete;
    bool showImgSelection = false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),
        ),
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: bckColor,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Stack(
                  alignment: Alignment.center,
                  textDirection: TextDirection.rtl,
                  fit: StackFit.passthrough,
                  overflow: Overflow.visible,
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                      //** USER IMAGE **
                          GestureDetector(
                              onTap: () {
                                _isVisible = true;
                                print("Image CLICKED");
                              }, // handle your image tap here
                              child:Column( children: <Widget>[
                              Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: borderColor,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0)
                                ),
                          child:ClipRect(
                                    child:Image.asset("assets/img/profile/default.png", fit: BoxFit.fitHeight))
                            ),
                            Text("Change Avatar",
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: borderColor))
                          ])),
                          SizedBox(height: 40),

                      //** USER NAME INPUT **
                          LabeledTextField(icon:userImg, label: "Username", text: userName, onSubmitted: (text){ userName = text; } ),
                    ]
                    ),

                    ImageSelector(crossAxisCount: 3, imagePaths: _imagePaths, onTap: (imagePath){ print(imagePath); }),

            Container(
              //TODO: LEARN SCORE
            ),
            Container(
              //TODO: LEARN PROGRESS - API export
            )
          ],
        ),

      ),
    );
  }
}