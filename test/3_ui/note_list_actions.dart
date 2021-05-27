import 'package:meowchannel/meowchannel.dart';

import 'note_model.dart';

class NoteListAction {}

class NoteListAddAction extends NoteListAction {
  final int id;
  final String title;
  final String text;

  NoteListAddAction({
    required this.id,
    required this.title,
    required this.text
  });
}

class NoteListRemoveAction extends NoteListAction {
  final int id;

  NoteListRemoveAction({
    required this.id
  });
}

class NoteListEditAction extends NoteListAction {
  final int id;
  final String? title;
  final String? text;

  NoteListEditAction({
    required this.id,
    this.title,
    this.text
  });
}

class NoteListStateAction {}

class NoteListUpdateStateAction extends NoteListStateAction {
  final List<Note> noteList;

  NoteListUpdateStateAction({
    required this.noteList
  });
}
