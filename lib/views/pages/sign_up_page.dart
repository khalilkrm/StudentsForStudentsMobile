import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/models/request/CursusModel.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/molecules/button_molecule.dart';
import 'package:student_for_student_mobile/views/molecules/error_ahead_molecule.dart';
import 'package:student_for_student_mobile/views/molecules/text_form_field_molecule.dart';
import 'package:student_for_student_mobile/views/organisms/screen_content.dart';

const _toolbarHeight = 200.0;

class SignUpPage extends StatefulWidget {
  final String? email;
  final String? firstname;

  const SignUpPage({super.key, this.email, this.firstname});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _selectedCursusError;
  String? _repeatPasswordError;
  bool _tryingToConnect = false;
  bool _hideTopErrors = true;
  String? _selectedCursus;
  bool withGoogle = false;

  UserStore getState() {
    return Provider.of<UserStore>(context, listen: false);
  }

  void pop() async {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    withGoogle = widget.email != null;
    _emailController.text = widget.email ?? "";
    _firstNameController.text = widget.firstname ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _tryingToConnect = getState().isLoading;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _toolbarHeight,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "INSCRIPTION",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Rejoignez-nous dès maintenant !",
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
        FutureBuilder<List<CursusModel>>(
            future: getState().getCursusList(),
            builder: (context, snapshot) {
              return Consumer<UserStore>(
                builder: (context, store, child) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    runSpacing: 16.0,
                    children: [
                      _hideTopErrors
                          ? const SizedBox()
                          : ErrorAheadMolecule(
                              errors: [store.isError ? store.error : ""],
                            ),
                      TextFormFieldMolecule(
                        desactivated: withGoogle,
                        minLines: 1,
                        controller: _firstNameController,
                        label: "Prénom",
                        errorText: _firstNameError,
                        prefixiIcon: const Icon(Icons.person),
                      ),
                      TextFormFieldMolecule(
                        minLines: 1,
                        controller: _lastNameController,
                        label: "Pseudo",
                        errorText: _lastNameError,
                        prefixiIcon: const Icon(Icons.person),
                      ),
                      TextFormFieldMolecule(
                        desactivated: withGoogle,
                        minLines: 1,
                        controller: _emailController,
                        label: "Adresse mail",
                        errorText: _emailError,
                        prefixiIcon: const Icon(Icons.mail),
                      ),
                      !withGoogle
                          ? TextFormFieldMolecule(
                              minLines: 1,
                              controller: _passwordController,
                              label: "Mot de passe",
                              errorText: _passwordError,
                              prefixiIcon: const Icon(Icons.lock),
                              isForPassword: true,
                            )
                          : const SizedBox(),
                      !withGoogle
                          ? TextFormFieldMolecule(
                              minLines: 1,
                              controller: _repeatPasswordController,
                              label: "Répéter le mot de passe",
                              errorText: _repeatPasswordError,
                              prefixiIcon: const Icon(Icons.lock),
                              isForPassword: true,
                            )
                          : const SizedBox(),
                      DropdownButtonFormField<String>(
                        value: _selectedCursus,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCursus = newValue;
                          });
                        },
                        items: _getCursusMenuItem(store),
                        decoration: InputDecoration(
                          errorText: _selectedCursusError,
                          labelText: 'Cursus',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.menu),
                        ),
                      ),
                      ButtonMolecule(
                        isLoading: _tryingToConnect,
                        stretch: true,
                        onPressed: _tryingToConnect
                            ? null
                            : () => _onSignUpClicked(store),
                        label: "S'INSCRIRE",
                      ),
                    ],
                  ),
                ),
              );
            }),
      ]),
    );
  }

  List<DropdownMenuItem<String>> _getCursusMenuItem(UserStore store) {
    return store.cursus
        .map((c) =>
            DropdownMenuItem<String>(value: c.label, child: Text(c.label)))
        .toList();
  }

  void _onSignUpClicked(UserStore store) async {
    final String firstName = _firstNameController.text;
    final String lastName = _lastNameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String repeatPassword = _repeatPasswordController.text;
    final String selectedCursus = _selectedCursus ?? "";

    setState(() {
      _hideTopErrors = true;
      _setLocalErrors(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          repeatPassword: repeatPassword,
          selectedCursus: selectedCursus);
    });

    if (_firstNameError == null &&
        _lastNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _repeatPasswordError == null &&
        _selectedCursusError == null) {
      setState(() => _tryingToConnect = true);

      await store.signUpWithEmail(
          firstname: firstName,
          lastname: lastName,
          email: email,
          password: password,
          cursus: selectedCursus);

      await store.signInWithEmail(email: email, password: password);
      pop();

      setState(() {
        _hideTopErrors = !store.isError;
      });
    }
  }

  void _setLocalErrors(
      {required String firstName,
      required String lastName,
      required String email,
      required String password,
      required String repeatPassword,
      required String selectedCursus}) {
    RegExp emailRegExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    _firstNameError = !withGoogle && firstName.isEmpty
        ? "Veuillez entrer votre prénom"
        : null;
    _lastNameError = lastName.isEmpty ? "Veuillez entrer votre pseudo" : null;
    _emailError = !withGoogle && email.isEmpty
        ? "Veuillez entrer votre adresse email"
        : !emailRegExp.hasMatch(email)
            ? "Veuillez entrer une adresse mail valide"
            : null;
    _passwordError = !withGoogle && password.isEmpty
        ? "Veuillez entrer votre mot de passe"
        : null;
    _repeatPasswordError = !withGoogle && repeatPassword.isEmpty
        ? "Veuillez répéter votre mot de passe"
        : (!withGoogle && repeatPassword != password)
            ? "Les mots de passe ne correspondent pas"
            : null;
    _selectedCursusError =
        selectedCursus.isEmpty ? "Veuillez sélectionner un cursus" : null;
  }
}
