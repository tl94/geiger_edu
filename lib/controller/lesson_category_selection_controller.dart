import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';

class LessonCategorySelectionController extends GetxController {
  final LessonController lessonController = Get.find();

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

  //** LessonDropdown **

  double calcCompletedLessonIndicatorWidth(int currentValue, int maxValue,
      {int maxIndicatorSize = 100}) {
    if (maxValue * 4 >= maxIndicatorSize) {
      return maxIndicatorSize / maxValue;
    }
    return (maxIndicatorSize - maxValue * 4) / maxValue;
  }
}
