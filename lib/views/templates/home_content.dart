import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/models/files/ui_option.dart';
import 'package:student_for_student_mobile/models/request/CourseModel.dart';
import 'package:student_for_student_mobile/models/request/PlaceModel.dart';
import 'package:student_for_student_mobile/models/request/RequestModel.dart';
import 'package:student_for_student_mobile/stores/home_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/molecules/request_accordion.dart';
import 'package:student_for_student_mobile/views/organisms/option_organism.dart';
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
                            child: Row(
                              children: homeStore.courses
                                  .map(
                                    (CourseModel course) => _CourseOption(
                                      id: course.id,
                                      isSelected: homeStore.selectedCourseId ==
                                          course.id,
                                      onOptionPressed: () => _handleFilter(
                                        store: homeStore,
                                        id: course.id,
                                        token: userStore.user.token,
                                      ),
                                      name: course.content,
                                    ),
                                  )
                                  .toList(),
                            ),
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

class _CourseOption extends StatelessWidget {
  const _CourseOption({
    required this.onOptionPressed,
    required this.isSelected,
    required this.name,
    required this.id,
  });

  final void Function() onOptionPressed;
  final bool isSelected;
  final String name;
  final int id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOptionPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ChoiceChip(
          label: Text(name),
          selected: isSelected,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
          selectedColor: const Color(0xC1884500),
          onSelected: (bool selected) {
            onOptionPressed();
          },
        ),
      ),
    );
  }
}
