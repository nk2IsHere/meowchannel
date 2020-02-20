import 'package:flutter/material.dart';
import 'package:meowflux/meowflux.dart';

import 'note_list_store/note_list_reducer.dart';
import 'note_list_store/note_list_state.dart';
import 'note_list_store/note_list_worker.dart';

import 'note_application.dart';
import 'store_logger.dart';

void main() => runApp(MaterialApp(
  title: 'Notes!',
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
  home: MultiStoreProvider(
    providers: [
      StoreProvider<NoteListState>(
        create: (context) =>
          Store<NoteListState>(
            initialState: NoteListState(noteList: []),
            reducer: NoteListReducer,
            middleware: [
              WorkerMiddleware([
                NoteListWatcher(NoteListWorker)
              ]),
              storeLogger
            ]
          ),
      )
    ],
    child: NoteApplication(),
  ),
));