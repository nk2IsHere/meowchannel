import 'package:meowchannel/meowchannel.dart';

import 'note_list_actions.dart';
import 'note_list_state.dart';
import 'note_model.dart';

final Worker<NoteListAction, NoteListState> noteListWorker =
  worker((context, action) async {
    final currentState = context.state();
    if(action is NoteListAddAction) {
      context.put(NoteListUpdateStateAction(
        noteList: currentState.noteList + [Note(id: action.id, title: action.title, text: action.text)]
      ));
    }
    if(action is NoteListRemoveAction) {
      context.put(NoteListUpdateStateAction(
        noteList: currentState.noteList
          .where((note) => note.id != action.id)
          .toList()
      ));
    }
    if(action is NoteListEditAction) {
      context.put(NoteListUpdateStateAction(
        noteList: currentState.noteList
          .map((note) => 
            note.id == action.id?
              note.copyWith(title: action.title, text: action.text)
              : note
          ).toList()
      ));
    }
  });


Watcher<NoteListAction, NoteListState> noteListWatcher(
  Worker<NoteListAction, NoteListState> worker
) =>
  watcher(worker, (actionStream, context) {
    return actionStream.where((action) => action is NoteListAction)
      .cast<NoteListAction>();
  });