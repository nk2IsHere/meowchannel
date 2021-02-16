import 'package:meowchannel/meowchannel.dart';

import 'note_list_actions.dart';
import 'note_list_state.dart';

///
/// [Reducer] is the direct manipulator of state which will then be announced in [Store.channel]
/// Be sure to double-check that the Reducer does not mutate data and state and has no side-effects 
/// It does not run in asynchronous thread
///
final Reducer<NoteListState> noteListReducer =
  typedReducer(syncedReducer((dynamic action, NoteListState previousState) {
    return previousState.copyWith(
      noteList: action is NoteListUpdateStateAction? action.noteList
        : previousState.noteList
    );
  }));