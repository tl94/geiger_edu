import 'package:geiger_edu/model/lessonObj.dart';
import 'package:get/get.dart';

/// This class handles the business logic of the lesson selection.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class LessonSelectionController extends GetxController {

  late String categoryTitle;
  late List<Lesson> lessons;

  /// This method get the lessons list.
  List<Lesson> getLessons() {
    return lessons;
  }

  /// This method populates the lessons list.
  ///
  /// @param lessons The list of lessons to be set
  void setLessons(List<Lesson> lessons) {
    this.lessons = lessons;
  }

  /// This method gets the category title.
  String getCategoryTitle() {
    return categoryTitle;
  }

  /// This method set the category title.
  ///
  /// @param categoryTitle The title to be set
  void setCategoryTitle(String categoryTitle) {
    this.categoryTitle = categoryTitle;
  }
}