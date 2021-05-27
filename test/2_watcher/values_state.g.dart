// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'values_state.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$ValuesState {
  List<String> get values;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! ValuesState) return false;

    return true && this.values == other.values;
  }

  int get hashCode {
    return mapPropsToHashCode([values]);
  }

  String toString() {
    return 'ValuesState(values=${this.values})';
  }

  ValuesState copyWith({List<String>? values}) {
    return ValuesState(
      values: values ?? this.values,
    );
  }
}
