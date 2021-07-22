import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SlideContainer extends StatefulWidget {
  final String title;
  final String slidePath;

  SlideContainer({required this.title, required this.slidePath}) : super();

  _SlideContainerState createState() => _SlideContainerState();
}

class _SlideContainerState extends State<SlideContainer> {

  Widget build(BuildContext context) {
    return InAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse("http://localhost:8080/" + widget.slidePath)),
        initialOptions: InAppWebViewGroupOptions(),
        onWebViewCreated: (InAppWebViewController controller) {

        });
  }
}
