import 'package:flutter/material.dart';
import 'package:meowchannel/core/store.dart';
import 'package:meowchannel/extensions/flutter/store_provider.dart';
import 'package:meowchannel/extensions/flutter/widget_store_provider.dart';

import 'note_application.dart';
import 'note_list_store/note_list_actions.dart';
import 'note_list_store/note_list_state.dart';

class NoteDetailsPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
    _NoteDetailsPageWidgetState();
}

class _NoteDetailsPageWidgetState extends StoreState<NoteDetailsPageWidget> with WidgetStoreProviderMixin {

  @override
  List<Store> requireStores(BuildContext context) => [
    StoreProvider.of<NoteListState>(context)
  ];

  String _title = "";
  String _text = "";

  @override
  Widget build(BuildContext context) {
    final Store<NoteListState> store = getStore<NoteListState>();
    final NoteDetailsParams noteDetails = ModalRoute.of(context).settings.arguments;
    _title = noteDetails.note.title;
    _text = noteDetails.note.text;

    return Scaffold(
      appBar: AppBar(title: Text("Add or edit note"),),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "id: ${noteDetails.note.id}", 
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800),
            ),
            Row(
              children: <Widget>[
                Text("title:"),
                Container(width: 8.0,),
                Expanded(
                  child: TextFormField(
                    initialValue: noteDetails.note.title,
                    maxLines: 1,
                    onChanged: (value) => _title = value,
                  )
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text("text:"),
                Container(width: 8.0,),
                Expanded(
                  child: TextFormField(
                    initialValue: noteDetails.note.text,
                    maxLines: 5,
                    onChanged: (value) => _text = value,
                  )
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if(noteDetails.exists) {
            store.dispatch(NoteListEditAction(
              id: noteDetails.note.id,
              title: _title,
              text: _text
            ));
          } else {
            store.dispatch(NoteListAddAction(
              id: noteDetails.note.id,
              title: _title,
              text: _text,
            ));
          }
          Navigator.pop(context);
        },
      )
    );
  }
}