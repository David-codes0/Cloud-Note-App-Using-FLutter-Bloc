
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' ;
import 'package:path/path.dart' show join;



class NotesService {
  Database? _db;

  List<DatabaseNote> _notes = [];

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance();
  factory NotesService() => _shared;

  final _notesStreamControlller = StreamController<List<DatabaseNote>>.broadcast();

  Stream<List<DatabaseNote>> get allNotes => _notesStreamControlller.stream;

  Future<DatabaseUser> getOrCreateUser ({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser{
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
     rethrow;
    }
  }

  Future<void> _cacheNotes() async{
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamControlller.add(_notes);
  }

  Future<DatabaseNote> updateNote({required DatabaseNote note,required String text,}) async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // mahe sure note exists before update
    await getNote(id: note.id);
    final updatescount = await db.update(noteTable , {
    textColumn: text,
    isSyncedWithCloudColumn: 0,
    });

    if (updatescount == 0){
      throw CouldNotUpdateNote();
    }else{
      final updateNote =  await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updateNote.id);
      _notes.add(updateNote);
      _notesStreamControlller.add(_notes);
      return updateNote;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> getNote({required int id}) async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable, limit: 1, where: 'id = ?', whereArgs: [id]);
    if(notes.isEmpty){
      throw CouldNotFindNote();
    }else{
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamControlller.add(_notes);
      return note;
    }

  }

  Future<int> deleteAllNote() async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];
    _notesStreamControlller.add(_notes);
    return numberOfDeletions;
  }

  Future<void> deleteNote({required int id}) async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deleteCount == 0){
      throw CouldNotDeleteNote();
    }
    else{
      _notes.removeWhere((note) => note.id == id);
      _notesStreamControlller.add(_notes);
    }

  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
// make sure owner exists in the database with the correct id 
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner){
      throw CouldNotFindUser();
    }
    const text = '';
    // create the note
    final noteId = await db.insert(
    noteTable,
    {userIdColumn: owner.id,
    textColumn: text,
    isSyncedWithCloudColumn: 1,
    });

    final note = DatabaseNote(
    id: noteId,
    userId: owner.id,
    text: text,
    isSyncedWithCloud: true,
    );

    _notes.add(note);
    _notesStreamControlller.add(_notes);
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async{
    await _ensureDbIsOpen();
    final db  = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
      );
     if (results.isNotEmpty){
      throw CouldNotFindUser();}
    else{
      return DatabaseUser.fromRow(results.first);
    }
    }

  Future<DatabaseUser> createUser({required String email}) async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
      );
    if (results.isNotEmpty){
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    
    return DatabaseUser(
    id: userId,
    email: email,
    );
  }

  Future<void> deleteUser({required String email}) async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
      );

      if (deletedCount != 1){
        throw CouldNotDeleteUSer();
      }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null){
      throw DatabaseIsNotOpen();
    }else{
      return db;
    }
  }

  Future<void> _ensureDbIsOpen () async {
    try {
      await open();
    } on DatabaseAlreadyOpenException{
      // empty
    }
  }
  Future<void> close () async{
    final db = _db;
    if (db == null){
      throw DatabaseIsNotOpen();
    } else{
    await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null){
      throw DatabaseAlreadyOpenException();
    }
  
  try{
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, dbName);
    final db = await openDatabase(dbPath);
    _db = db;
    // create the user Table   
    await db.execute(createUserTable);
    // create the note table
await db.execute(createNoteTable);
await _cacheNotes();

  } on MissingPlatformDirectoryException{
    throw UnableToGetDocumentsDirectory();
  }
  }
}



@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
  required this.id,
  required this.email,
  });

DatabaseUser.fromRow(Map<String, Object?> map) 
  
  : id = map[idColumn] as int,
    email = map[emailColumn] as String;
    
@override
  String toString() => 'Person, ID =  $id , Email = $email';

@override
bool operator == (covariant DatabaseUser other) => id == other.id;

@override
int get hashCode => id.hashCode;
}
const idColumn = 'id';
const emailColumn = 'email';


class DatabaseNote{
  final int id;
  final int userId;
  final bool isSyncedWithCloud;
  final String text;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map) 
  : id = map[idColumn] as int,
    userId = map[userIdColumn] as int,
    text = map[textColumn] as String,
    isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;
  @override
  String toString() => 'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

@override
bool operator == (covariant DatabaseUser other) => id == other.id;

@override
int get hashCode => id.hashCode;
}
const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const userIdColumn = 'user_Id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const createUserTable = '''
CREATE TABLE IF NOT EXIST "user" (
      "id"	INTEGER NOT NULL,
      "email"	TEXT NOT NULL UNIQUE,
      PRIMARY KEY("id" AUTOINCREMENT)
    );
    ''';
    const createNoteTable = '''
      CREATE TABLE IF NOT EXIST "note" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      );
''';