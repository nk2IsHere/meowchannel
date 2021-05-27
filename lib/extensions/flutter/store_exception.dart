
class StoreException implements Exception {

  final String message;
  const StoreException(this.message);

  const StoreException.noStoreFound(Type storeType)
      : message = 'No store of type $storeType found';

  String toString() {
    StringBuffer sb = new StringBuffer();
    sb.write("StoreException");
    if (message.isNotEmpty) {
      sb.write(": $message");
    }
    return sb.toString();
  }
}
