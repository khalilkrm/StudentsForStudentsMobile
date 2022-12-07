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
  void _onSubmit({
    required CalendarStore store,
    required String token,
  }) async {
    await store.linkCalendar(
        calendarLink: widget._calendarLinkController.text, token: token);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CalendarStore, UserStore>(
        builder: (context, calendarStore, userStore, child) => Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 30.0),
                          child: Text(
                            'AFFICHAGE DE VOTRE CALENDRIER',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          'Pour afficher votre calendrier horiairix, veuillez entrer son lien ci-dessous',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
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
                      onPressed: () => _onSubmit(
                          store: calendarStore, token: userStore.user.token),
                    ),
                  ],
                ),
              ),
            ));
  }
}
