import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:iconicmusic/repository/sqlite_helper.dart';
import 'package:iconicmusic/utils/download_files.dart';

class MusicRepository {
  final db = DatabaseHelper();

  Future<List> getAllMusics() async {
    try {
      return await Supabase.instance.client.from('songs').select();
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
