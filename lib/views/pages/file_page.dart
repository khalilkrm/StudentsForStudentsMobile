import 'dart:collection';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/models/files/file.dart';
import 'package:student_for_student_mobile/models/files/ui_option.dart';
import 'package:student_for_student_mobile/stores/file_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/molecules/file_element.dart';
import 'package:student_for_student_mobile/views/organisms/screen_navigation_bar.dart';
import 'package:student_for_student_mobile/views/organisms/search_file_result.dart';

class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  bool hideIcon = false;

  _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FileStore fileStore = Provider.of<FileStore>(context, listen: false);
      UserStore userStore = Provider.of<UserStore>(context, listen: false);
      fileStore.onError = _showErrorDialog;

      await fileStore.loadFiles(token: userStore.user.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FileStore, UserStore>(
      builder: (context, fileStore, userStore, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Synthèses"),
          actions: [
            IconButton(
              onPressed: () async {
                var result = await showSearch(
                  context: context,
                  delegate: FileSearchDelegate(
                      context: context, source: fileStore.files.files),
                );
                _onFileSeleted(result);
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          itemCount: fileStore.files.files.length,
          itemBuilder: (context, index) {
            var results = fileStore.files.files;
            final File uiFile = results[index];
            return FileMolecule(
                uiFile: uiFile, onFileTap: () => _onFileSeleted(uiFile));
          },
        ),
        bottomNavigationBar: const ScreenNavigationBar(),
      ),
    );
  }

  void _onFileSeleted(File? result) async {
    if (result == null) return;
    var fileStore = Provider.of<FileStore>(context, listen: false);
    UserStore userStore = Provider.of<UserStore>(context, listen: false);
    await fileStore.dowloadFile(
        filename: result.filename, token: userStore.user.token);
  }
}

typedef FilePredicate = bool Function(File file, String query);

class FileSearchDelegate extends SearchDelegate<File?> {
  final UnmodifiableListView<File> source;
  final List<File> searchResult = [];

  /// Options to filter the search results
  final Set<UIOption> chips = {};
  final BuildContext context;

  FileSearchDelegate({required List<File> source, required this.context})
      : source = UnmodifiableListView(source);

  // ----------------------------
  // SearchDelegate methods
  // ----------------------------

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ResultFileSearchDelegate(
      source: searchResult,
      options: chips,
      onFileTap: (uiFile) => close(context, uiFile),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onType(query: query);

    return ResultFileSearchDelegate(
      source: searchResult,
      options: chips,
      onFileTap: (uiFile) => close(context, uiFile),
    );
  }

  // ----------------------------
  // Private methods : filtering logic
  // ----------------------------

  _onType({required String query}) {
    // Filtered by the query
    List<File> filtered = _filter(
        predicate: (file, query) =>
            file.filename.toLowerCase().contains(query.toLowerCase()));

    // Filtered by the chips
    List<UIOption> chipCourses = _getChipsBasedOnCourses(filtered);
    List<UIOption> chipCursus = _getChipsBasedOnCursus(filtered);

    // Reset with the new filtered list
    _resetSearchResultWith(filtered);
    _resetChipsWith([...chipCourses, ...chipCursus]);
  }

  List<File> _filter({required FilePredicate predicate}) {
    return source.where((file) => predicate(file, query)).toList();
  }

  List<UIOption> _getChipsBasedOnCourses(List<File> filtered) {
    List<UIOption> chipsBasedOnCourses = _mapToOptions(
        mapper: (uiFile) => UIOption(
            id: uiFile.courseId,
            name: uiFile.courseName,
            tester: (file) => uiFile.courseId == file.courseId),
        list: filtered);
    return chipsBasedOnCourses;
  }

  List<UIOption> _getChipsBasedOnCursus(List<File> filtered) {
    List<UIOption> chipsBasedOnCursus = _mapToOptions(
        mapper: (uiFile) => UIOption(
              id: uiFile.cursusId,
              name: uiFile.cursusName,
              tester: (file) => uiFile.cursusId == file.cursusId,
            ),
        list: filtered);
    return chipsBasedOnCursus;
  }

  List<UIOption> _mapToOptions({
    required UIOption Function(File) mapper,
    required List<File> list,
  }) {
    return list.map((result) => mapper(result)).toList();
  }

  void _resetSearchResultWith(List<File> filtered) {
    searchResult.clear();
    searchResult.addAll(filtered);
  }

  void _resetChipsWith(List<UIOption> chipCourses) {
    chips.clear();
    chips.addAll(chipCourses);
  }
}
