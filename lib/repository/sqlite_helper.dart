import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'MyMusics.db');
    return await openDatabase(path, version: 3, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE download_musics (
            id INTEGER PRIMARY KEY,
            file_music BLOB,
            file_lrc BLOB,
            file_image INT,
          )
        ''');
      await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites_musics (
        id INTEGER PRIMARY KEY,
        title TEXT,
        artist TEXT,
        url_file TEXT,
        url_image TEXT,
        url_lrc TEXT
      )
    ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 3) {
        await db.execute("DROP TABLE IF EXISTS favorites_musics");
        await db.execute("DROP TABLE IF EXISTS download_musics");
        await db.execute('''
          CREATE TABLE download_musics (
            id INTEGER PRIMARY KEY,
            file_music BLOB,
            file_lrc BLOB,
            file_image INT,
          )
        ''');
        await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites_musics (
        id INTEGER PRIMARY KEY,
        title TEXT,
        artist TEXT,
        url_file TEXT,
        url_image TEXT,
        url_lrc TEXT
      )
    ''');
      }
    });
  }

  Future<void> saveDownloadMusic(Map<String, dynamic> music)async{
    final db = await database;
    await db.insert('download_musics', music,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertMusic(Map<String, dynamic> music) async {
    final db = await database;
    await db.insert('favorites_musics', music,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getDownloadMusicByid(int id) async {
    final db = await database;
    return await db.query(
      'download_musics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getMusics() async {
    final db = await database;
    return await db.query('favorites_musics');
  }

  Future<List<Map<String, dynamic>>> getLikedById(int id) async {
    final db = await database;
    return await db.query(
      'favorites_musics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteMusic(int id) async {
    final db = await database;
    await db.delete(
      'favorites_musics',
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'download_musics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
