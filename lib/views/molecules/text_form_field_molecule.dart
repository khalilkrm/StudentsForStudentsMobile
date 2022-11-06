import 'package:flutter/material.dart';

class TextFormFieldMolecule extends StatefulWidget {
  final TextEditingController _controller;
  final Widget? _prefixIcon;
  final bool _isForPassword;
  final String _label;
  final String? _errorText;

  const TextFormFieldMolecule(
      {required TextEditingController controller,
      required String label,
      Widget? prefixiIcon,
      String? errorText,
      bool isForPassword = false,
      super.key})
      : _controller = controller,
        _prefixIcon = prefixiIcon,
        _isForPassword = isForPassword,
        _label = label,
        _errorText = errorText;

  @override
  State<TextFormFieldMolecule> createState() => _TextFormFieldMoleculeState();
}

class _TextFormFieldMoleculeState extends State<TextFormFieldMolecule> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget._label,
        errorText: widget._errorText,
        prefixIcon: widget._prefixIcon ?? const SizedBox(),
        suffixIcon: widget._isForPassword
            ? InkWell(
                onTap: () => setState(() => _obscureText = !_obscureText),
                child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
              )
            : const SizedBox(),
      ),
    );
  }
}
