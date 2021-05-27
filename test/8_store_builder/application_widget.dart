import 'package:flutter/material.dart';
import 'package:meowchannel/extensions/flutter/store_builder.dart';
import 'package:meowchannel/meowchannel.dart';

import '../1_basic_store/root_actions.dart';
import '../1_basic_store/root_state.dart';

class BuilderApplicationWidget extends StatefulWidget {

  @override
  State<BuilderApplicationWidget> createState() =>
    _ApplicationWidgetState();
}

class _ApplicationWidgetState extends State<BuilderApplicationWidget> {

  @override
  Widget build(BuildContext context) {
    final rootStore = StoreProvider.of<RootState>(context);

    return StoreBuilder<RootState>(
      store: rootStore,
      condition: (previous, current) => previous?.state.value != current.state.value,
      builder: (context, state, action) {
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
                  rootStore.dispatch(RootIncreaseAction());
                },
              ),
              RaisedButton(
                child: Text("-"),
                key: Key('button-decrease'),
                onPressed: () {
                  rootStore.dispatch(RootDecreaseAction());
                },
              )
            ],
          ),
        );
      },
    );
  }
}
