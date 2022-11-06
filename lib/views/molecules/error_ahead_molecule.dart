import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorAheadMolecule extends StatelessWidget {
  final List<String> _errors;

  const ErrorAheadMolecule({required List<String> errors, super.key})
      : _errors = errors;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          border: Border.all(color: Colors.red, width: 2.0),
          color: Colors.red.withOpacity(0.05),
        ),
        child: Row(children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 25.0),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: _errors.length,
              itemBuilder: (context, index) => Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 5.0,
                children: [
                  Text(_errors[index],
                      style: GoogleFonts.roboto(color: Colors.red))
                ],
              ),
            ),
          ),
        ]));
  }
}
