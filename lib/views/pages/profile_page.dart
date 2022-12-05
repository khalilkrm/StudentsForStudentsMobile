import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/profile_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/organisms/profile_request_expansion_tile_organism.dart';
import 'package:student_for_student_mobile/views/organisms/profile_top_bar_organism.dart';
import 'package:student_for_student_mobile/views/templates/profile_template.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userStore = Provider.of<UserStore>(context, listen: false);
      final profileStore = Provider.of<ProfileStore>(context, listen: false);
      profileStore.loadOwnedRequests(token: userStore.state.token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserStore, ProfileStore>(
        builder: (context, userStore, profileStore, child) =>
            NestedScollableTabBarViewTemplate(
                tabBarPair: _buildTabBarPair(profileStore),
                title:
                    ProfileTitleOrganism(username: userStore.state.username!)));
  }

  TabBarPair _buildTabBarPair(ProfileStore profileStore) {
    return TabBarPair(
      tabs: {
        'J\'ai demandé': const Icon(
          Icons.school_outlined,
          size: 23,
        ),
        'J\'ai accépté': const Icon(Icons.check),
      },
      views: [
        TabBarPairView(
          isEmpty: profileStore.isCreatedRequestsEmpty,
          view: profileStore.isCreatedRequestsEmpty
              ? const Center(
                  child: Text("Vous n'avez pas encore de demande"),
                )
              : Wrap(
                  children: [
                    ...profileStore
                        .getCreatedRequest()
                        .map((profiledataModel) =>
                            ProfileRequestExpansionTileOrganism(
                              profiledataModel: profiledataModel,
                            ))
                        .toList(),
                  ],
                ),
        ),
        TabBarPairView(
          isEmpty: profileStore.isHandledRequestsEmpty,
          view: profileStore.isHandledRequestsEmpty
              ? const Center(
                  child: Text(
                    "Vous n'avez pas encore accepté de demande",
                  ),
                )
              : Wrap(
                  children: [
                    ...profileStore
                        .getHandledRequest()
                        .map((profiledataModel) =>
                            ProfileRequestExpansionTileOrganism(
                              profiledataModel: profiledataModel,
                            ))
                        .toList(),
                  ],
                ),
        )
      ],
    );
  }
}
