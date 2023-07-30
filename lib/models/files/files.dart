import 'package:student_for_student_mobile/models/files/file.dart';

class Files {
  final List<ApplicationFile> files;

  Files({required this.files});

  static Files fromJson(Map<String, dynamic> json) {
    List<ApplicationFile> files = [];
    List<dynamic> content = json['content'];

    for (var file in content) {
      files.add(ApplicationFile.fromJson(content: file));
    }

    return Files(files: files);
  }
}
