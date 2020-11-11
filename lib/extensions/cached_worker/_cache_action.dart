
class CacheAction {
}

class SetCacheAction extends CacheAction {
  final List<String> key;
  final DateTime validUntil;

  SetCacheAction({
    this.key,
    this.validUntil
  });
}

class RemoveCacheAction extends CacheAction {
  final List<String> key;

  RemoveCacheAction({
    this.key
  });
}