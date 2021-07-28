import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/profile_controller.dart';
import 'package:get/get.dart';

class ImageSelector extends StatelessWidget {
  ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Visibility(
        child: Container(
            height: 440,
            width: MediaQuery.of(context).size.width - 50,
            color: Colors.red,
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            child: GridView.count(
                crossAxisCount: 3,
                children: profileController.getImageSelection())));
  }
}
