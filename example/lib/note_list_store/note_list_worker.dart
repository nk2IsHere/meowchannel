import 'package:meowflux/meowflux.dart';

import 'note_list_actions.dart';
import 'note_list_state.dart';
import 'note_model.dart';


///
/// This is a worker
/// It recieves [Action] filtered by [Watcher] does heavy work (database manipulations, api calls, etc.) and puts [Action]
/// Multiple workers can be chained by putting [Action] accepted by another [Watcher] and [Worker] pair
/// It is asynchronous
///
final Worker<NoteListAction, NoteListState> NoteListWorker =
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


Watcher<NoteListAction, NoteListState> NoteListWatcher(
  Worker<NoteListAction, NoteListState> worker
) =>
  watcher(worker, (actionStream, context) {
    return actionStream.where((action) => action is NoteListAction)
      .cast<NoteListAction>();
  });