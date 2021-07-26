import 'package:flutter/material.dart';

class LabeledTextField extends StatefulWidget{

  final String icon;
  final String label;
  final String text;
  final Function onSubmitted; //passed callback function

  LabeledTextField({required this.icon, required this.label, required this.text, required this.onSubmitted}) : super();

  _LabeledTextFieldState createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField>{
  @override
  Widget build(BuildContext context){
    return Column(  children: <Widget>[
      Row(//crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(widget.icon, height: 30, key: UniqueKey(), ),
            SizedBox(width: 10),
            Text(widget.label, style: TextStyle(fontSize: 20)),
            SizedBox(width: 60),
            Flexible(child: SizedBox( width: 200, child: TextField(
                //TODO: BUG - click on text field causes many redraws of selection screen
                controller: TextEditingController(text: widget.text),
                decoration: InputDecoration(
                  //hintText: 'username',
                  //labelText: 'username'
                ),
                maxLines: 1,
                maxLength: 32,
                onSubmitted:(text) { widget.onSubmitted(text); })
            ))
          ]),]);
  }
}