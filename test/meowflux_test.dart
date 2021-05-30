import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meowchannel/core/initialization.dart';
import 'package:meowchannel/extensions/flutter/logger/store_logger_module.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_worker_module.dart';

import 'package:meowchannel/meowchannel.dart';

import '2_watcher/values_actions.dart';
import '2_watcher/values_reducer.dart';
import '2_watcher/values_state.dart';
import '2_watcher/values_tester.dart';
import '2_watcher/values_tester_watcher.dart';
import '2_watcher/values_watcher.dart';
import '3_ui/note_list_actions.dart';
import '3_ui/note_list_reducer.dart';
import '3_ui/note_list_state.dart';
import '3_ui/note_list_worker.dart';
import '3_ui/note_model.dart';
import '4_provider/application_widget.dart';
import '5_multi_provider/multi_application_widget.dart';
import '5_multi_provider/root_reducer.dart';
import '5_multi_provider/root_state.dart';
import '6_combined_reducers/motd_actions.dart';
import '7_combined_workers/todo_actions.dart';
import '7_combined_workers/todo_fakes.dart';
import '7_combined_workers/todo_store.dart';
import '8_store_builder/application_widget.dart';

import '1_basic_store/root_actions.dart';
import '1_basic_store/root_reducer.dart';
import '1_basic_store/root_state.dart';
import '9_isolate_workers/todo_isolate_worker.dart';

Future<List<dynamic>> initializeWorkerIsolate() async {
  return [];
}

