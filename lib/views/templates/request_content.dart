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
                const Text('Loading...'),
                ButtonMolecule(
                  label: 'TEST',
                  onPressed: () => store.changeMode(),
                ),
              ]))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.0),
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
                      label: "Choississez une addresse",
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
                    InkWell(
                      onTap: () => store.changeMode(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Ajouter une nouvelle addresse', style: TextStyle(decoration: TextDecoration.underline, color: Color(0xFF5D7052))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropDownMolecule(
                      label: "Choississez un cours",
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
                      onPressed: () => _onSubmit(store),
                    ),
                  ],
                ),
              ),
      )
    ]);
  }

  _onSubmit(RequestStore store) async {
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
