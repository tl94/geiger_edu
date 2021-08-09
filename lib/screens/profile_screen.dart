import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/controller/profile_controller.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/image_selector.dart';
import 'package:geiger_edu/widgets/labeled_text_field.dart';
import 'package:get/get.dart';
import 'package:hive_listener/hive_listener.dart';

import '../globals.dart';
import 'home_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profilescreen';

  final GlobalController globalController = Get.find();
  final ProfileController profileController = Get.find();

  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879
  static const borderColor = const Color(0xff0085ff);

  @override
  Widget build(BuildContext context) {
    var defaultUser = globalController.defaultUser;
    var userImg = globalController.userImg;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("ProfileTitle".tr),
        centerTitle: true,
        backgroundColor: ProfileScreen.bckColor,
      ),
      body: Container(
          child: SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(children: [
                    Stack(
                        alignment: Alignment.center,
                        textDirection: TextDirection.rtl,
                        fit: StackFit.passthrough,
                        overflow: Overflow.visible,
                        clipBehavior: Clip.hardEdge,
                        children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                //** USER IMAGE **
                                SizedBox(height: 40),
                                GestureDetector(
                                    onTap: () => profileController
                                        .displayImageSelector(),
                                    child: Column(children: <Widget>[
                                      Container(
                                          height: 150,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color:
                                                    ProfileScreen.borderColor,
                                                width: 3,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: ClipRect(
                                              child: HiveListener(
                                            box: DB.getUserBox(),
                                            keys: [defaultUser],
                                            // keys is optional to specify listening value changes
                                            builder: (box) {
                                              return Image.asset(
                                                  DB
                                                      .getDefaultUser()!
                                                      .userImagePath
                                                      .toString(),
                                                  fit: BoxFit.fitHeight);
                                            },
                                          ))),
                                      Text("ProfileChangeAvatar".tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20,
                                              color: ProfileScreen.borderColor))
                                    ])),
                                SizedBox(height: 40),

                                //** USER NAME INPUT **
                                HiveListener(
                                  box: DB.getUserBox(),
                                  keys: [defaultUser],
                                  // keys is optional to specify listening value changes
                                  builder: (box) {
                                    return LabeledTextField(
                                        icon: userImg,
                                        label: "ProfileUserName".tr,
                                        text: DB
                                            .getUserBox()
                                            .get('default')!
                                            .userName,
                                        onSubmitted: (text) {
                                          profileController.saveNewUserName(text);
                                        });
                                  },
                                ),
                                SizedBox(height: 80),

                                //** USER SCORE **
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "ProfileLearnScore".tr,
                                        style: TextStyle(fontSize: 25),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset(
                                              "assets/img/score_icon.png",
                                              height: 40,
                                              key: UniqueKey(),
                                            ),
                                            HiveListener(
                                              box: DB.getUserBox(),
                                              keys: [defaultUser],
                                              // keys is optional to specify listening value changes
                                              builder: (box) {
                                                return Text(
                                                  DB
                                                      .getDefaultUser()!
                                                      .userScore
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 40),
                                                );
                                              },
                                            )
                                          ]),
                                      SizedBox(height: 40),
                                      Text(
                                        "ProfileText1".tr,
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ]),

                                //** USER PROGRESS EXPORT **
                                SizedBox(height: 40),
                                OutlinedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      side: MaterialStateProperty.resolveWith<
                                              BorderSide>(
                                          (Set<MaterialState> states) {
                                        final Color color = states
                                                .contains(MaterialState.pressed)
                                            ? Colors.green
                                            //: Colors.blue;
                                            : Colors.grey; //button is disabled
                                        return BorderSide(
                                            color: color, width: 2);
                                      })),
                                  onPressed: null,
                                  child: Text('ProfileExportLearningProgress'.tr,
                                      style: TextStyle(fontSize: 20)),
                                ),
                                SizedBox(height: 40),
                              ]),
                          Obx(() {
                            if (profileController.isVisible.value) {
                              return ImageSelector();
                            } else
                              return SizedBox.shrink();
                          })
                        ])
                  ])))),
    );
  }
}
