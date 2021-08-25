// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_list_state.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$NoteListState {
  List<Note> get noteList;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! NoteListState) return false;

    return true && this.noteList == other.noteList;
  }

  int get hashCode {
    return mapPropsToHashCode([noteList]);
  }

  String toString() {
    return 'NoteListState(noteList=${this.noteList})';
  }

  NoteListState copyWith({List<Note> noteList}) {
    return NoteListState(
      noteList: noteList ?? this.noteList,
    );
  }
}
