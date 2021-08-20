import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/profile_controller.dart';
import 'package:get/get.dart';

/// ImageSelector Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class ImageSelector extends StatelessWidget {
  final ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Visibility(
        child: Container(
            //TODO: MAKE HEIGHT DYNAMIC
            height: 460,//MediaQuery.of(context).size.height - 50,
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
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: GridView.count(
                crossAxisCount: 3,
                children: profileController.getImageSelection(context)
            )
        )
    );
  }
}
