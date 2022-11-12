import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/calendar_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/molecules/button_molecule.dart';
import 'package:student_for_student_mobile/views/molecules/text_form_field_molecule.dart';

class CalendarBox extends StatefulWidget {
  final TextEditingController _calendarLinkController = TextEditingController();

  CalendarBox({Key? key}) : super(key: key);

  @override
  State<CalendarBox> createState() => _CalendarBoxState();
}

class _CalendarBoxState extends State<CalendarBox> {
  void _onSubmit(CalendarStore store) async{
    //print(widget._calendarLinkController.text);
    await store.linkCalendar(calendarLink: widget._calendarLinkController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarStore>(
        builder: (context, store, child) => Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      textAlign: TextAlign.center,
                      'Veuillez entrer le lien de votre calendrier Horairix',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldMolecule(
                      minLines: 1,
                      prefixiIcon: const Icon(Icons.link),
                      controller: widget._calendarLinkController,
                      label: 'Lien du calendrier',
                    ),
                    const SizedBox(height: 20),
                    ButtonMolecule(
                      label: 'VALIDER',
                      onPressed: () => _onSubmit(store),
                    ),
                  ],
                ),
              ),
            ));
  }
}