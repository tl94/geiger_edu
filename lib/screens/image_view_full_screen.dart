import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:get/get.dart';

/// ImageViewFullScreen Widget.
/// Widget to see an image on the whole screen.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class ImageViewFullScreen extends StatelessWidget {
  static const routeName = '/imageViewFullScreen';

  final GlobalController globalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: Image.file(File(globalController.selectedImage))));
  }
}
