
import 'package:dataclass_beta/dataclass_beta.dart';

part 'note_model.g.dart';

@DataClass()
class Note with _$Note {
  final int id;
  final String title;
  final String text;

  Note({
    this.id,
    this.title,
    this.text
  });
}