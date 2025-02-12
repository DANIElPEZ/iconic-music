import 'package:iconicmusic/models/musicModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iconicmusic/database/sqliteHelper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class musicProvider extends ChangeNotifier {
  DatabaseHelper dbHelper = DatabaseHelper();
  bool isLoading = false;
  bool isAdded = false;
  bool getConnection = false;
  List<Musicmodel> musics = [];
  List<Musicmodel> myMusics = [];

  //check the connection
  Future<void> checkConnection() async{
    try{
      final connectivityResult = await Connectivity().checkConnectivity();
      getConnection = (connectivityResult[0] == ConnectivityResult.mobile || connectivityResult[0] == ConnectivityResult.wifi);
    }catch(e){
      print(e);
      getConnection=false;
    }finally{
      notifyListeners();
    }
  }

  //supabase get cloud musics
  Future<void> fetchMusics() async {
    isLoading = true;
    notifyListeners();
    try {
      if (!getConnection) {
        musics = [];
        return;
      }
      final response = await Supabase.instance.client.from('songs').select();
      musics = List<Musicmodel>.from(
          response.map((music) => Musicmodel.fromJSON(music)));
    } catch (e) {
      print(e);
      musics = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //sqlite add to favorites
  Future<void> addFavorite(Musicmodel myMusic) async {
    try {
      List<Map<String, dynamic>> isExist =
          await dbHelper.getMusicById(myMusic.id);

      if (isExist.isEmpty) {
        Map<String, dynamic> music = {
          'id': myMusic.id,
          'title': myMusic.title,
          'artist': myMusic.artist,
          'file_url': myMusic.file_url,
          'image_url': myMusic.image_url
        };

        await dbHelper.insertMusic(music);
        isAdded = true;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  //sqlite check if the music is added
  Future<void> myMusicIsAdded(id) async {
    try {
      List<Map<String, dynamic>> isExist = await dbHelper.getMusicById(id);

      if (isExist.isNotEmpty) {
        isAdded = true;
      } else {
        isAdded = false;
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  //sqlite load my musics
  Future<void> getMyMusics() async {
    isLoading = true;
    notifyListeners();
    try {
      if (!getConnection) {
        return;
      }
      List<Map<String, dynamic>> data = await dbHelper.getMusic();
      myMusics =
          data.map((recipeData) => Musicmodel.fromJSON(recipeData)).toList();
      if(!myMusics.isEmpty) await Future.delayed(Duration(microseconds: 1500));
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //sqlite delete my music
  Future<void> deleteMyMusic(int id) async {
    try {
      await dbHelper.deleteMusic(id);
      isAdded = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
