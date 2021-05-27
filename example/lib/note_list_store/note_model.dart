
import 'package:dataclass_beta/dataclass_beta.dart';

part 'note_model.g.dart';

@DataClass()
class Note with _$Note {
  final int id;
  final String title;
  final String text;

  Note({
    required this.id,
    required this.title,
    required this.text
  });
}
