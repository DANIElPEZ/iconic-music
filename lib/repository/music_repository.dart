import 'package:supabase_flutter/supabase_flutter.dart';

class MusicRepository{
  Future<List> getAllMusics()async{
    try{
      return await Supabase.instance.client.from('songs').select();
    }catch (e){
      return [];
    }
  }
}