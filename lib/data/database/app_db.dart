import 'dart:async';
import 'package:floor/floor.dart';
import 'package:pdf_sample/data/database/bookmark_dao.dart';
import 'package:pdf_sample/data/database/note_dao.dart';
import 'package:pdf_sample/data/entities/bookmark.dart';
import 'package:pdf_sample/data/entities/note.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part "app_db.g.dart";

@Database(version: 1, entities: [Bookmark, Note])
abstract class AppDatabase extends FloorDatabase {

  BookmarkDao get bookmarkDao;
  NoteDao get noteDao;

  static late AppDatabase _instance;
  static void setInstance(AppDatabase database){ _instance = database; }
  static AppDatabase getInstance(){ return _instance; }
}