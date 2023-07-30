import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/file_store.dart';
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
      final fileStore = Provider.of<FileStore>(context, listen: false);
      await profileStore.loadOwnedRequests(
          token: userStore.user.token,
          currentUsername: userStore.user.username);
      await fileStore.loadFiles(token: userStore.user.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<UserStore, ProfileStore, FileStore>(
        builder: (context, userStore, profileStore, fileStore, child) =>
            NestedScollableTabBarViewTemplate(
                tabs: _buildTabs(profileStore),
                views: _buildTabViews(
                  profileStore: profileStore,
                  token: userStore.user.token,
                ),
                title: ProfileTitleOrganism(
                  image: fileStore.downloadImage(
                      userStore.user.token, userStore.user.username),
                  onDisconnect: userStore.signOut,
                  username: userStore.user.username,
                  onImagePicked: (imageBytes, extension) async {
                    await fileStore.uploadImage(userStore.user.token,
                        courseId: 1,
                        username: userStore.user.username,
                        extension: extension,
                        bytesContent: imageBytes);
                    await fileStore.loadFiles(token: userStore.user.token);
                  },
                )));
  }

  List<Widget> _buildTabs(ProfileStore profileStore) {
    return [
      _ProfileTabBar(
        text: "Créées",
        icon: const Icon(Icons.school),
        length: profileStore.createdRequests.length,
      ),
      _ProfileTabBar(
        text: "Accéptées",
        icon: const Icon(Icons.check),
        length: profileStore.handledRequests.length,
      )
    ];
  }

  List<TabBarViewModel> _buildTabViews(
      {required ProfileStore profileStore, required String token}) {
    return [
      TabBarViewModel(
        makeScrollable: !profileStore.isCreatedRequestsEmpty,
        child: profileStore.isCreatedRequestsEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Vous n'avez créé aucune demande",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 10),
                    Text("Créez des demandes à partir de l'accueil",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(fontSize: 12)),
                  ],
                ),
              )
            : Wrap(
                children: [
                  ...profileStore
                      .getCreatedRequest()
                      .map(
                        (profiledataModel) =>
                            ProfileRequestExpansionTileOrganism(
                          token: token,
                          profileRequestdataModel: profiledataModel,
                        ),
                      )
                      .toList(),
                ],
              ),
      ),
      TabBarViewModel(
          makeScrollable: !profileStore.isHandledRequestsEmpty,
          child: profileStore.isHandledRequestsEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Vous n'avez accepté aucune demande",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(height: 10),
                      Text("Acceptez des demandes à partir de l'accueil",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(fontSize: 12)),
                    ],
                  ),
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
                )),
    ];
  }
}

class _ProfileTabBar extends StatelessWidget {
  const _ProfileTabBar({
    Key? key,
    required this.text,
    required this.length,
    required this.icon,
  }) : super(key: key);

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