Future<void> main() async {
  await initializeMeowChannel();
  await initializeIsolateWorkerModule(initializeWorkerIsolate);

  test('1. basic counter test', () async {

    final store = Store<RootState>(
      reducer: rootReducer,
      initialState: RootState(value: 0),
      modules: [
        storeLoggerModule('rootState')
      ]
    );

    print('TEST retrieve value');
    final initialState = await store.getState();
    print('TEST value: $initialState');
    expect(initialState.state.value, 0);

    print('TEST edit value');
    await store.dispatch(RootIncreaseAction());
    await store.dispatch(RootIncreaseAction());
    await store.dispatch(RootDecreaseAction());
    
    print('TEST retrieve value');
    final resultState = await store.getState();
    print('TEST value: $resultState');
    expect(resultState.state.value, 1);
  });

  test('2. workers and watchers communication test', () async {
    // await initializeMeowChannel();

    final tester = ValuesTester();
    final store = Store<ValuesState>(
      reducer: valuesReducer,
      initialState: ValuesState(values: []),
      modules: [
        storeLoggerModule('valuesStore'),
        workerModule<ValuesState>([
          valuesTesterWatcher(valuesTesterWorker(tester)),
          valuesWatcher(valuesWorker)
        ])
      ]
    );

    print('TEST run extensions.worker:');
    await store.dispatch(ValuesAddValueAction(value: "apple"));
    await store.dispatch(ValuesAddValueAction(value: "koala"));
    await store.dispatch(ValuesAddValueAction(value: "browney"));
    await store.dispatch(ValuesAddValueAction(value: "watch"));

    print('TEST await all workers to finish');
    await Future.delayed(Duration(seconds: 3));

    print("TEST 'tester' shows this: ${tester.render()}");

    expect(tester.render(), "APPLEKOALABROWNEYWATCH");
  });

  test('3. extensions.worker and ui listening test', () async {
    // await initializeMeowChannel();

    //
    //Note that we are going to block the test thread, so all state updates are expected to arrive late
    //
    List<Note> ui = [];

    final store = Store<NoteListState>(
      reducer: noteListReducer,
      initialState: NoteListState(noteList: []),
      modules: [
        storeLoggerModule('noteListModule'),
        workerModule<NoteListState>([
          noteListWatcher(noteListWorker)
        ])
      ]
    );

    store.channel
      .listen((state) { 
        print('TEST update notes: ${state.state.noteList}');
        ui = state.state.noteList;
      });

    print('TEST update notes');
    await store.dispatch(NoteListAddAction(id: 1, title: "1. Run test!", text: "Hope this works..."));
    await Future.delayed(Duration(milliseconds: 10));
    await store.dispatch(NoteListAddAction(id: 2, title: "2. Wait for test to finish!", text: "State is changing... at least"));
    await Future.delayed(Duration(milliseconds: 10));
    await store.dispatch(NoteListRemoveAction(id: 1));
    await Future.delayed(Duration(milliseconds: 10));
    await store.dispatch(NoteListAddAction(id: 1, title: "1. Run UI test!", text: "Hope this works #2..."));
    await Future.delayed(Duration(milliseconds: 10));
    await store.dispatch(NoteListAddAction(id: 3, title: "3. Finish!", text: "Your bets, please, gentlemen."));
    await Future.delayed(Duration(milliseconds: 10));
    await store.dispatch(NoteListEditAction(id: 1, text: "Hope workers work as intended..."));
    await Future.delayed(Duration(milliseconds: 10));

    print("TEST 'ui' shows this: $ui");
    expect(ui, [
      Note(id: 2, title: "2. Wait for test to finish!", text: "State is changing... at least"),
      Note(id: 1, title: "1. Run UI test!", text: "Hope workers work as intended..."),
      Note(id: 3, title: "3. Finish!", text: "Your bets, please, gentlemen.")
    ]);
  });

  //
  // This test reuses structures from #1 test
  //
  testWidgets('4. flutter provider test', (tester) async {
    // await initializeMeowChannel();

    await tester.pumpWidget(
      StoreProvider<RootState>(
        create: (context) =>
          Store<RootState>(
            reducer: rootReducer,
            initialState: RootState(value: 0),
            modules: [
              storeLoggerModule('rootState')
            ]
          ),
        child: MaterialApp(
          home: ApplicationWidget()
        ),
      ),
    );

    print('TEST edit value');
        
    await tester.tap(find.byKey(Key('button-decrease')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('button-decrease')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('button-increase')));
    await tester.pumpAndSettle();

    Text valueText = tester.widget(find.byKey(Key('text-value')));

    print('TEST retrieve value');
    print('TEST value: ${valueText.data}');

    expect(valueText.data, "1");
  });

  testWidgets('5. flutter multi provider test', (tester) async {
    // await initializeMeowChannel();

    await tester.pumpWidget(
      MultiStoreProvider(
        providers: [
          StoreProvider<FirstRootState>(
            create: (context) =>
              Store<FirstRootState>(
                reducer: firstRootReducer,
                initialState: FirstRootState(value: 0),
                modules: [
                  storeLoggerModule('firstRootState')
                ]
              ),
          ),
          StoreProvider<SecondRootState>(
            create: (context) =>
              Store<SecondRootState>(
                reducer: secondRootReducer,
                initialState: SecondRootState(value: 0),
                modules: [
                  storeLoggerModule('secondRootState')
                ]
              ),
          )
        ],
        child: MaterialApp(
          home: MultiApplicationWidget()
        ),
      ),
    );

    print('TEST edit values');

    await tester.tap(find.byKey(Key('first-button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('second-button-decrease')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('first-button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('second-button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('first-button-decrease')));
    await tester.pumpAndSettle();
        
    await tester.tap(find.byKey(Key('second-button-decrease')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('first-button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('second-button-decrease')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('first-button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('second-button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('first-button-decrease')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('second-button-increase')));
    await tester.pumpAndSettle();

    Text firstValueText = tester.widget(find.byKey(Key('first-text-value')));
    Text secondValueText = tester.widget(find.byKey(Key('second-text-value')));

    print('TEST retrieve values');
    print('TEST first value: ${firstValueText.data}');
    print('TEST second value: ${secondValueText.data}');

    expect(firstValueText.data, "2");
    expect(secondValueText.data, "0");
  });

  test('6. combined reducers', () async {
    // await initializeMeowChannel();

    final store = Store<String>(
      reducer: combinedReducer<String>([
        typedReducer<MotdFirstHalfAction, String>(syncedReducer((action, String previousState) => "$previousState pen")),
        typedReducer<MotdFirstHalfAction, String>(syncedReducer((action, String previousState) => "$previousState pineapple")),
        typedReducer<MotdSecondHalfAction, String>(syncedReducer((action, String previousState) => "$previousState apple")),
        typedReducer<MotdSecondHalfAction, String>(syncedReducer((action, String previousState) => "$previousState pen!"))
      ]),
      initialState: "MOTD:",
      modules: [
        storeLoggerModule('string')
      ]
    );

    print('TEST edit motd');
    await store.dispatch(MotdFirstHalfAction());
    await store.dispatch(MotdSecondHalfAction());

    print('TEST retrieve motd');
    final motd = (await store.getState()).state;

    print('TEST retrieved motd: $motd');
    expect(motd, "MOTD: pen pineapple apple pen!");
  });

  test('7. combined workers', () async {
    // await initializeMeowChannel();

    List<Todo> ui = [];

    final store = Store<TodoState>(
      reducer: todoReducer,
      initialState: TodoState(),
      modules: [
        workerModule([
          todoWatcher(todoWorker(
            TodoRepository()
          ))
        ]),
        storeLoggerModule('todoState')
      ]
    );

    store.channel
      .listen((state) { 
        ui = state.state.todos;
      });

    print('TEST update todos');
    await store.dispatch(TodoListAction());
    await Future.delayed(Duration(milliseconds: 10));
    
    await store.dispatch(TodoAddAction(id: 1, title: "1. Run test!", text: "Hope this works..."));
    await Future.delayed(Duration(milliseconds: 10));
    await store.dispatch(TodoAddAction(id: 2, title: "2. Wait for test to finish!", text: "State is changing... at least"));
    await Future.delayed(Duration(milliseconds: 10));
    await store.dispatch(TodoRemoveAction(id: 1));
    await Future.delayed(Duration(milliseconds: 10));
    await store.dispatch(TodoAddAction(id: 1, title: "1. Run UI test!", text: "Hope this works #2..."));
    await Future.delayed(Duration(milliseconds: 10));
    await store.dispatch(TodoAddAction(id: 3, title: "3. Finish!", text: "Your bets, please, gentlemen."));
    await Future.delayed(Duration(milliseconds: 10));
    await store.dispatch(TodoEditAction(id: 1, text: "Hope workers work as intended..."));
    await Future.delayed(Duration(milliseconds: 10));
    print("TEST 'ui' shows this: $ui");

    expect(ui, [
      Todo(id: 3, title: "3. Finish!", text: "Your bets, please, gentlemen."),
      Todo(id: 1, title: "1. Run UI test!", text: "Hope workers work as intended..."),
      Todo(id: 2, title: "2. Wait for test to finish!", text: "State is changing... at least")
    ]);
  });

  //
  // This test reuses structures from #1 test
  //
  testWidgets('8. flutter store builder widget test', (tester) async {
    // await initializeMeowChannel();

    await tester.pumpWidget(
      StoreProvider<RootState>(
        create: (context) =>
          Store<RootState>(
            reducer: rootReducer,
            initialState: RootState(value: 0),
            modules: [
              storeLoggerModule('rootStore')
            ]
          ),
        child: MaterialApp(
          home: BuilderApplicationWidget()
        ),
      ),
    );

    print('TEST edit value');
        
    await tester.tap(find.byKey(Key('button-decrease')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('button-decrease')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('button-increase')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('button-increase')));
    await tester.pumpAndSettle();
    
    await tester.tap(find.byKey(Key('button-increase')));
    await tester.pumpAndSettle();

    Text valueText = tester.widget(find.byKey(Key('text-value')));

    print('TEST retrieve value');
    print('TEST value: ${valueText.data}');

    expect(valueText.data, "4");
  });

  test('9. isolate workers', () async {
    final store = Store<TodoState>(
      reducer: todoReducer,
      initialState: TodoState(),
      modules: [
        isolateWorkerModule<TodoIsolateAction, TodoState>(initializeIsolateWorkers),
        storeLoggerModule('todoState')
      ]
    );

    store.dispatch(TodoIsolateGenerateAction());
    await Future.delayed(Duration(seconds: 3));

    expect((await store.getState()).state.todos.length, 10);
  });
}
