import 'package:flutter/material.dart';
import 'package:geiger_edu/route_generator.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    title: 'GEIGER mobile learning',
    theme: ThemeData(primaryColor: Color(0xFF5dbcd2)),
    home: MyApp(),
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}

class MyApp extends StatefulWidget{
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  void initState(){
    super.initState();
    Future.delayed(
        Duration(seconds: 3),
            (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));}
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              height: 300,
              child: Image.asset("assets/logo/test.jpg", fit: BoxFit.fitHeight))
      ),
    );
  }
}