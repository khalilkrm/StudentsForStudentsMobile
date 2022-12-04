import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/profile_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/molecules/profile_top_bar_molecule.dart';
import 'package:student_for_student_mobile/views/organisms/screen_navigation_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class UiTabBarView {
  UiTabBarView({required this.tab, required this.view});
  final Tab tab;
  final Widget view;
}

final data = [
  UiTabBarView(
      tab: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.school_outlined,
              size: 23,
            ),
            SizedBox(
              width: 7,
            ),
            Text("J'ai demandé"),
          ],
        ),
      ),
      view: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Wrap(children: [
            _ProfileRequestExpansionTile(
                tabBarTopModel: TabBarTopDataModel(
              courseName: "Mathématiques",
              requestTitle: "Demande de cours",
              isAccepted: false,
              handlerUsername: 'Adrew Tistaert',
              isMeTheHandler: false,
              onCancelPressed: () {},
              onNavigatePressed: () {},
              requestDescription:
                  "Je suis en 3ème et je voudrais avoir des cours de maths",
              requestMeetLocation: "Avenue de la gare 1, 1000 Bruxelles",
            ))
          ]),
        ),
      )),
  UiTabBarView(
      tab: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check),
            SizedBox(
              width: 5,
            ),
            Text("J'ai accépté"),
          ],
        ),
      ),
      view: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Wrap(children: [
            _ProfileRequestExpansionTile(
                tabBarTopModel: TabBarTopDataModel(
              courseName: "Mathématiques",
              requestTitle: "Demande de cours",
              isAccepted: true,
              handlerUsername: 'Adrew Tistaert',
              isMeTheHandler: true,
              onCancelPressed: () {},
              onNavigatePressed: () {},
              requestDescription:
                  "Je suis en 3ème et je voudrais avoir des cours de maths",
              requestMeetLocation: "Avenue de la gare 1, 1000 Bruxelles",
            ))
          ]),
        ),
      )),
];

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserStore, ProfileStore>(
      builder: (context, userStore, profileStore, child) =>
          DefaultTabController(
        length: profileStore.requests.length,
        child: Scaffold(
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    elevation: 4,
                    backgroundColor: Colors.white,
                    toolbarHeight: 390.0,
                    expandedHeight: 390.0,
                    title: ProfileTopBarMolecule(username: 'Khalil Karim'),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(90),
                      // TODO Controller's length property (0) does not match the
                      //number of tabs (2) present in TabBar's tabs property.
                      child: _TabBarTopOrganism(
                          tabs: data
                              .map((uiTabBarView) => uiTabBarView.tab)
                              .toList()),
                    ),
                  )
                ];
              },
              // TODO Controller's length property (0) does not match the
              //number of tabs (2) present in TabBar's tabs property.

              // Les deux onglet doivent toujours être affichés
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: profileStore.requests
                    .map((e) => _ProfileRequestExpansionTile(tabBarTopModel: e))
                    .toList(),
              )),
          bottomNavigationBar: const ScreenNavigationBar(),
        ),
      ),
    );
  }
}

class _TabBarTopOrganism extends StatelessWidget {
  const _TabBarTopOrganism({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      height: 50,
      decoration: BoxDecoration(
          color: const Color(0xFF85a074),
          borderRadius: BorderRadius.circular(25.0)),
      child: TabBar(
        isScrollable: false,
        padding: const EdgeInsets.all(5),
        unselectedLabelColor: Colors.black,
        indicator: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Color(0xff46543d),
        ),
        tabs: tabs,
      ),
    );
  }
}

class _ProfileRequestExpansionTile extends StatelessWidget {
  const _ProfileRequestExpansionTile({
    Key? key,
    required this.tabBarTopModel,
  }) : super(key: key);

  final TabBarTopDataModel tabBarTopModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(tabBarTopModel.isAccepted ? 0xff46543d : 0xFFc18845),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        collapsedTextColor: Colors.white,
        collapsedIconColor: Colors.white,
        textColor: Colors.white,
        leading:
            Icon(tabBarTopModel.isAccepted ? Icons.check : Icons.timelapse),
        iconColor: Colors.white,
        title: Text(tabBarTopModel.requestTitle,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            )),
        subtitle: Text(
            tabBarTopModel.isAccepted
                ? tabBarTopModel.isMeTheHandler
                    ? "Vous avez accepté cette demande"
                    : "Tutoré par ${tabBarTopModel.handlerUsername}"
                : 'En attente de tuteur',
            style: GoogleFonts.roboto()),
        children: [
          _ProfileRequestListTile(
            icon: const Icon(Icons.book_outlined, color: Colors.white70),
            title: 'Cours',
            subtitle: tabBarTopModel.courseName,
          ),
          _ProfileRequestListTile(
              icon:
                  const Icon(Icons.description_outlined, color: Colors.white70),
              title: 'Description de la demande',
              subtitle: tabBarTopModel.requestDescription),
          _ProfileRequestListTile(
              icon:
                  const Icon(Icons.location_on_outlined, color: Colors.white70),
              title: 'Lieu de rencontre',
              subtitle: tabBarTopModel.requestMeetLocation),
          _ProfileRequestListTile(
            icon: const Icon(Icons.person_outline, color: Colors.white70),
            title: 'Tuteur',
            subtitle: tabBarTopModel.handlerUsername,
          ),
          ListTile(
              title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (tabBarTopModel.isAccepted)
                Expanded(
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF85a074)),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    onPressed: tabBarTopModel.onNavigatePressed,
                    label: const Text('Naviguer'),
                    icon: const Icon(Icons.navigation),
                  ),
                ),
              if (!tabBarTopModel.isAccepted)
                Expanded(
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF745229)),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    onPressed: tabBarTopModel.onCancelPressed,
                    label: const Text('Annuler'),
                    icon: const Icon(Icons.close),
                  ),
                ),
            ],
          ))
        ],
      ),
    );
  }
}

class _ProfileRequestListTile extends StatelessWidget {
  const _ProfileRequestListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.roboto(color: Colors.white),
      ),
    );
  }
}

class TabBarTopDataModel {
  final bool isAccepted;
  final bool isMeTheHandler;
  final String handlerUsername;
  final String requestTitle;
  final String requestDescription;
  final String courseName;
  final String requestMeetLocation;
  final void Function() onNavigatePressed;
  final void Function() onCancelPressed;

  TabBarTopDataModel({
    required this.requestTitle,
    required this.requestDescription,
    required this.courseName,
    required this.requestMeetLocation,
    required this.isAccepted,
    required this.isMeTheHandler,
    required this.handlerUsername,
    required this.onNavigatePressed,
    required this.onCancelPressed,
  });
}
