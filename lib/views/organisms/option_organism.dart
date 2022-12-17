import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/models/files/ui_option.dart';

class OptionOrganism extends StatelessWidget {
  const OptionOrganism({
    Key? key,
    required this.chips,
    required this.onTap,
  }) : super(key: key);

  final UIOption chips;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.all(5),
        child: ChoiceChip(
          padding: const EdgeInsets.all(8),
          backgroundColor: const Color(0xffe4e4e4),
          label: Text(chips.name),
          selected: chips.isSelected(),
          onSelected: (newBoolValue) => onTap(),
        ),
      ),
    );
  }
}
