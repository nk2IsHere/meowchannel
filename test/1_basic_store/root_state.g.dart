// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_state.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

abstract class _$RootState {
  const _$RootState();

  int get value;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! RootState) return false;

    return true && this.value == other.value;
  }

  int get hashCode {
    return mapPropsToHashCode([value]);
  }

  String toString() {
    return 'RootState(value=${this.value},)';
  }

  RootState copyWith({int value}) {
    return RootState(
      value: value ?? this.value,
    );
  }
}
