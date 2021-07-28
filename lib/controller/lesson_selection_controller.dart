import 'package:geiger_edu/model/lessonObj.dart';
import 'package:get/get.dart';

class LessonSelectionController extends GetxController {

  late String categoryTitle;
  late List<Lesson> lessons;

  List<Lesson> getLessons() {
    return lessons;
  }

  void setLessons(List<Lesson> lessons) {
    this.lessons = lessons;
  }

  String getCategoryTitle() {
    return categoryTitle;
  }

  void setCategoryTitle(String categoryTitle) {
    this.categoryTitle = categoryTitle;
  }

}