abstract class CacheRegistry {
  static const DEFAULT_VALID_DURATION = const Duration(minutes: 5);

  void remove(String key);
  bool get(String key);
  void set(String key, { Duration expireIn = DEFAULT_VALID_DURATION });

  void removeAll(List<String> key);
  bool getAll(List<String> key);
  void setAll(List<String> key, { Duration expireIn = DEFAULT_VALID_DURATION });
}
