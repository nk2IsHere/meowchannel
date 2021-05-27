// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$Note {
  int get id;
  String get title;
  String get text;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! Note) return false;

    return true &&
        this.id == other.id &&
        this.title == other.title &&
        this.text == other.text;
  }

  int get hashCode {
    return mapPropsToHashCode([id, title, text]);
  }

  String toString() {
    return 'Note(id=${this.id},title=${this.title},text=${this.text})';
  }

  Note copyWith({int? id, String? title, String? text}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
    );
  }
}
