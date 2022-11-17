import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/views/molecules/button_molecule.dart';

class RequestAccordion extends StatelessWidget {
  final String name;
  final String description;
  final String author;
  final String date;
  final void Function() onAccept;

  const RequestAccordion({
    Key? key,
    required this.name,
    required this.description,
    required this.author,
    required this.date,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          ExpansionTile(
            collapsedBackgroundColor: const Color(0xFF5D7052),
            textColor: Colors.white,
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            collapsedTextColor: Colors.white,
            backgroundColor: const Color(0xFF5D7052),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name),
              ],
            ),
            children: [
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                title: const Text('Utilisateur : ',
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(author,
                    style: const TextStyle(color: Color(0xAAFFFFFF))),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                title: const Text('Date : ', style: TextStyle(color: Colors.white)),
                subtitle: Text(date,
                    style: const TextStyle(color: Color(0xAAFFFFFF))),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                title: const Text('Description : ',
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(
                    description,
                    style: const TextStyle(color: Color(0xAAFFFFFF))),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: .5, color: Color(0xAAFFFFFF)),
                  ),
                ),
                child: TextButton(
                    onPressed: onAccept,
                    child: const Text('ACCEPTER',
                        style: TextStyle(color: Color(0xFFFFFFFF)))),
              )
            ],
          ),
        ]));
  }
}
