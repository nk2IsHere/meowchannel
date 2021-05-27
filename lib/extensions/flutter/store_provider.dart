import 'package:flutter/material.dart';
import 'package:meowchannel/core/store.dart';
import 'package:meowchannel/extensions/flutter/store_provider_mixin.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


class StoreProvider<_S> extends SingleChildStatelessWidget with StoreProviderSingleChildWidget {
  final Widget? child;
  final bool lazy;
  final Create<Store<_S>> _create;
  final Dispose<Store<_S>>? _dispose;

  StoreProvider({
    Key? key,
    required Create<Store<_S>> create,
    Widget? child,
    bool? lazy,
  }): this._(
    key: key,
    create: create,
    dispose: (_, store) => store.close(),
    child: child,
    lazy: lazy ?? false,
  );

  StoreProvider._({
    Key? key,
    required Create<Store<_S>> create,
    Dispose<Store<_S>>? dispose,
    this.child,
    required this.lazy,
  }): _create = create,
    _dispose = dispose,
    super(key: key, child: child);

  static Store<S> of<S>(BuildContext context) {
    try {
      return Provider.of<Store<S>>(context, listen: false);
    } on ProviderNotFoundException catch (_) {
      throw FlutterError(
        """
          Store of state "${S.runtimeType}" is not found within this BuildContext
          Make sure, that this widget is a child of StoreProvider<${S.runtimeType}>
        """,
      );
    } 
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
    InheritedProvider<Store<_S>>(
      create: _create,
      dispose: _dispose,
      child: child,
      lazy: lazy,
    );
}
