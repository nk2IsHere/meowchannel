import 'package:flutter/material.dart';
import 'package:meowchannel/meowchannel.dart';

import 'root_actions.dart';
import 'root_state.dart';

class MultiApplicationWidget extends StatefulWidget {

  @override
  State<MultiApplicationWidget> createState() =>
    _MultiApplicationWidgetState();
}

class _MultiApplicationWidgetState extends StoreState<MultiApplicationWidget> {

  @override
  List<Store> requireStores(BuildContext context) => [
    StoreProvider.of<FirstRootState>(context),
    StoreProvider.of<SecondRootState>(context)
  ];

  @override
  Widget build(BuildContext context) {
    Store<FirstRootState> firstStore = getStore<FirstRootState>();
    FirstRootState firstState = getState<FirstRootState>();
    Store<SecondRootState> secondStore = getStore<SecondRootState>();
    SecondRootState secondState = getState<SecondRootState>();

    return Scaffold(
      body: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                firstState.value.toString(),
                key: Key('first-text-value'),
              ),
              RaisedButton(
                child: Text("+"),
                key: Key('first-button-increase'),
                onPressed: () {
                  firstStore.dispatch(FirstRootIncreaseAction());
                },
              ),
              RaisedButton(
                child: Text("-"),
                key: Key('first-button-decrease'),
                onPressed: () {
                  firstStore.dispatch(FirstRootDecreaseAction());
                },
              )
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                secondState.value.toString(),
                key: Key('second-text-value'),
              ),
              RaisedButton(
                child: Text("+"),
                key: Key('second-button-increase'),
                onPressed: () {
                  secondStore.dispatch(SecondRootIncreaseAction());
                },
              ),
              RaisedButton(
                child: Text("-"),
                key: Key('second-button-decrease'),
                onPressed: () {
                  secondStore.dispatch(SecondRootDecreaseAction());
                },
              )
            ],
          ),
        ],
      )
    );
  }

}