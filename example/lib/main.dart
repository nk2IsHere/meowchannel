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

  ///
  /// [MultiStoreProvider] is used to inject [Store] instances into every child widget
  /// Here [NoteListState] store is created with some middlewares (see [storeLogger])
  /// 
  home: MultiStoreProvider(
    providers: [
      StoreProvider<NoteListState>(
        create: (context) =>
          Store<NoteListState>(
            initialState: NoteListState(noteList: []),
            reducer: NoteListReducer,
            middleware: [
              ///
              /// [WorkerMiddleware] is a wrapper for a group of workers allowing them to receive actions on one channel
              /// (see [NoteListWorker] and its [NoteListWatcher])
              ///
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