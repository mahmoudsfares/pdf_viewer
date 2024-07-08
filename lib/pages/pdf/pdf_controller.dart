import 'dart:async';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:pdf_sample/data/database/app_db.dart';
import 'package:pdf_sample/data/entities/bookmark.dart';
import 'package:pdf_sample/data/entities/note.dart';
import 'package:pdf_sample/data/resource_states.dart';

class PDFController {
  final AppDatabase database = AppDatabase.getInstance();

  final int catalogueId = 1;
  RxInt bookmarkPage = (-2).obs; // -2: inti (not fetched yet), -1: no bookmark
  RxInt currentPage = 0.obs;

  Future<void> getBookmark() async {
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

  Rx<StateResource<List<Note>>> notes = StateResource<List<Note>>.init().obs;

  Future<void> getNotes() async {
    notes.value = StateResource.loading();
    try {
      List<Note> notes = await database.noteDao.findNotesInPage(catalogueId, currentPage.value) ?? List<Note>.empty();
      this.notes.value = StateResource<List<Note>>.success(notes);
    } catch (e) {
      notes.value = StateResource.error('Error');
    }
  }

  Future<void> addNote(Note note) async {
    notes.value = StateResource.loading();
    try {
      await database.noteDao.insertNote(note);
      getNotes();
    } catch(e) {
      notes.value = StateResource.error('Error');
    }
  }

  Future<void> removeNote(Note note) async {
    notes.value = StateResource.loading();
    try {
      await database.noteDao.removeNote(note);
      getNotes();
    } catch(e) {
      notes.value = StateResource.error('Error');
    }
  }
}
