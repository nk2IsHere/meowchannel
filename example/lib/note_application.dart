import 'package:flutter/material.dart';

import 'note_details_page.dart';
import 'note_list_page.dart';
import 'note_list_store/note_model.dart';

const NOTE_LIST_ROUTE = "/";
const NOTE_DETAILS_ROUTE = "/details";

class NoteDetailsParams {
  final bool exists;
  final Note note;

  NoteDetailsParams({
    required this.note,
    required this.exists
  });
}

class NoteApplication extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      title: "Notes!",
      routes: {
        NOTE_LIST_ROUTE: (context) {
          return NoteListPageWidget();
        },
        NOTE_DETAILS_ROUTE: (context) {
          return NoteDetailsPageWidget();
        }
      },
    );
}
