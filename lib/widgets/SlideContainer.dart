import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class SlideContainer extends StatelessWidget {

  final String slidePath;

  SlideContainer({required this.slidePath}) : super();

  // _SlideContainerState createState() => _SlideContainerState();

  Widget build(BuildContext context) {
    return WebViewPlus(
      //javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        controller.loadUrl(slidePath);
      },
    );
  }
}
/*

class _SlideContainerState extends State<SlideContainer> {



}*/
