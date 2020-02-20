import 'package:dataclass/dataclass.dart';
import 'package:meowflux/meowflux.dart';

import 'note_model.dart';

class NoteListAction extends Action {}

class NoteListAddAction extends NoteListAction {
  final int id;
  final String title;
  final String text;

  NoteListAddAction({
    this.id,
    this.title,
    this.text
  }): assert(id != null),
    assert(title != null),
    assert(text != null);
}

class NoteListRemoveAction extends NoteListAction {
  final int id;

  NoteListRemoveAction({
    this.id
  }): assert(id != null);
}

class NoteListEditAction extends NoteListAction {
  final int id;
  final String title;
  final String text;

  NoteListEditAction({
    this.id,
    this.title,
    this.text
  }): assert(id != null);
}

class NoteListStateAction extends Action {}

class NoteListUpdateStateAction extends NoteListStateAction {
  final List<Note> noteList;

  NoteListUpdateStateAction({
    this.noteList
  });
}