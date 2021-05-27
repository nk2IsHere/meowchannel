import 'package:flutter/widgets.dart';
import 'package:meowchannel/extensions/flutter/store_provider_mixin.dart';
import 'package:provider/provider.dart';

class MultiStoreProvider extends StatelessWidget {
  final Widget child;
  final List<StoreProviderSingleChildWidget> providers;

  const MultiStoreProvider({
    Key? key,
    required this.providers,
    required this.child,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
}
