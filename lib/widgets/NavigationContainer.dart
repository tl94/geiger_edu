import 'package:flutter/material.dart';

class NavigationContainer extends StatefulWidget{

  @override
  final String passedRoute;
  final String text;
  final IconData icon;

  NavigationContainer({required String this.passedRoute, required String this.text, required this.icon}) : super();

  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer>{

  final bckColor = const Color(0xFF5dbcd2);
  final txtColor = const Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context){
    return Expanded(
      child: new GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, widget.passedRoute, arguments: {'title': widget.text},
          );
        },

        child:Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(color: bckColor, borderRadius: BorderRadius.circular(5.0)),
          child: Row(
              children: <Widget>[
                Icon(widget.icon, size: 40, color: txtColor),
                Text(widget.text,
                  style:TextStyle(
                    fontSize:20.0,
                    fontWeight:FontWeight.bold,
                    color: txtColor,
                    fontFamily:"Fontin",
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}