import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/home_store.dart';
import 'package:student_for_student_mobile/views/molecules/request_accordion.dart';
import 'package:student_for_student_mobile/views/molecules/waiting_message.dart';
import 'package:student_for_student_mobile/views/organisms/screen_content.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final store = Provider.of<HomeStore>(context, listen: false);
      await store.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return ScreenContent(children: [
      Consumer<HomeStore>(
          builder: (context, store, child) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: width / 3,
                          child: Column(children: [
                            TextButton(
                                onPressed: () => store.requestsMode(),
                                child: Text('DEMANDES',
                                    style: TextStyle(
                                        color: store.mode
                                            ? Colors.black
                                            : Colors.grey,
                                        fontSize: 15))),
                            Container(
                                height: 2,
                                width: width / 10,
                                color: store.mode
                                    ? Colors.black
                                    : Colors.transparent)
                          ])),
                      SizedBox(
                          width: width / 3,
                          child: Column(children: [
                            TextButton(
                                onPressed: () => store.synthesesMode(),
                                child: Text('SYNTHESES',
                                    style: TextStyle(
                                        color: !store.mode
                                            ? Colors.black
                                            : Colors.grey,
                                        fontSize: 15))),
                            Container(
                                height: 2,
                                width: width / 10,
                                color: !store.mode
                                    ? Colors.black
                                    : Colors.transparent)
                          ])),
                    ],
                  ),
                  store.mode
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: store.hasRequests
                              ? Column(
                                  children: store.requests
                                      .map<RequestAccordion>((request) =>
                                          RequestAccordion(
                                            name: request.requestName,
                                            description: request.description,
                                            date: request.date,
                                            author: request.sender,
                                            placeAddress: request.place.content,
                                            courseName: request.course.content,
                                            onAccept: () =>
                                                _onAccept(store, request.id),
                                          ))
                                      .toList())
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.sentiment_dissatisfied,
                                          size: 50),
                                      SizedBox(height: 20),
                                      Text('Aucune demande à accepter'),
                                    ],
                                  ),
                                ))
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.sentiment_dissatisfied, size: 50),
                              SizedBox(height: 20),
                              Text('Aucune synthèse à afficher'),
                            ],
                          ),
                        ),
                ],
              )),
    ]);
  }

  void _onAccept(HomeStore store, int requestId) async {
    await store.acceptRequest(requestId);

    _showMessage(store);
  }

  void _showMessage(HomeStore store) {
    if (store.errorMessage != '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text(store.errorMessage),
        ),
      );
    }

    if (store.successMessage != '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.green,
          content: Text(store.successMessage),
        ),
      );
    }
  }
}
