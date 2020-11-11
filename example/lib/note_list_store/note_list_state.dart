import 'package:dataclass_beta/dataclass_beta.dart';

import 'note_model.dart';

part 'note_list_state.g.dart';

///
/// This is a state
/// It can basically be anything
/// (even [bool])
///
@dataClass
class NoteListState extends _$NoteListState {
  final List<Note> noteList;

  NoteListState({
    this.noteList
  });
}