// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_state.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

abstract class _$FirstRootState {
  const _$FirstRootState();

  int get value;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! FirstRootState) return false;

    return true && this.value == other.value;
  }

  int get hashCode {
    return mapPropsToHashCode([value]);
  }

  String toString() {
    return 'FirstRootState(value=${this.value},)';
  }

  FirstRootState copyWith({int value}) {
    return FirstRootState(
      value: value ?? this.value,
    );
  }
}

abstract class _$SecondRootState {
  const _$SecondRootState();

  int get value;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! SecondRootState) return false;

    return true && this.value == other.value;
  }

  int get hashCode {
    return mapPropsToHashCode([value]);
  }

  String toString() {
    return 'SecondRootState(value=${this.value},)';
  }

  SecondRootState copyWith({int value}) {
    return SecondRootState(
      value: value ?? this.value,
    );
  }
}
