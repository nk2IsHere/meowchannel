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

abstract class _$ValuesUiAddValueAction extends ValuesUiAction {
  _$ValuesUiAddValueAction();

  String get value;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! ValuesUiAddValueAction) return false;

    return true && this.value == other.value;
  }

  int get hashCode {
    return mapPropsToHashCode([value]);
  }

  String toString() {
    return 'ValuesUiAddValueAction <\'value\': ${this.value},>';
  }

  ValuesUiAddValueAction copyWith({String value}) {
    return ValuesUiAddValueAction(
      value: value ?? this.value,
    );
  }
}
