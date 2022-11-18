import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/home_store.dart';
import 'package:student_for_student_mobile/views/molecules/request_accordion.dart';
import 'package:student_for_student_mobile/views/organisms/screen_content.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
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
                        child: TextButton(
                            onPressed: () => store.requestsMode(),
                            child: Text('DEMANDES',
                                style: TextStyle(
                                    color: store.mode
                                        ? Colors.black
                                        : Colors.grey,
                                    fontSize: 15))),
                      ),
                      SizedBox(
                        width: width / 3,
                        child: TextButton(
                            onPressed: () => store.synthesesMode(),
                            child: Text('SYNTHESES',
                                style: TextStyle(
                                    color: !store.mode
                                        ? Colors.black
                                        : Colors.grey,
                                    fontSize: 15))),
                      ),
                    ],
                  ),
                  store.mode ? const Text('DEMANDES') : const Text('SYNTHESES'),
                ],
              )),
    ]);
  }
}
