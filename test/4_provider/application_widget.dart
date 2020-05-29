import 'package:flutter/material.dart';
import 'package:meowchannel/meowchannel.dart';

import '../1_basic_store/root_actions.dart';
import '../1_basic_store/root_state.dart';

class ApplicationWidget extends StatefulWidget {

  @override
  State<ApplicationWidget> createState() =>
    _ApplicationWidgetState();
}

class _ApplicationWidgetState extends StoreState<ApplicationWidget> {

  @override
  List<Store> requireStores(BuildContext context) => [
    StoreProvider.of<RootState>(context)
  ];

  @override
  Widget build(BuildContext context) {
    Store<RootState> store = getStore<RootState>();
    RootState state = getState<RootState>();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(
            state.value.toString(),
            key: Key('text-value'),
          ),
          RaisedButton(
            child: Text("+"),
            key: Key('button-increase'),
            onPressed: () {
              store.dispatch(RootIncreaseAction());
            },
          ),
          RaisedButton(
            child: Text("-"),
            key: Key('button-decrease'),
            onPressed: () {
              store.dispatch(RootDecreaseAction());
            },
          )
        ],
      ),
    );
  }

}