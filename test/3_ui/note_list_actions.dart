import 'package:dataclass/dataclass.dart';
import 'package:meowchannel/meowchannel.dart';

import 'note_model.dart';

part 'note_list_actions.g.dart';

class NoteListAction extends Action {}

@dataClass
class NoteListAddAction extends _$NoteListAddAction {
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

@dataClass
class NoteListRemoveAction extends _$NoteListRemoveAction {
  final int id;

  NoteListRemoveAction({
    this.id
  }): assert(id != null);
}

@dataClass
class NoteListEditAction extends _$NoteListEditAction {
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

@dataClass
class NoteListUpdateStateAction extends _$NoteListUpdateStateAction {
  final List<Note> noteList;

  NoteListUpdateStateAction({
    this.noteList
  });
}