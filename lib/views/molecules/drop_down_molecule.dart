import 'package:flutter/material.dart';

class DropDownMolecule extends StatefulWidget {
  final String label;
  final dynamic value;
  final void Function(dynamic value) onChanged;
  final List<DropdownMenuItem<dynamic>> items;

  const DropDownMolecule({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DropDownMoleculeState();
}

class _DropDownMoleculeState extends State<DropDownMolecule> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      hint: Text(widget.label),
      value: widget.value,
      onChanged: widget.onChanged,
      items: widget.items,
    );
  }
}