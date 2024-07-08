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
  Rx<StateResource<int>> loadFileState = StateResource<int>.init().obs;
  RxInt currentPage = 0.obs;

  Future<void> checkForBookmark() async {
    loadFileState.value = StateResource.loading();
    try {
      Bookmark? bookmark = await database.bookmarkDao.findBookmarkByFileId(fileId);
      if(bookmark != null) {
        loadFileState.value = StateResource.success(bookmark.pageNumber);
      } else {
        loadFileState.value = StateResource.success(-1);
      }
    } catch (e) {
      loadFileState.value = StateResource.error('Error loading file');
    }
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    try {
      await database.bookmarkDao.insertBookmark(bookmark);
      loadFileState.value = StateResource.success(bookmark.pageNumber);
    }
    catch (e){
      loadFileState.value = StateResource.error('Error occurred');
    }
  }

  Future<void> removeBookmark(Bookmark bookmark) async {
    try{
      await database.bookmarkDao.removeBookmark(bookmark);
      loadFileState.value = StateResource.success(-1);
    }
    catch (e){
      loadFileState.value = StateResource.error('Error occurred');
    }
  }

  void onError(String error) => loadFileState.value = StateResource.error(error);

  Rx<StateResource<List<Note>>> notes = StateResource<List<Note>>.init().obs;

  Future<void> getNotes() async {
    notes.value = StateResource.loading();
    try {
      List<Note> notes = await database.noteDao.findNotesInPage(fileId, currentPage.value) ?? List<Note>.empty();
      this.notes.value = StateResource<List<Note>>.success(notes);
    } catch (e) {
      notes.value = StateResource.error('Error loading notes');
    }
  }

  Future<void> addNote(Note note) async {
    notes.value = StateResource.loading();
    try {
      await database.noteDao.insertNote(note);
      getNotes();
    } catch(e) {
      notes.value = StateResource.error('Error occurred');
    }
  }

  Future<void> removeNote(Note note) async {
    notes.value = StateResource.loading();
    try {
      await database.noteDao.removeNote(note);
      getNotes();
    } catch(e) {
      notes.value = StateResource.error('Error occurred');
    }
  }
}
