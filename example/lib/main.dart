import 'package:flutter/material.dart';
import 'package:meowchannel/meowchannel.dart';

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
          ///
          /// This is [Store]
          /// Oh, wait...
          /// This is 100% similar to Redux Store!
          /// 
          /// Same reducers, same middlewares
          /// Adapted for flutter!
          /// 
          /// Caution: only one Store<StateType> can be present in Provider and its children
          ///
          Store<NoteListState>(
            initialState: NoteListState(noteList: []),
            reducer: noteListReducer,
            middleware: [
              ///
              /// [WorkerMiddleware] is a wrapper for a group of workers allowing them to receive actions on one channel
              /// (see [NoteListWorker] and its [NoteListWatcher])
              ///
              workerMiddleware([
                noteListWatcher(noteListWorker)
              ]),
              storeLogger
            ]
          ),
      )
    ],
    child: NoteApplication(),
  ),
));