import 'package:flutter/material.dart';
import 'package:geiger_edu/globals.dart';

class NavigationContainer extends StatefulWidget{

  @override
  final String passedRoute;
  final String text;
  final String imagePath;

  NavigationContainer({required String this.passedRoute, required String this.text, required this.imagePath}) : super();

  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer>{

  @override
  Widget build(BuildContext context){
    return Container(
      height: 80,
      child: new GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, widget.passedRoute, arguments: {'title': widget.text},
          );
        },

        child:Container(
          padding: EdgeInsets.all(20.0),
          //margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
          ),

          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(widget.imagePath, height: 40, key: UniqueKey(), ),
                SizedBox(width: 15),
                Text(widget.text,
                  style:TextStyle(
                    fontSize:20.0,
                    fontWeight:FontWeight.w500,
                    color: txtColor,
                    fontFamily:"Fontin",
                  ),
                ),
          Expanded(child: SizedBox(width: 15),),
          Image.asset("assets/img/arrow_right.png", height: 20, key: UniqueKey(), )
              ]

          )
        ),
      ),
    );
  }
}