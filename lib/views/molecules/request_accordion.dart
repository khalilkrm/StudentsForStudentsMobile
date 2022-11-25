import 'package:flutter/material.dart';

class RequestAccordion extends StatelessWidget {
  final String name;
  final String description;
  final String date;
  final String author;
  final String placeAddress;
  final String courseName;
  final void Function() onAccept;
  final void Function() onLocalize;

  const RequestAccordion({
    Key? key,
    required this.name,
    required this.description,
    required this.date,
    required this.author,
    required this.placeAddress,
    required this.courseName,
    required this.onAccept,
    required this.onLocalize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3))
            ]),
            child: ExpansionTile(
              collapsedBackgroundColor: Colors.white,
              textColor: Colors.white,
              iconColor: Colors.white,
              collapsedIconColor: Colors.black,
              collapsedTextColor: Colors.black,
              backgroundColor: const Color(0xFF5D7052),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name),
                  Text(date, style: const TextStyle(fontSize: 13)),
                ],
              ),
              children: [
                ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  title: const Text('Utilisateur : ',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(author,
                      style: const TextStyle(color: Color(0xAAFFFFFF))),
                ),
                ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  title: const Text('Description : ',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(description,
                      style: const TextStyle(color: Color(0xAAFFFFFF))),
                ),
                ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  title: const Text('Lieu : ',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(placeAddress,
                      style: const TextStyle(color: Color(0xAAFFFFFF))),
                ),
                ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  title: const Text('Cours : ',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(courseName,
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
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: .5, color: Color(0xAAFFFFFF)),
                    ),
                  ),
                  child: TextButton(
                      onPressed: onLocalize,
                      child: const Text('LOCALISATION',
                          style: TextStyle(color: Color(0xFFFFFFFF)))),
                ),
              ],
            ),
          )
        ]));
  }
}
