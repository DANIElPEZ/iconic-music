import 'package:bloc/bloc.dart';
import 'package:iconicmusic/repository/music_repository.dart';
import 'package:iconicmusic/blocs/music/music_state.dart';
import 'package:iconicmusic/blocs/music/music_event.dart';

class musicBloc extends Bloc<musicEvent, musicState>{
  final MusicRepository musicRepository;
  musicBloc({required this.musicRepository}):super(musicState.initial()){
    on<fetchMusics>((event, emit)async{
      final result=await musicRepository.getAllMusics();
      emit(state.copyWith(musics: result));
    });
  }
}