import 'dart:async';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:pdf_sample/data/database/app_db.dart';
import 'package:pdf_sample/data/entities/bookmark.dart';
import 'package:pdf_sample/data/entities/note.dart';
import 'package:pdf_sample/data/resource_states.dart';

class PDFController {
  final AppDatabase database = AppDatabase.getInstance();

  final int fileId = 1;

  // saves the value of the bookmarked page, if set to success(-1): no bookmark
  final Rx<StateResource<int>> _loadBookmarkState = StateResource<int>.init().obs;
  StateResource<int> get loadBookmarkState => _loadBookmarkState.value;
  void onFileLoadingError(String error) => _loadBookmarkState.value = StateResource.error(error);

  RxInt currentPage = 0.obs;

  Future<void> checkForBookmark() async {
    _loadBookmarkState.value = StateResource.loading();
    try {
      Bookmark? bookmark = await database.bookmarkDao.findBookmarkByFileId(fileId);
      if(bookmark != null) {
        _loadBookmarkState.value = StateResource.success(bookmark.pageNumber);
      } else {
        _loadBookmarkState.value = StateResource.success(-1);
      }
    } catch (e) {
      _loadBookmarkState.value = StateResource.error('Error loading file');
    }
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    try {
      await database.bookmarkDao.insertBookmark(bookmark);
      _loadBookmarkState.value = StateResource.success(bookmark.pageNumber);
    }
    catch (e){
      _loadBookmarkState.value = StateResource.error('Error occurred');
    }
  }

  Future<void> removeBookmark(Bookmark bookmark) async {
    try{
      await database.bookmarkDao.removeBookmark(bookmark);
      _loadBookmarkState.value = StateResource.success(-1);
    }
    catch (e){
      _loadBookmarkState.value = StateResource.error('Error occurred');
    }
  }

  final Rx<StateResource<List<Note>>> _loadNotesState = StateResource<List<Note>>.init().obs;
  StateResource<List<Note>> get loadNotesState => _loadNotesState.value;

  Future<void> getNotes() async {
    _loadNotesState.value = StateResource.loading();
    try {
      List<Note> notes = await database.noteDao.findNotesInPage(fileId, currentPage.value) ?? List<Note>.empty();
      _loadNotesState.value = StateResource<List<Note>>.success(notes);
    } catch (e) {
      _loadNotesState.value = StateResource.error('Error loading notes');
    }
  }

  Future<void> addNote(Note note) async {
    _loadNotesState.value = StateResource.loading();
    try {
      await database.noteDao.insertNote(note);
      getNotes();
    } catch(e) {
      _loadNotesState.value = StateResource.error('Error occurred');
    }
  }

  Future<void> removeNote(Note note) async {
    _loadNotesState.value = StateResource.loading();
    try {
      await database.noteDao.removeNote(note);
      getNotes();
    } catch(e) {
      _loadNotesState.value = StateResource.error('Error occurred');
    }
  }
}
