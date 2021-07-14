import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geiger_edu/model/userObj.dart';
import 'package:geiger_edu/providers/boxes.dart';
import 'package:geiger_edu/route_generator.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geiger_edu/model/userObj.dart';
InAppLocalhostServer localhostServer = new InAppLocalhostServer();

void main() async {
  //** Hive DB Setup **
  WidgetsFlutterBinding.ensureInitialized();
  //Initializes Hive with a valid directory in the app files
  await Hive.initFlutter();

  //Register adapters
  Hive.registerAdapter(UserAdapter());

  Hive.deleteBoxFromDisk('users'); //TODO REMOVE IN PRODUCTION ENV

  bool exists = await Hive.boxExists('users');
  if(!exists){//if it doesnt exist
    await Hive.openBox<User>('users'); //user table

    //generate first box
    final box = Boxes.getUsers();
    //add default user to box
    User defaultUser = new User(userName: 'Turan', userImagePath: 'default', userScore: 20);
    //box.add(defaultUser);
    box.put("default", defaultUser);

    //printTest
    print(box.getAt(0)!.userName); //get value at index
    print(box.get("default")!.userScore);

    defaultUser.userName = 'Felix';
    defaultUser.save();

    print(box.getAt(0)!.userName);
  }

  //** LESSON-SERVER **
  localhostServer.start();

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