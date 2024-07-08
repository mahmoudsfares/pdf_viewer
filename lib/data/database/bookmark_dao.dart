import 'package:floor/floor.dart';
import 'package:pdf_sample/data/entities/bookmark.dart';

@dao
abstract class BookmarkDao {

  @Query('SELECT * FROM Bookmark WHERE fileId = :fileId')
  Future<Bookmark?> findBookmarkByFileId(int fileId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertBookmark(Bookmark bookmark);

  @delete
  Future<void> removeBookmark(Bookmark bookmark);
}