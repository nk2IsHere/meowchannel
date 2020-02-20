// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'values_actions.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

abstract class _$ValuesAddValueAction extends ValuesAction {
  _$ValuesAddValueAction();

  String get value;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! ValuesAddValueAction) return false;

    return true && this.value == other.value;
  }

  int get hashCode {
    return mapPropsToHashCode([value]);
  }

  String toString() {
    return 'ValuesAddValueAction <\'value\': ${this.value},>';
  }

  ValuesAddValueAction copyWith({String value}) {
    return ValuesAddValueAction(
      value: value ?? this.value,
    );
  }
}

abstract class _$ValuesTesterAddValueAction extends ValuesTesterAction {
  _$ValuesTesterAddValueAction();

  String get value;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! ValuesTesterAddValueAction) return false;

    return true && this.value == other.value;
  }

  int get hashCode {
    return mapPropsToHashCode([value]);
  }

  String toString() {
    return 'ValuesTesterAddValueAction <\'value\': ${this.value},>';
  }

  ValuesTesterAddValueAction copyWith({String value}) {
    return ValuesTesterAddValueAction(
      value: value ?? this.value,
    );
  }
}
