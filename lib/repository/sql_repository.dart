import 'package:iconicmusic/repository/sqlite_helper.dart';

class sqliteRepository{
  final db=DatabaseHelper();

  Future<void> insertDownloadMusic(Map<String, dynamic> music)async{
    await db.saveDownloadMusic(music);
  }

  Future<void> insertMusic(Map<String, dynamic> music)async{
    await db.insertMusic(music);
  }

  Future<List<Map<String, dynamic>>> getLikedmusic(int id)async{
    return await db.getLikedById(id);
  }

  Future<List<Map<String, dynamic>>> getFavoritesMusics()async{
    return await db.getMusics();
  }

  Future<List<Map<String, dynamic>>> getDownloadMusic(int id)async{
    return await db.getDownloadMusicByid(id);
  }

  Future<void> deleteMusic(int id)async{
    return await db.deleteMusic(id);
  }
}