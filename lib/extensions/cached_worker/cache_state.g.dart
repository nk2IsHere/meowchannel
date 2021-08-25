// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_state.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$CacheState {
  Map<List<String>, DateTime> get caches;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! CacheState) return false;

    return true && this.caches == other.caches;
  }

  int get hashCode {
    return mapPropsToHashCode([caches]);
  }

  String toString() {
    return 'CacheState(caches=${this.caches})';
  }

  CacheState copyWith({Map<List<String>, DateTime> caches}) {
    return CacheState(
      caches: caches ?? this.caches,
    );
  }
}
