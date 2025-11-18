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
      CREATE TABLE IF NOT EXISTS favorites_musics (
        id INTEGER PRIMARY KEY,
        title TEXT,
        artist TEXT,
        url_file TEXT,
        url_image TEXT,
        url_lrc TEXT,
        local_music TEXT,
        local_lrc TEXT,
        local_image TEXT,
        is_downloaded INT
      )
    ''');
    });
  }

  Future<void> saveDownloadMusic(Map<String, dynamic> music, int id)async{
    final db = await database;
    await db.update('favorites_musics', music,
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertMusic(Map<String, dynamic> music) async {
    final db = await database;
    await db.insert('favorites_musics', music,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, Object?>?> getDownloadMusicByid(int id) async {
    final db = await database;
    final result= await db.query(
      'favorites_musics',
      where: 'id = ?',
      columns: ['local_music','local_lrc','local_image', 'is_downloaded'],
      whereArgs: [id],
    );
    return result.isNotEmpty?result.first:null;
  }

  Future<List<Map<String, dynamic>>> getMusics() async {
    final db = await database;
    final result=await db.query('favorites_musics');
    return result.isNotEmpty?result:[];
  }

  Future<bool> getLikedById(int id) async {
    final db = await database;
    final result= await db.query(
      'favorites_musics',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty?true:false;
  }

  Future<void> deleteMusic(int id) async {
    final db = await database;
    await db.delete(
      'favorites_musics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
