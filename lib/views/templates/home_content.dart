import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/models/request/PlaceModel.dart';
import 'package:student_for_student_mobile/models/request/RequestModel.dart';
import 'package:student_for_student_mobile/stores/home_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
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
      final homeStore = Provider.of<HomeStore>(context, listen: false);
      final userStore = Provider.of<UserStore>(context, listen: false);
      await homeStore.load(token: userStore.user.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return ScreenContent(children: [
      Consumer2<HomeStore, UserStore>(
          builder: (context, homeStore, userStore, child) => Column(
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
                              ...homeStore.courses
                                  .map<Padding>(
                                    (course) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: TextButton(
                                        onPressed: () => _handleFilter(
                                          store: homeStore,
                                          id: course.id,
                                          token: userStore.user.token,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  homeStore.selectedCourseId ==
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
                                                  color: homeStore
                                                              .selectedCourseId ==
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
                          homeStore.hasRequests
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(children: [
                                    ...homeStore.requests
                                        .map<RequestAccordion>((RequestModel
                                                request) =>
                                            RequestAccordion(
                                              name: request.requestName,
                                              description: request.description,
                                              date: request.getFormatedDate(),
                                              author: request.sender,
                                              placeAddress:
                                                  request.place.content,
                                              courseName:
                                                  request.course.content,
                                              onAccept: () => _onAccept(
                                                store: homeStore,
                                                requestId: request.id,
                                                token: userStore.user.token,
                                              ),
                                              onLocalize: () => _onLocalize(
                                                  homeStore, request.place),
                                            ))
                                        .toList()
                                  ]),
                                )
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

  void _onAccept({
    required HomeStore store,
    required int requestId,
    required String token,
  }) async {
    await store.acceptRequest(requestId: requestId, token: token);
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

  _handleFilter({
    required HomeStore store,
    required int id,
    required String token,
  }) async {
    await store.filterRequests(id: id, token: token);
  }

  _onLocalize(HomeStore store, PlaceModel place) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapPage(
                destination: place.address,
              )),
    );
  }
}
