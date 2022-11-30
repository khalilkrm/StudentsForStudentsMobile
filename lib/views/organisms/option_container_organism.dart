import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/models/files/ui_option.dart';
import 'package:student_for_student_mobile/views/organisms/option_organism.dart';

class OptionsContainerOrganism extends StatelessWidget {
  const OptionsContainerOrganism({
    Key? key,
    required this.options,
    required this.onOptionTap,
  }) : super(key: key);

  final Set<UIOption> options;
  final void Function(UIOption) onOptionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Container(
            decoration:
                BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
            child: ListView(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: _buildChipChoices(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChipChoices() {
    return options
        .map((chips) {
          return OptionOrganism(chips: chips, onTap: () => onOptionTap(chips));
        })
        .toList()
        .cast<Widget>();
  }
}
