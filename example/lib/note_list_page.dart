import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meowchannel/core/store.dart';
import 'package:meowchannel/meowchannel.dart';

import 'note_application.dart';
import 'note_list_store/note_list_actions.dart';
import 'note_list_store/note_list_state.dart';
import 'note_list_store/note_model.dart';

final kMaxId = 1000000;

class NoteListPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
    _NoteListPageWidgetState();
}

///
/// Every stateful widget that should be updated using states has to extend from [StoreState] and [WidgetStoreProviderMixin]
///
class _NoteListPageWidgetState extends StoreState<NoteListPageWidget> {

  ///
  /// Here are the declared stores that will be available to this stateful widget
  ///
  @override
  List<Store> requireStores(BuildContext context) => [
    StoreProvider.of<NoteListState>(context)
  ];

  @override
  Widget build(BuildContext context) {
    ///
    /// Every declared store can be accessed by using [getStore<State>()]
    ///
    final Store<NoteListState> store = getStore<NoteListState>();
    ///
    /// Every declared store's state can be accessed by using [getState<State>()]
    ///
    NoteListState state = getState<NoteListState>();

    return Scaffold(
      appBar: AppBar(title: Text("Notes!"),),
      body: ListView.builder(
        itemCount: state?.noteList?.length ?? 0,
        itemBuilder: (context, index) =>
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "id: ${state?.noteList[index]?.id}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.0, color: Colors.black54),
                        ),
                        Text(
                          state?.noteList[index]?.title, 
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          state?.noteList[index]?.text,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 36.0,
                    child: RaisedButton(
                      child: Icon(Icons.edit),
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        Navigator.pushNamed(
                          context, 
                          NOTE_DETAILS_ROUTE,
                          arguments: NoteDetailsParams(exists: true, note: state?.noteList[index])
                        );
                      },
                    ),
                  ),
                  Container(width: 8.0,),
                  Container(
                    width: 36.0,
                    child: RaisedButton(
                      child: Icon(Icons.delete),
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        ///
                        /// [Store.dispatch] is used to send action to store
                        ///
                        store.dispatch(NoteListRemoveAction(
                          id: state?.noteList[index]?.id
                        ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context, 
            NOTE_DETAILS_ROUTE,
            arguments: NoteDetailsParams(exists: false, note: Note(
              id: Random().nextInt(kMaxId),
              title: "",
              text: ""
            ))
          );
        },
      ),
    );
  }
}