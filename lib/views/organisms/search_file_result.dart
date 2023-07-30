import 'dart:collection';

import "package:flutter/material.dart";
import 'package:student_for_student_mobile/models/files/file.dart';
import 'package:student_for_student_mobile/models/files/ui_option.dart';
import 'package:student_for_student_mobile/views/molecules/file_element.dart';
import 'package:student_for_student_mobile/views/organisms/option_container_organism.dart';

class ResultFileSearchDelegate extends StatefulWidget {
  ResultFileSearchDelegate(
      {Key? key,
      required List<ApplicationFile> source,
      required Set<UIOption> options,
      required this.onFileTap})
      : source = UnmodifiableListView(List.from(source)),
        options = UnmodifiableSetView(Set.from(options)),
        results = source,
        super(key: key);

  final UnmodifiableListView<ApplicationFile> source;
  final UnmodifiableSetView<UIOption> options;
  final List<ApplicationFile> results;
  final Function(ApplicationFile) onFileTap;

  @override
  State<ResultFileSearchDelegate> createState() =>
      _ResultFileSearchDelegateState();
}

class _ResultFileSearchDelegateState extends State<ResultFileSearchDelegate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OptionsContainerOrganism(
            options: widget.options,
            onOptionTap: (option) => _onOptionTap(option)),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.results.length,
            itemBuilder: (context, index) {
              final ApplicationFile uiFile = widget.results[index];
              return FileMolecule(
                  uiFile: uiFile, onFileTap: () => widget.onFileTap(uiFile));
            },
          ),
        ),
      ],
    );
  }

  _onOptionTap(UIOption tappedOption) {
    tappedOption.toggleSelectionState();

    if (!tappedOption.isSelected() &&
        widget.options.every((option) => !option.isSelected())) {
      setState(() {
        widget.results.clear();
        widget.results.addAll(widget.source);
      });
      return;
    }

    final List<ApplicationFile> result = widget.results.isEmpty
        ? widget.source.where((current) {
            var selected =
                widget.options.where((element) => element.isSelected());
            return selected.every((element) => element.tester(current));
          }).toList()
        : widget.results.where(tappedOption.tester).toList();

    setState(() {
      widget.results.clear();
      widget.results.addAll(result);
    });
  }
}
