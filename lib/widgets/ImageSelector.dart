import 'package:flutter/material.dart';

class ImageSelector extends StatefulWidget{

  final int crossAxisCount;
  final List<String> imagePaths;
  final Function onTap;

  ImageSelector({required this.crossAxisCount, required this.imagePaths, required this.onTap}) : super();

  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector>{

  //TODO: COMMENT CODE
  getList(){
    List<Widget> gst = <Widget>[];
    for(var i in widget.imagePaths){
      GestureDetector g = new GestureDetector(onTap: ()=>widget.onTap(i), child: Image.asset(i));
      gst.add(g);
    }
    return gst;
  }

  @override
  Widget build(BuildContext context){
    return Visibility(child: Container(height: 440,
        width: MediaQuery
            .of(context)
            .size
            .width - 50,
        color: Colors.red,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: GridView.count(crossAxisCount: widget.crossAxisCount, children:

          getList()

        )
    ));
  }
}