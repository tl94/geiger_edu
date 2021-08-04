import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/comments_controller.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/screens/home_screen.dart';
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
      body: Obx(() => ListView.builder(
        itemCount: commentsController.items.length,
        itemBuilder: (context, index) {
          final item = commentsController.items[index];
          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            direction: DismissDirection.endToStart,
            key: Key(item),
            background: Container(
              color: Colors.green,
              child: Icon(Icons.check),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Icon(Icons.cancel),
            ),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from the data source.

                commentsController.items.removeAt(index);

              // Then show a snackbar.
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$item dismissed')));
            },
            child: ListTile(
              title: Text(item),
            ),
          );
        },
      ))
    );
  }
}