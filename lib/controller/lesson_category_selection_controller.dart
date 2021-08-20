import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';

/// This class handles the business logic of the lesson category selection.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class LessonCategorySelectionController extends GetxController {
  final LessonController lessonController = Get.find();

  /// This method returns a map containing a count of the completed lessons of a
  /// specific category.
  ///
  /// @param lessonCategoryId The id of a lesson category.
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

  /// This method returns a list of lessons of a specific lesson category.
  ///
  /// @param lessonCategoryId The id of a lesson category.
  List<Lesson> getLessonListForCategory(String lessonCategoryId) {
    return DB
        .getLessonBox()
        .values
        .where((lesson) => lesson.lessonCategoryId == lessonCategoryId)
        .toList();
  }

  /// This method gets the lesson categories and returns a list of their values.
  List<LessonCategory> getLessonCategories() {
    return DB.getLessonCategoryBox().values.toList();
  }

  /// This method calculates the height for the lesson dropdown menu.
  double calcCompletedLessonIndicatorWidth(int currentValue, int maxValue,
      {int maxIndicatorSize = 100}) {
    if (maxValue * 4 >= maxIndicatorSize) {
      return maxIndicatorSize / maxValue;
    }
    return (maxIndicatorSize - maxValue * 4) / maxValue;
  }
}
