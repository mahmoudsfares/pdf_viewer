import 'package:floor/floor.dart';
import 'package:pdf_sample/data/entities/bookmark.dart';

@dao
abstract class BookmarkDao {

  @Query('SELECT * FROM Bookmark WHERE catalogueId = :catalogueId')
  Future<Bookmark?> findBookmarkByCatalogueId(int catalogueId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertBookmark(Bookmark bookmark);

  @delete
  Future<void> removeBookmark(Bookmark bookmark);
}