import 'package:flutter/material.dart';

class LabeledSwitch extends StatefulWidget{

  final String label;
  bool isSelected = false;
  final String? isSelectedText;
  final String? isDeselectedText;
  final Function onChanged;

  LabeledSwitch({
    required this.label,
    required this.isSelected,
    this.isSelectedText,
    this.isDeselectedText,
    required this.onChanged
  }) : super();

  _LabeledSwitchState createState() => _LabeledSwitchState();
}

class _LabeledSwitchState extends State<LabeledSwitch>{
  @override
  Widget build(BuildContext context){
    return Row(children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text(widget.label, style: TextStyle(fontSize: 16)),
      ),
      Spacer(),
      Switch(
        value: widget.isSelected,
        onChanged:(value) {
          widget.onChanged();
        },
        activeTrackColor: Colors.greenAccent,
        activeColor: Colors.green,
      ),
      if(widget.isSelected)
        Text("ON", style: TextStyle(fontSize: 15))
      else
        Text("OFF", style: TextStyle(fontSize: 15))
    ]);
  }
}