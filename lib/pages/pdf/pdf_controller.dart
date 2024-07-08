import 'dart:async';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
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

  RxInt bookmarkPage = (-2).obs; // -2: not fetched yet, -1: no bookmark
  RxInt currentPage = 0.obs;

  Future<void> getBookmark(int catalogueId) async {
    try {
      Bookmark? bookmark = await database.bookmarkDao.findBookmarkByCatalogueId(catalogueId);
      if(bookmark != null) {
        bookmarkPage.value = bookmark.pageNumber;
      } else {
        bookmarkPage.value = -1;
      }
    } catch (e) {
      bookmarkPage.value = -1;
    }
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    try {
      await database.bookmarkDao.insertBookmark(bookmark);
      bookmarkPage.value = bookmark.pageNumber;
    }
    catch (e){
      // TODO
    }
  }

  Future<void> removeBookmark(Bookmark bookmark) async {
    try{
      await database.bookmarkDao.removeBookmark(bookmark);
      bookmarkPage.value = -1;
    }
    catch (e){
      // TODO
    }
  }

  void dispose() {
    _getBookmarkStreamController.close();
    _addBookmarkStreamController.close();
    _removeBookmarkStreamController.close();
  }
}
