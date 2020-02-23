import 'package:meowchannel/meowchannel.dart';

import 'note_list_actions.dart';
import 'note_list_state.dart';

final Reducer<NoteListState> NoteListReducer =
  TypedReducer((Action action, NoteListState previousState) {
    return previousState.copyWith(
      noteList: action is NoteListUpdateStateAction? action.noteList
        : previousState.noteList
    );
  });