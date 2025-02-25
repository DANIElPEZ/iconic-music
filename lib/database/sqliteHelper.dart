import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Inicializa la base de datos
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // Abre o crea la base de datos
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'MyMusics.db');
    return await openDatabase(path, version: 2, onCreate: (db, version) {
      db.execute(
          '''
      CREATE TABLE IF NOT EXISTS favorites_musics (
        id INTEGER PRIMARY KEY,
        title TEXT,
        artist TEXT,
        file_url TEXT,
        image_url TEXT,
        url_lrc TEXT
      )
    '''
      );
    },
        onUpgrade: (db, oldVersion, newVersion){
      if(oldVersion<2){
        db.execute('ALTER TABLE favorites_musics ADD COLUMN url_lrc TEXT');
      }
        },
        onOpen: (db) {
          db.execute(
              '''
      CREATE TABLE IF NOT EXISTS favorites_musics (
        id INTEGER PRIMARY KEY,
        title TEXT,
        artist TEXT,
        file_url TEXT,
        image_url TEXT,
        url_lrc TEXT
      )
      '''
          );
        });
  }

  // Inserta una nueva musica
  Future<void> insertMusic(Map<String, dynamic> music) async {
    final db = await database;
    await db.insert(
      'favorites_musics',
      music,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  // Consulta todas las musicas
  Future<List<Map<String, dynamic>>> getMusic() async {
    final db = await database;
    return await db.query('favorites_musics');
  }

  // Elimina una musica por su id
  Future<void> deleteMusic(int id) async {
    final db = await database;
    await db.delete(
      'favorites_musics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Obtener musica por ID
  Future<List<Map<String, dynamic>>> getMusicById(int id) async {
    final db = await database;
    return await db.query(
      'favorites_musics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}