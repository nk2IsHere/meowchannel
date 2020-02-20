// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_list_actions.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

abstract class _$NoteListAddAction extends NoteListAction {
  _$NoteListAddAction();

  int get id;
  String get title;
  String get text;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! NoteListAddAction) return false;

    return true &&
        this.id == other.id &&
        this.title == other.title &&
        this.text == other.text;
  }

  int get hashCode {
    return mapPropsToHashCode([id, title, text]);
  }

  String toString() {
    return 'NoteListAddAction <\'id\': ${this.id},\'title\': ${this.title},\'text\': ${this.text},>';
  }

  NoteListAddAction copyWith({int id, String title, String text}) {
    return NoteListAddAction(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
    );
  }
}

abstract class _$NoteListRemoveAction extends NoteListAction {
  _$NoteListRemoveAction();

  int get id;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! NoteListRemoveAction) return false;

    return true && this.id == other.id;
  }

  int get hashCode {
    return mapPropsToHashCode([id]);
  }

  String toString() {
    return 'NoteListRemoveAction <\'id\': ${this.id},>';
  }

  NoteListRemoveAction copyWith({int id}) {
    return NoteListRemoveAction(
      id: id ?? this.id,
    );
  }
}

abstract class _$NoteListEditAction extends NoteListAction {
  _$NoteListEditAction();

  int get id;
  String get title;
  String get text;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! NoteListEditAction) return false;

    return true &&
        this.id == other.id &&
        this.title == other.title &&
        this.text == other.text;
  }

  int get hashCode {
    return mapPropsToHashCode([id, title, text]);
  }

  String toString() {
    return 'NoteListEditAction <\'id\': ${this.id},\'title\': ${this.title},\'text\': ${this.text},>';
  }

  NoteListEditAction copyWith({int id, String title, String text}) {
    return NoteListEditAction(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
    );
  }
}

abstract class _$NoteListUpdateStateAction extends NoteListStateAction {
  _$NoteListUpdateStateAction();

  List<Note> get noteList;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! NoteListUpdateStateAction) return false;

    return true && this.noteList == other.noteList;
  }

  int get hashCode {
    return mapPropsToHashCode([noteList]);
  }

  String toString() {
    return 'NoteListUpdateStateAction <\'noteList\': ${this.noteList},>';
  }

  NoteListUpdateStateAction copyWith({List<Note> noteList}) {
    return NoteListUpdateStateAction(
      noteList: noteList ?? this.noteList,
    );
  }
}
