import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/providers/boxes.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/ImageSelector.dart';
import 'package:geiger_edu/widgets/LabeledTextField.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_listener/hive_listener.dart';

import 'home_screen.dart';
import '../globals.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profilescreen';

  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879
  static const borderColor = const Color(0xff0085ff);

  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  bool _isVisible = false;
  final List<String> _imagePaths = ["assets/img/profile/default.png",
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

  displaySelection(String s){
    print(s);
    setState(() {
      _isVisible = !_isVisible;
      if(currentImage != s){
        currentImage = s;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),
        ),
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: ProfileScreen.bckColor,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: SingleChildScrollView(
    child:Column(
          children: [Stack(
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
                  SizedBox(height: 40),
                  GestureDetector(
                      onTap: ()=>displaySelection(currentImage),
                      child:Column( children: <Widget>[
                        Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: ProfileScreen.borderColor,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            child:ClipRect(
                                child:Image.asset(currentImage, fit: BoxFit.fitHeight))
                        ),
                        Text("Change Avatar",
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: ProfileScreen.borderColor))
                      ])),
                  SizedBox(height: 40),

                  //** USER NAME INPUT **
                  HiveListener(
                    box: userBox,
                    keys: [
                      'default'
                    ], // keys is optional to specify listening value changes
                    builder: (box) {
                      return LabeledTextField(
                          icon: userImg,
                          label: "Username",
                          text: userBox.get('default')!.userName,
                          onSubmitted: (text){ DB.editDefaultUser(text, null, null);}
                          )
                      ;
                    },
                  ),

                  SizedBox(height: 80),

                  //** USER SCORE **
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Lesson Score", style: TextStyle(fontSize: 30),),
                        SizedBox(height: 20),
                        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Image.asset("assets/img/score_icon.png", height: 40, key: UniqueKey(), ),
                          Text(lessonScore.toString(), style: TextStyle(fontSize: 40),)
                        ]),
                        SizedBox(height: 40),
                        Text("The Lernscore can help you indentify other peoples overall progress and knowledge base on the discussion-plattform. Share your score with your co-workers to see who is the furthest.                            Improve your score by finishing lessons.", style: TextStyle(fontSize: 20),)
                  ]),

                  //** USER PROGRESS EXPORT **
                  SizedBox(height: 40),
                  OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)))    ,
                      side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) {
                            final Color color = states.contains(MaterialState.pressed)
                                ? Colors.green
                                //: Colors.blue;
                                : Colors.grey; //button is disabled
                            return BorderSide(color: color, width: 2);
                          }
                      )
                    ),
                    onPressed: null,
                    child: Text('Export Learning Progress',style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(height: 40),
                ]
            ),
            if(_isVisible)
              ImageSelector(crossAxisCount: 3,
                  imagePaths: _imagePaths,
                  onTap: displaySelection
              )

            ]),

          ],
        ),
      )
      ),
    );
  }
}