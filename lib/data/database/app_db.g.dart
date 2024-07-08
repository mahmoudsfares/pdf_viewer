// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BookmarkDao? _bookmarkDaoInstance;

  NoteDao? _noteDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Bookmark` (`catalogueId` INTEGER NOT NULL, `pageNumber` INTEGER NOT NULL, PRIMARY KEY (`catalogueId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Note` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `catalogueId` INTEGER NOT NULL, `pageNumber` INTEGER NOT NULL, `note` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BookmarkDao get bookmarkDao {
    return _bookmarkDaoInstance ??= _$BookmarkDao(database, changeListener);
  }

  @override
  NoteDao get noteDao {
    return _noteDaoInstance ??= _$NoteDao(database, changeListener);
  }
}

class _$BookmarkDao extends BookmarkDao {
  _$BookmarkDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _bookmarkInsertionAdapter = InsertionAdapter(
            database,
            'Bookmark',
            (Bookmark item) => <String, Object?>{
                  'catalogueId': item.catalogueId,
                  'pageNumber': item.pageNumber
                }),
        _bookmarkDeletionAdapter = DeletionAdapter(
            database,
            'Bookmark',
            ['catalogueId'],
            (Bookmark item) => <String, Object?>{
                  'catalogueId': item.catalogueId,
                  'pageNumber': item.pageNumber
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Bookmark> _bookmarkInsertionAdapter;

  final DeletionAdapter<Bookmark> _bookmarkDeletionAdapter;

  @override
  Future<Bookmark?> findBookmarkByCatalogueId(int catalogueId) async {
    return _queryAdapter.query('SELECT * FROM Bookmark WHERE catalogueId = ?1',
        mapper: (Map<String, Object?> row) => Bookmark(
            catalogueId: row['catalogueId'] as int,
            pageNumber: row['pageNumber'] as int),
        arguments: [catalogueId]);
  }

  @override
  Future<void> insertBookmark(Bookmark bookmark) async {
    await _bookmarkInsertionAdapter.insert(
        bookmark, OnConflictStrategy.replace);
  }

  @override
  Future<void> removeBookmark(Bookmark bookmark) async {
    await _bookmarkDeletionAdapter.delete(bookmark);
  }
}

class _$NoteDao extends NoteDao {
  _$NoteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _noteInsertionAdapter = InsertionAdapter(
            database,
            'Note',
            (Note item) => <String, Object?>{
                  'id': item.id,
                  'catalogueId': item.catalogueId,
                  'pageNumber': item.pageNumber,
                  'note': item.note
                }),
        _noteDeletionAdapter = DeletionAdapter(
            database,
            'Note',
            ['id'],
            (Note item) => <String, Object?>{
                  'id': item.id,
                  'catalogueId': item.catalogueId,
                  'pageNumber': item.pageNumber,
                  'note': item.note
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Note> _noteInsertionAdapter;

  final DeletionAdapter<Note> _noteDeletionAdapter;

  @override
  Future<List<Note>?> findNotesInPage(
    int catalogueId,
    int pageNumber,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Note WHERE catalogueId = ?1 AND pageNumber = ?2',
        mapper: (Map<String, Object?> row) => Note(
            id: row['id'] as int,
            catalogueId: row['catalogueId'] as int,
            pageNumber: row['pageNumber'] as int,
            note: row['note'] as String),
        arguments: [catalogueId, pageNumber]);
  }

  @override
  Future<void> insertNote(Note note) async {
    await _noteInsertionAdapter.insert(note, OnConflictStrategy.abort);
  }

  @override
  Future<void> removeNote(Note note) async {
    await _noteDeletionAdapter.delete(note);
  }
}
