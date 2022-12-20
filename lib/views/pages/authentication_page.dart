import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/molecules/button_molecule.dart';
import 'package:student_for_student_mobile/views/molecules/error_ahead_molecule.dart';
import 'package:student_for_student_mobile/views/molecules/social_button.dart';
import 'package:student_for_student_mobile/views/molecules/text_form_field_molecule.dart';
import 'package:student_for_student_mobile/views/organisms/display_social_buttons.dart';
import 'package:student_for_student_mobile/views/organisms/screen_content.dart';

const _toolbarHeigth = 200.0;

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _emailTextFieldController =
      TextEditingController();
  final TextEditingController _passwordTextFieldController =
      TextEditingController();
  String? _emailLocalError;
  String? _passwordLocalError;
  bool _tryingToConnect = false;
  bool _hideTopErrors = true;

  UserStore Function(BuildContext) getState =
      (context) => Provider.of<UserStore>(context);

  @override
  Widget build(BuildContext context) {
    _tryingToConnect = getState(context).isLoading;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _toolbarHeigth,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "BONJOUR !",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Content de vous revoir, vous nous avez manqué !",
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ScreenContent(children: [
        Consumer<UserStore>(
            builder: (context, store, child) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    runSpacing: 48.0,
                    // alignment: WrapAlignment.center,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _hideTopErrors
                          ? const SizedBox()
                          : ErrorAheadMolecule(
                              errors: [
                                store.isError &&
                                        !store.error.toLowerCase().contains(
                                            RegExp(r"(mail|mot de passe)"))
                                    ? store.error
                                    : ""
                              ],
                            ),
                      TextFormFieldMolecule(
                        minLines: 1,
                        controller: _emailTextFieldController,
                        label: "Adresse mail",
                        errorText: _emailLocalError ??
                            (store.isError &&
                                    store.error.toLowerCase().contains('mail')
                                ? store.error
                                : null),
                        prefixiIcon: const Icon(Icons.mail),
                      ),
                      TextFormFieldMolecule(
                        minLines: 1,
                        controller: _passwordTextFieldController,
                        label: "Mot de passe",
                        errorText: _passwordLocalError ??
                            (store.isError &&
                                    store.error
                                        .toLowerCase()
                                        .contains('mot de passe')
                                ? store.error
                                : null),
                        prefixiIcon: const Icon(Icons.lock),
                        isForPassword: true,
                      ),
                      Wrap(
                        runSpacing: 20.0,
                        children: [
                          ButtonMolecule(
                            isSuccess: store.isSignedIn,
                            isLoading: store.isLoading,
                            stretch: true,
                            onPressed: _tryingToConnect
                                ? null
                                : () => _onConnectClicked(store),
                            label: "SE CONNECTER",
                          ),
                          const _Divider(),
                          DisplaySocialButtons(
                            socialButtons: [
                              SocialButton(
                                onTap: () => _onGoogleConnexionClicked(store),
                                logo: const AssetImage(
                                    "assets/logos/icons8-logo-google-100.png"),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )),
      ]),
    );
  }

  void _onGoogleConnexionClicked(UserStore store) async {
    setState(() {
      _hideTopErrors = true;
      _tryingToConnect = true;
      _emailLocalError = null;
      _passwordLocalError = null;
    });

    await store.signInWithGoogle();

    setState(() {
      _hideTopErrors = store.isError &&
          store.error.toLowerCase().contains(RegExp(r"(mail|mot de passe)"));
    });
  }

  void _onConnectClicked(UserStore store) async {
    final String email = _emailTextFieldController.text;
    final String password = _passwordTextFieldController.text;

    setState(() {
      _hideTopErrors = true;
      _setLocalErrors(email: email, password: password);
    });

    if (_emailLocalError == null && _passwordLocalError == null) {
      setState(() => _tryingToConnect = true);
      await store.signIn(email: email, password: password);
      setState(() {
        _hideTopErrors = store.isError &&
            store.error.toLowerCase().contains(RegExp(r"(mail|mot de passe)"));
      });
    }
  }

  void _setLocalErrors({required String email, required String password}) {
    RegExp regexp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    _emailLocalError = email.isEmpty
        ? "Veuillez entrer une adresse email"
        : !regexp.hasMatch(email)
            ? "Veuillez entrer une adresse mail valide"
            : null;
    _passwordLocalError =
        password.isEmpty ? "Veuillez entrer un mot de passe" : null;
  }
}

class _Divider extends StatelessWidget {
  const _Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 10.0),
            height: 2.0,
            color: Colors.grey,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          child: const Text("OU",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 10.0),
            height: 2.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
