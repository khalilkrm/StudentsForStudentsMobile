import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/models/user/UserStoreState.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/molecules/button_molecule.dart';
import 'package:student_for_student_mobile/views/molecules/error_ahead_molecule.dart';
import 'package:student_for_student_mobile/views/molecules/text_form_field_molecule.dart';

class AuthenticationPage extends StatefulWidget {
  final TextEditingController _emailTextFieldController =
      TextEditingController();
  final TextEditingController _passwordTextFieldController =
      TextEditingController();

  AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  String? _emailLocalError;
  String? _passwordLocalError;
  bool _tryingToConnect = false;
  bool _hideTopErrors = true;
  UserStoreState Function(BuildContext) getState =
      (context) => Provider.of<UserStore>(context).state;

  @override
  Widget build(BuildContext context) {
    _tryingToConnect =
        getState(context).isAuthLoading || getState(context).isGoogleLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            runSpacing: 40.0,
            children: [
              Consumer<UserStore>(
                builder: (context, store, child) => Wrap(
                  runSpacing: 48.0,
                  children: [
                    _hideTopErrors
                        ? const SizedBox()
                        : ErrorAheadMolecule(
                            errors: store.state.othersErrorMessages,
                          ),
                    TextFormFieldMolecule(
                      controller: widget._emailTextFieldController,
                      label: "email",
                      errorText:
                          _emailLocalError ?? store.state.emailErrorMessage,
                      prefixiIcon: const Icon(Icons.mail),
                    ),
                    TextFormFieldMolecule(
                      controller: widget._passwordTextFieldController,
                      label: "password",
                      errorText: _passwordLocalError ??
                          store.state.passwordErrorMessage,
                      prefixiIcon: const Icon(Icons.lock),
                      isForPassword: true,
                    ),
                    Wrap(
                      runSpacing: 20.0,
                      children: [
                        ButtonMolecule(
                          isSuccess: store.state.isSignedWithAuth,
                          isLoading: store.state.isAuthLoading,
                          stretch: true,
                          onPressed: _tryingToConnect
                              ? null
                              : () => _onConnectClicked(store),
                          label: "Se connecter",
                        ),
                        ButtonMolecule(
                          backgroundColor: const Color(0xFFDB4437),
                          isLoading: store.state.isGoogleLoading,
                          isSuccess: store.state.isSignedInWithGoogle,
                          stretch: true,
                          onPressed: _tryingToConnect
                              ? null
                              : () => _onGoogleConnexionClicked(store),
                          icon: const Icon(MdiIcons.google),
                          label: "Google",
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
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
      _hideTopErrors = store.state.othersErrorMessages.isEmpty;
    });
  }

  void _onConnectClicked(UserStore store) async {
    final String email = widget._emailTextFieldController.text;
    final String password = widget._passwordTextFieldController.text;

    setState(() {
      _hideTopErrors = true;
      _setLocalErrors(email: email, password: password);
    });

    if (_emailLocalError == null && _passwordLocalError == null) {
      setState(() => _tryingToConnect = true);
      await store.signIn(email: email, password: password);
      setState(() => _hideTopErrors = store.state.othersErrorMessages.isEmpty);
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
