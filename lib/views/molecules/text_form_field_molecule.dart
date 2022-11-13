import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldMolecule extends StatefulWidget {
  final TextEditingController _controller;
  final Widget? _prefixIcon;
  final bool _type;
  final bool _isForPassword;
  final String _label;
  final int _minLines;
  final String? _errorText;

  const TextFormFieldMolecule(
      {required TextEditingController controller,
      required String label,
      required int minLines,
      Widget? prefixiIcon,
      bool type = false,
      String? errorText,
      bool isForPassword = false,
      super.key})
      : _controller = controller,
        _prefixIcon = prefixiIcon,
        _type = type,
        _isForPassword = isForPassword,
        _label = label,
        _minLines = minLines,
        _errorText = errorText;

  @override
  State<TextFormFieldMolecule> createState() => _TextFormFieldMoleculeState();
}

class _TextFormFieldMoleculeState extends State<TextFormFieldMolecule> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: widget._minLines,
      maxLines: null,
      controller: widget._controller,
      obscureText: _obscureText,
      inputFormatters: widget._type
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        labelText: widget._label,
        errorText: widget._errorText,
        prefixIcon: widget._prefixIcon ?? const SizedBox(),
        suffixIcon: widget._isForPassword
            ? InkWell(
                onTap: () => setState(() => _obscureText = !_obscureText),
                child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility),
              )
            : const SizedBox(),
      ),
    );
  }
}
