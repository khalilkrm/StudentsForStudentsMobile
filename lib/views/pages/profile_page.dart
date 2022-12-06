import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/profile_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/organisms/profile_request_expansion_tile_organism.dart';
import 'package:student_for_student_mobile/views/organisms/profile_top_bar_organism.dart';
import 'package:student_for_student_mobile/views/templates/nested_scollable_tab_bar_view_template.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userStore = Provider.of<UserStore>(context, listen: false);
      final profileStore = Provider.of<ProfileStore>(context, listen: false);
      await profileStore.loadOwnedRequests(
        token: userStore.state.token!,
        currentUsername: userStore.state.username!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserStore, ProfileStore>(
        builder: (context, userStore, profileStore, child) =>
            NestedScollableTabBarViewTemplate(
                tabs: _buildTabs(profileStore),
                views: _buildTabBarPair(
                  profileStore: profileStore,
                  token: userStore.state.token!,
                ),
                title: ProfileTitleOrganism(
                  username: userStore.state.username!,
                )));
  }

  List<Widget> _buildTabs(ProfileStore profileStore) {
    return [
      _ProfileTabBar(
        text: "J'ai demandé",
        icon: const Icon(Icons.school),
        length: profileStore.createdRequests.length,
      ),
      _ProfileTabBar(
        text: "J'ai accepté",
        icon: const Icon(Icons.check),
        length: profileStore.handledRequests.length,
      ),
    ];
  }

  Map<bool, Widget> _buildTabBarPair(
      {required ProfileStore profileStore, required String token}) {
    return {
      profileStore.isCreatedRequestsEmpty: profileStore.isCreatedRequestsEmpty
          ? Center(
              child: Text("Vous n'avez pas encore de demande",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            )
          : Wrap(
              children: [
                ...profileStore
                    .getCreatedRequest()
                    .map((profiledataModel) =>
                        ProfileRequestExpansionTileOrganism(
                          token: token,
                          profileRequestdataModel: profiledataModel,
                        ))
                    .toList(),
              ],
            ),
      profileStore.isHandledRequestsEmpty: profileStore.isHandledRequestsEmpty
          ? Center(
              child: Text("Vous n'avez pas encore accepté de demande",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            )
          : Wrap(
              children: [
                ...profileStore
                    .getHandledRequest()
                    .map((profiledataModel) =>
                        ProfileRequestExpansionTileOrganism(
                          token: token,
                          profileRequestdataModel: profiledataModel,
                        ))
                    .toList(),
              ],
            ),
    };
  }
}

class _ProfileTabBar extends StatelessWidget {
  const _ProfileTabBar(
      {Key? key, required this.text, required this.length, required this.icon})
      : super(key: key);

  final String text;
  final int length;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            icon, //Icon
            const SizedBox(width: 5),
            Text(text), //Text
          ],
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Text(
            "$length",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
