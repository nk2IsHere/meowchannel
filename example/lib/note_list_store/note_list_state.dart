import 'package:dataclass/dataclass.dart';

import 'note_model.dart';

part 'note_list_state.g.dart';

@dataClass
class NoteListState extends _$NoteListState {
  final List<Note> noteList;

  NoteListState({
    this.noteList
  });
}