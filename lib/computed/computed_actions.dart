
class ComputedStorageUpdateAction {
  final Map<String, dynamic> data;

  ComputedStorageUpdateAction({
    this.data
  });

  @override
  String toString() {
    return 'ComputedStorageUpdateAction{data: $data}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComputedStorageUpdateAction &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}
