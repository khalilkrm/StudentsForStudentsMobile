import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/models/request/CourseModel.dart';
import 'package:student_for_student_mobile/models/request/PlaceModel.dart';
import 'package:student_for_student_mobile/stores/request_store.dart';
import 'package:student_for_student_mobile/views/molecules/button_molecule.dart';
import 'package:student_for_student_mobile/views/molecules/drop_down_molecule.dart';
import 'package:student_for_student_mobile/views/molecules/text_form_field_molecule.dart';
import 'package:student_for_student_mobile/views/organisms/screen_content.dart';

class RequestContent extends StatefulWidget {
  final TextEditingController _nameTextFieldController =
      TextEditingController();

  final TextEditingController _descriptionTextFieldController =
      TextEditingController();

  final TextEditingController _streetTextFieldController =
      TextEditingController();

  final TextEditingController _numberTextFieldController =
      TextEditingController();

  final TextEditingController _postalCodeTextFieldController =
      TextEditingController();

  final TextEditingController _localityTextFieldController =
      TextEditingController();

  RequestContent({super.key});

  @override
  State<RequestContent> createState() => _RequestContentState();
}

class _RequestContentState extends State<RequestContent> {
  PlaceModel? _selectedPlace;
  CourseModel? _selectedCourse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final store = Provider.of<RequestStore>(context, listen: false);
      await store.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContent(children: [
      Consumer<RequestStore>(
        builder: (context, store, child) => store.mode
            ? Center(
                child: Column(children: [
                Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                      child: Text(
                        'AJOUT D\'UNE ADRESSE',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TextFormFieldMolecule(
                  minLines: 1,
                  controller: widget._streetTextFieldController,
                  label: "Rue",
                  prefixiIcon: const Icon(Icons.add_road),
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: SizedBox(
                      width: 145,
                      child: TextFormFieldMolecule(
                        minLines: 1,
                        controller: widget._numberTextFieldController,
                        label: "Numéro",
                        prefixiIcon: const Icon(Icons.numbers),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SizedBox(
                      width: 145,
                      child: TextFormFieldMolecule(
                        minLines: 1,
                        type: true,
                        controller: widget._postalCodeTextFieldController,
                        label: "Code postal",
                        prefixiIcon: const Icon(Icons.local_post_office),
                      ),
                    ),
                  ),
                ]),
                TextFormFieldMolecule(
                  minLines: 1,
                  controller: widget._localityTextFieldController,
                  label: "Localité",
                  prefixiIcon: const Icon(Icons.location_city),
                ),
                const SizedBox(height: 20),
                ButtonMolecule(
                  label: 'AJOUTER MON ADRESSE',
                  onPressed: () => _onSubmitAddress(store),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => store.changeMode(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Annuler',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black)),
                    ],
                  ),
                ),
              ]))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                          child: Text(
                            'DEMANDE DE TUTORAT',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    TextFormFieldMolecule(
                      minLines: 1,
                      controller: widget._nameTextFieldController,
                      label: "Nom de la demande",
                      prefixiIcon: const Icon(Icons.add),
                    ),
                    TextFormFieldMolecule(
                      minLines: 5,
                      controller: widget._descriptionTextFieldController,
                      label: "Description de la demande",
                      prefixiIcon: const Icon(Icons.description),
                    ),
                    const SizedBox(height: 20),
                    DropDownMolecule(
                      label: "Choisissez une adresse",
                      value: _selectedPlace,
                      onChanged: (place) {
                        setState(() {
                          _selectedPlace = place;
                        });
                      },
                      items: store.places
                          .map<DropdownMenuItem<PlaceModel>>((place) {
                        return DropdownMenuItem<PlaceModel>(
                          value: place,
                          child: Text(
                            place.content,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () => store.changeMode(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Ajouter une nouvelle adresse',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropDownMolecule(
                      label: "Choisissez un cours",
                      value: _selectedCourse,
                      onChanged: (course) {
                        setState(() {
                          _selectedCourse = course;
                        });
                      },
                      items: store.courses
                          .map<DropdownMenuItem<CourseModel>>((course) {
                        return DropdownMenuItem<CourseModel>(
                          value: course,
                          child: Text(
                            course.content,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    ButtonMolecule(
                      label: 'ENVOYER MA DEMANDE',
                      onPressed: () => _onSubmitRequest(store),
                    ),
                  ],
                ),
              ),
      )
    ]);
  }

  _onSubmitAddress(RequestStore store) async {
    final RegExp regex = RegExp(r'^[0-9]{1,4}[a-zA-Z]?$');

    if (widget._streetTextFieldController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('Le nom de la rue est obligatoire'),
        ),
      );
      return;
    }

    if (widget._numberTextFieldController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('Le numéro est obligatoire'),
        ),
      );
      return;
    }

    if (!regex.hasMatch(widget._numberTextFieldController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('Le numéro est invalide'),
        ),
      );
      return;
    }

    if (widget._postalCodeTextFieldController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('Le code postal est obligatoire'),
        ),
      );
      return;
    }

    if (widget._localityTextFieldController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('La localité est obligatoire'),
        ),
      );
      return;
    }

    await store.sendAddress(
      street: widget._streetTextFieldController.text,
      number: widget._numberTextFieldController.text,
      postalCode: int.parse(widget._postalCodeTextFieldController.text),
      locality: widget._localityTextFieldController.text,
    );

    _showMessage(store);
  }

  _onSubmitRequest(RequestStore store) async {
    if (widget._nameTextFieldController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('Le nom de la demande est obligatoire'),
        ),
      );
      return;
    }

    if (widget._descriptionTextFieldController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('La description de la demande est obligatoire'),
        ),
      );
      return;
    }

    if (_selectedPlace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('L\'adresse est obligatoire'),
        ),
      );
      return;
    }

    if (_selectedCourse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          content: Text('Le cours est obligatoire'),
        ),
      );
      return;
    }

    await store.sendRequest(
      name: widget._nameTextFieldController.text,
      description: widget._descriptionTextFieldController.text,
      placeId: _selectedPlace!.id,
      courseId: _selectedCourse!.id,
    );

    _showMessage(store);
  }

  void _showMessage(RequestStore store) {
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
}
