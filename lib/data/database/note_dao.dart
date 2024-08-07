import 'package:floor/floor.dart';
import 'package:pdf_sample/data/entities/note.dart';

@dao
abstract class NoteDao {

  @Query('SELECT * FROM Note WHERE fileId = :fileId AND pageNumber = :pageNumber')
  Future<List<Note>?> findNotesInPage(int fileId, int pageNumber);

  @insert
  Future<void> insertNote(Note note);

  @delete
  Future<void> removeNote(Note note);
}