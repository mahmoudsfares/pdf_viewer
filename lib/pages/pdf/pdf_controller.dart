import 'dart:async';
import 'package:pdf_sample/data/database/app_db.dart';
import 'package:pdf_sample/data/entities/bookmark.dart';

class PDFController {

  final StreamController<Bookmark?> _getBookmarkStreamController = StreamController<Bookmark>();
  final StreamController<int> _addBookmarkStreamController = StreamController<int>();
  final StreamController<int> _removeBookmarkStreamController = StreamController<int>();

  Stream<Bookmark?> get getBookmarkStream => _getBookmarkStreamController.stream;
  Stream<int> get addBookmarkStream => _addBookmarkStreamController.stream;
  Stream<int> get removeBookmarkStream => _removeBookmarkStreamController.stream;

  final AppDatabase database = AppDatabase.getInstance();

  void getBookmark(int catalogueId) async {
    try {
      Bookmark? bookmark = await database.bookmarkDao.findBookmarkByCatalogueId(catalogueId);
      _getBookmarkStreamController.sink.add(bookmark);
    } catch (e) {
      // the only probable error to occur is not finding the searched person
      _getBookmarkStreamController.sink.add(null);
    }
  }

  void addBookmark(Bookmark bookmark) async {
    try{
      await database.bookmarkDao.insertBookmark(bookmark);
      // add 0 to the stream if the person was added successfully
      _addBookmarkStreamController.sink.add(0);
    }
    catch (e){
      // add -1 to the stream if the person was not added
      // most probably unique constraint failed (duplicate primary keys)
      _addBookmarkStreamController.sink.add(-1);
    }
  }

  void removeBookmark(Bookmark bookmark) async {
    try{
      await database.bookmarkDao.removeBookmark(bookmark);
      // add 0 to the stream if the person was added successfully
      _removeBookmarkStreamController.sink.add(0);
    }
    catch (e){
      // add -1 to the stream if the person was not added
      // most probably unique constraint failed (duplicate primary keys)
      _removeBookmarkStreamController.sink.add(-1);
    }
  }

  void dispose() {
    _getBookmarkStreamController.close();
    _addBookmarkStreamController.close();
    _removeBookmarkStreamController.close();
  }
}
