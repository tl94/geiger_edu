import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:path_provider/path_provider.dart';

// import 'package:webview_flutter/webview_flutter.dart';

import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_html/flutter_html.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GEIGER EDU Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      home: FirstRoute(title: 'GEIGER EDU Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FirstRoute extends StatelessWidget {
  FirstRoute({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Start Lesson'),
          onPressed: () {
            // Navigate to second route when tapped.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Lesson()),
            );
          },
        ),
      ),
    );
  }
}

class Lesson extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LessonState();
}

class LessonState extends State<Lesson> {
  // final Future<String> html = LessonStorage._readHtmlFile();
  late WebViewPlusController _controller;

  Future<File> _localFile() async {
    // final path = await _localPath;
    debugPrint("HELLO? 2");
    final file =
        File('assets/lesson/password/password_safety/eng/slide_0.html');
    debugPrint("checking if file exists");

    debugPrint("AYY");
    return file;
  }

  Future<String> _readHtmlFile() async {
    debugPrint("HELLO?");
    try {
      debugPrint("TRYING");
      // final file = await _localFile();
      debugPrint("FOUND FILE");
      // Read the file
      final contents = await rootBundle.loadString(
          'assets/lesson/password/password_safety/eng/slide_0.html');
      // debugPrint(file.toString());
      debugPrint(contents.toString());
      debugPrint("loading from URL");
      _controller.loadUrl(Uri.dataFromString(contents,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString());
      // _controller.loadString('<html><body><img src="assets/lesson/password/password_safety/eng/img/img_01.png" alt="alternative text"></body></html>');
      return contents;
    } catch (e) {
      debugPrint("$e");
      // If encountering an error, return 0
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(File('assets/lesson/password/password_safety/eng/slide_0.html')
        .existsSync()
        .toString());
    debugPrint(File('assets/lesson/password/password_safety/eng/img/img_01.png')
        .existsSync()
        .toString());

    debugPrint("BEFORE");
    return Scaffold(
        appBar: AppBar(
          title: Text("Lesson"),
        ),
        body: //Image.asset('assets/lesson/password/password_safety/eng/img/img_01.png')
        WebViewPlus(
          //javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            controller.loadUrl('assets/lesson/password/password_safety/eng/slide_0.html');
          },
        )
        /*FutureBuilder<String>(
          future: html,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[Html(data: snapshot.data)];
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }

            debugPrint("PRINT OPLS");
            return Center(
                child: Column(
                children: children
            ));
          }),*/
        );
  }
}

class LessonStorage {
  /* Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }*/
}
