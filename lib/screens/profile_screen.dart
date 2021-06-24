import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geiger_edu/widgets/NavigationContainer.dart';

import 'package:flutter/foundation.dart';

import 'home_screen.dart';
import '../globals.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profilescreen';

  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879
  static const borderColor = const Color(0xff0085ff);

  @override
  Widget build(BuildContext context) {

    final VoidCallback onEditingComplete;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

        //** USER IMAGE **
            Column( children: <Widget>[
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
                  child: ClipRect(
                      child:Image.asset("assets/img/profile/default.png", fit: BoxFit.fitHeight))
              ),
              Text("Change Avatar",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: borderColor))
            ]),
            SizedBox(height: 40),
        //** USER NAME INPUT **
            Column(  children: <Widget>[
                  Row(//crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                    Image.asset("assets/img/profile/user_icon.png", height: 30 ),
                    SizedBox(width: 10),
                    Text("Username", style: TextStyle(fontSize: 20),),
                    SizedBox(width: 60),
                    new Flexible(child: SizedBox( width: 200, child: TextField(
                      controller: new TextEditingController(text: userName),
                      decoration: InputDecoration(
                        //hintText: 'username',
                        //labelText: 'username'
                      ),
                      maxLines: 1,
                      //maxLength: 14,
                      onSubmitted:(text) { userName = text;  })
                    ))
            ]),]),

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