import 'package:flutter/widgets.dart';
import 'package:meowchannel/extensions/flutter/store_provider_mixin.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MultiStoreProvider extends StatelessWidget {
  final Widget child;
  final List<StoreProviderSingleChildWidget> providers;

  const MultiStoreProvider({
    Key key,
    @required this.providers,
    @required this.child,
  })  : assert(providers != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
}