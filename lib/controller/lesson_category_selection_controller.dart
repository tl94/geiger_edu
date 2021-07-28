import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/screens/lesson_category_selection_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class LessonCategorySelectionController extends GetxController {

  final LessonController lessonController = Get.find();

  void setLessonCategory() {

  }

  //** LessonDropdown state **
  RxBool isOpened = false.obs;

  void toggleLessonDropdown() {
    isOpened(!isOpened.value);
  }


  Map<String, int> getCompletedLessonsForCategory(String lessonCategoryId) {
    Map<String, int> result = {};
    int completedCount = 0;

    var lessonList = getLessonListForCategory(lessonCategoryId);

    for (var lesson in lessonList) {
      if (lesson.completed) completedCount++;
    }
    result["completed"] = completedCount;
    result["allLessons"] = lessonList.length;
    return result;
  }

  List<Lesson> getLessonListForCategory(String lessonCategoryId) {
    return DB
        .getLessonBox()
        .values
        .where((lesson) => lesson.lessonCategoryId == lessonCategoryId)
        .toList();
  }

  List<LessonCategory> getLessonCategories() {
    return DB.getLessonCategoryBox().values.toList();
  }


  double calcCompletedLessonIndicatorWidth(int currentValue, int maxValue,
      {int maxIndicatorSize = 100}) {
    if (maxValue * 4 >= maxIndicatorSize) {
      return maxIndicatorSize / maxValue;
    }
    return (maxIndicatorSize - maxValue * 4) / maxValue;
  }
}