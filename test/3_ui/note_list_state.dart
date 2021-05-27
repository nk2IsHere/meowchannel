import 'package:dataclass_beta/dataclass_beta.dart';

import 'note_model.dart';

part 'note_list_state.g.dart';

@DataClass()
class NoteListState with _$NoteListState {
  final List<Note> noteList;

  NoteListState({
    required this.noteList
  });
}
