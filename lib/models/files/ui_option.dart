import 'package:student_for_student_mobile/models/files/file.dart';

class UIOption {
  final String name;
  bool _isSelected = false;
  final int id;
  final bool Function(File) tester;

  UIOption({required this.name, required this.id, required this.tester});

  @override
  int get hashCode => name.hashCode + id.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UIOption && other.name == name && other.id == id;
  }

  toggleSelectionState() {
    _isSelected = !_isSelected;
  }

  isSelected() {
    return _isSelected;
  }
}
