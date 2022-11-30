import 'package:student_for_student_mobile/models/files/file.dart';

class Files {
  final List<File> files;

  Files({required this.files});

  static Files fromJson(Map<String, dynamic> json) {
    List<File> files = [];
    List<dynamic> content = json['content'];

    for (var file in content) {
      files.add(File.fromJson(content: file));
    }

    return Files(files: files);
  }
}
