import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/comments_controller.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/navigation_container.dart';
import 'package:get/get.dart';

class CommentsScreen extends StatelessWidget {
  static const routeName = '/commentsScreen';

  final CommentsController commentsController = Get.find();

  @override
  Widget build(BuildContext context) {
    var bckColor = GlobalController.bckColor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(
              context, HomeScreen.routeName),
        ),
        title: Text("My Comments"),
        centerTitle: true,
        backgroundColor: bckColor,
      ),
      //TODO: IF NO COMMENTS ARE AVAILABLE WRITE "NO COMMENTS"
      body: Obx(() => ListView.builder(
        itemCount: commentsController.items.length,
        itemBuilder: (context, index) {
          final item = commentsController.items[index];
          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            direction: DismissDirection.endToStart,
            key: Key(item.text),
            background: Container(
              color: Colors.green,
              child: Icon(Icons.check),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Container(
                child: Align(
                    child: Image.asset("assets/img/delete_icon.png", width:20),
                    alignment: Alignment.centerRight
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 15, 0)),
            ),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from the data source.
                //commentsController.items.removeAt(index);
                commentsController.deleteComment(item.id,index);
              //commentsController.items
              // Then show a snackbar.
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(item.text+' dismissed')));
            },
            child: Container(
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    Colors.blueGrey,
                    width: .5,
                  )
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Topic: "+item.lessonId),
                    Container(width: 80,child:
                      Text(item.text)
                    )
                  ],),
                  Expanded(child: SizedBox(width: 10,)),
                  Image.asset(
                    "assets/img/arrow_right.png",
                    height: 20,
                    key: UniqueKey(),
                  ),
                  SizedBox(width: 20)
                ])
            )
          );
        },
      ))
    );
  }
}