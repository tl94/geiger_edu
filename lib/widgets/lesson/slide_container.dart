import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// SlideContainer Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class SlideContainer extends StatelessWidget {
  final String slidePath;

  SlideContainer({required this.slidePath}) : super();

  Widget build(BuildContext context) {
    return InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse("http://localhost:8080/" + slidePath)),
        initialOptions: InAppWebViewGroupOptions(),
        gestureRecognizers: Set()
          ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer())),
        onWebViewCreated: (InAppWebViewController controller) {});
  }
}
