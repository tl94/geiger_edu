import 'package:flutter/material.dart';
import 'package:geiger_edu/globals.dart' as globals;

class Indicator extends StatefulWidget {

  final double height;

  Indicator({required this.height}) : super();

  _IndicatorState createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {

  late int completedLessons;
  late int maxLessons = 0;
  late double percentage = 0;
  late String label = '';

  @override
  void initState() {
    super.initState();
    completedLessons = globals.completedLessons;
    maxLessons = globals.maxLessons;
    percentage = (completedLessons/maxLessons)*100;

    if(percentage<0.25 && percentage>0)
      label = 'low';
    if(percentage<0.5 && percentage>0.25)
      label = 'medium';
    if(percentage<0.75 && percentage>0.5)
      label = 'good';
    if(percentage<1 && percentage>0.75)
      label = 'excellent';
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
        Text("Your Progress", style: TextStyle(fontSize: 20, color: globals.txtColor)),
        SizedBox(height: 10),
        Container(width: widget.height, child: Stack(alignment: Alignment.center,children: [
          Align(alignment: Alignment(0,-.4),child: Text((percentage*100).toStringAsFixed(0)+"%", style: TextStyle(fontSize: 20, color: globals.txtColor))),
          new RotationTransition(
            turns: new AlwaysStoppedAnimation(percentage*0.49), //0.49 is the value for the indicator to reach the other side
            //0.12 //0.24 //0.37 //0.49
            child: new Image.asset("assets/img/indicator/indicator.png", width: 150)
          ),
          Image.asset("assets/img/indicator/tiles.png", width: 150),
          Text(label)
        ])),

    ]);

  }
}
