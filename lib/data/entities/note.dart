import 'package:floor/floor.dart';

@entity
class Note {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int fileId;
  final int pageNumber;
  final String note;

  Note({required this.id, required this.fileId, required this.pageNumber, required this.note});
}
