import 'package:dataclass_beta/dataclass_beta.dart';

import 'note_model.dart';

part 'note_list_state.g.dart';

@dataClass
class NoteListState extends _$NoteListState {
  final List<Note> noteList;

  NoteListState({
    this.noteList
  });
}