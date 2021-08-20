import 'package:flutter/material.dart';

/// LabeledSwitch Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class LabeledSwitch extends StatefulWidget{

  final String label;
  final bool isSelected;
  final String? isSelectedText;
  final String? isDeselectedText;
  final Function onChanged;

  LabeledSwitch({
    required this.label,
    this.isSelected = false,
    this.isSelectedText,
    this.isDeselectedText,
    required this.onChanged
  }) : super();

  _LabeledSwitchState createState() => _LabeledSwitchState(isSelected: isSelected);
}

class _LabeledSwitchState extends State<LabeledSwitch>{
  bool isSelected;

  _LabeledSwitchState({
    required this.isSelected
  })  : super ();

  @override
  Widget build(BuildContext context){
    return Row(children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text(widget.label, style: TextStyle(fontSize: 16)),
      ),
      Spacer(),
      Switch(
        value: this.isSelected,
        onChanged:(value) {
          widget.onChanged();
        },
        activeTrackColor: Colors.greenAccent,
        activeColor: Colors.green,
      ),
      if(this.isSelected)
        Text("ON", style: TextStyle(fontSize: 15))
      else
        Text("OFF", style: TextStyle(fontSize: 15))
    ]);
  }
}