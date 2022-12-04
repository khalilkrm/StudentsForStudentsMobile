import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/models/request/PlaceModel.dart';
import 'package:student_for_student_mobile/stores/home_store.dart';
import 'package:student_for_student_mobile/views/molecules/request_accordion.dart';
import 'package:student_for_student_mobile/views/organisms/screen_content.dart';
import 'package:student_for_student_mobile/views/pages/map_page.dart';

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
                        width: width,
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              'DEMANDES',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              ...store.courses
                                  .map<Padding>(
                                    (course) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: TextButton(
                                        onPressed: () =>
                                            _handleFilter(store, course.id),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: store.selectedCourseId ==
                                                      course.id
                                                  ? const Color(0xC1884500)
                                                  : Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(0, 3))
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Text(
                                              course.content,
                                              style: TextStyle(
                                                  color:
                                                      store.selectedCourseId ==
                                                              course.id
                                                          ? Colors.white
                                                          : Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ]),
                          ),
                          store.hasRequests
                              ? Column(children: [
                                  ...store.requests
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
                                            onLocalize: () => _onLocalize(
                                                store, request.place),
                                          ))
                                      .toList()
                                ])
                              : Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.sentiment_dissatisfied,
                                        size: 50),
                                    SizedBox(height: 20),
                                    Text('Aucune demande à accepter'),
                                  ],
                                )),
                        ],
                      ))
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

  _handleFilter(HomeStore store, int id) async {
    await store.filterRequests(id);
  }

  _onLocalize(HomeStore store, PlaceModel place) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapPage(
                destination:
                    "${place.street} ${place.number}, ${place.postalCode} ${place.locality}",
              )),
    );
  }
}
