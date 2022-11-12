import 'package:student_for_student_mobile/models/request/CourseModel.dart';

class CourseModelList {
  final List<CourseModel> courses;

  CourseModelList({required this.courses});

  factory CourseModelList.fromJson(List<dynamic> json) {
    List<CourseModel> courses = <CourseModel>[];
    courses = json.map((i) => CourseModel.fromJson(i)).toList();

    return CourseModelList(
      courses: courses,
    );
  }
}