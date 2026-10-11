import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iconicmusic/repository/sqlite_helper.dart';
import 'package:iconicmusic/utils/download_files.dart';

class MusicRepository {
  final db = DatabaseHelper();
  Connection? connection;

  Future<Connection> get dbConnection async {
    if (connection != null && connection!.isOpen) {
      return connection!;
    }

    connection = await Connection.open(
      Endpoint(
        host: dotenv.env['NEON_HOST'] ?? '',
        database: dotenv.env['NEON_DATABASE'] ?? '',
        username: dotenv.env['NEON_USER'] ?? '',
        password: dotenv.env['NEON_PASSWORD'] ?? '',
        port: 5432,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.require
      ),
    );

    return connection!;
  }

  Future<List> getAllMusics() async {
    try {
      final conn = await dbConnection;
      final result = await conn.execute('SELECT * FROM songs');
      return result.map((row) => row.toColumnMap()).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFavoritesMusics() async {
    return await db.getMusics();
  }

  Future<void> insertMusic(Map<String, dynamic> music) async {
    await db.insertMusic(music);
  }

  Future<void> deleteMusic(int id) async {
    await db.deleteMusic(id);
  }

  Future<bool> getLikedMusic(int id) async {
    return await db.getLikedById(id);
  }

  Future<void> insertDownloadMusic(int id, Map<String, dynamic> music) async {
    final preparedMusicPaths = await downloadMusicFiles(music);
    await db.saveDownloadMusic(preparedMusicPaths, id);
  }

  Future<Map<String, dynamic>?> getDownloadMusic(int id) async {
    final result = await db.getDownloadMusicByid(id);
    if(result==null) return null;
    return {
      'url_image': result['local_image'],
      'url_file': result['local_music'],
      'url_lrc': result['local_lrc'],
    };
  }
}
