
class IsolateInitializeArguments {
  final Map<String, Object> args;

  const IsolateInitializeArguments(this.args);

  T get<T>(String key) {
    final arg = args[key];
    if(arg is! T) {
      throw TypeError();
    }

    return arg;
  }
}
