import 'package:flutter/material.dart';
import 'package:geiger_edu/globals.dart';

class NavigationContainer extends StatefulWidget{

  final String passedRoute;
  final String text;
  final String imagePath;

  final int currentValue;
  final int maxValue;

  NavigationContainer({
    required this.passedRoute,
    required this.text,
    required this.imagePath,
    this.currentValue = 99,
    this.maxValue = 99
  }) : super();

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

            Expanded(child: SizedBox(width: 1),),
                if(widget.currentValue != 99)
            Column(children: [
              Text(widget.currentValue.toString()+"/"+widget.maxValue.toString(), style:TextStyle(fontSize:20.0)),

              Flexible(
                child:  new ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.currentValue,
                itemBuilder: (BuildContext context, int i) {
                return Container(
                  margin: EdgeInsets.fromLTRB(4,0,0,0),
                  width:100/widget.maxValue,
                  height: 1,
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(2))
                );
                })
              ),
              Flexible(
                child:  new ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.maxValue-widget.currentValue,
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                      margin: EdgeInsets.fromLTRB(4,0,0,0),
                      width:100/widget.maxValue,
                      height: 1,
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(2))
                  );

                      })
              ),
            ],),
          Expanded(child: SizedBox(width: 1),),
          Image.asset("assets/img/arrow_right.png", height: 20, key: UniqueKey(), )
              ]

          )
        ),
      ),
    );
  }
}