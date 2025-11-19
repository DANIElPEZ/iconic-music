import 'package:bloc/bloc.dart';
import 'package:iconicmusic/repository/music_repository.dart';
import 'package:iconicmusic/blocs/music/music_state.dart';
import 'package:iconicmusic/blocs/music/music_event.dart';

class musicBloc extends Bloc<musicEvent, musicState> {
  final MusicRepository musicRepository;

  musicBloc({required this.musicRepository}) : super(musicState.initial()) {
    on<LoadMusics>((event, emit) async {
      emit(state.copyWith(loading: true));
      final result = await musicRepository.getAllMusics();
      emit(state.copyWith(musics: result, loading: false));
    });
    on<LoadFavoriteMusics>((event, emit) async {
      emit(state.copyWith(loading: true));
      final favoriteMusic = await musicRepository.getFavoritesMusics();
      emit(state.copyWith(favoriteMusics: favoriteMusic, loading: false));
    });
    on<LoadMusic>((event, emit) async {
      int count=state.showad+1;
      if(count>2) {
        count=0;
      }
      emit(state.copyWith(
          id: event.id,
          title: event.title,
          artist: event.artist,
          url_lrc: event.url_lrc,
          url_image: event.url_image,
          url_file: event.url_file,
          showad: count));
    });
    on<AddFavorite>((event, emit) async {
      final music = {
        'id': state.id,
        'title': state.title,
        'artist': state.artist,
        'url_file': state.url_file,
        'url_image': state.url_image,
        'url_lrc': state.url_lrc
      };
      await musicRepository.insertMusic(music);
      final favorites = await musicRepository.getFavoritesMusics();
      emit(state.copyWith(isLiked: true, favoriteMusics: favorites));
    });
    on<DeleteFavorite>((event, emit) async {
      musicRepository.deleteMusic(state.id);
      final favorites = await musicRepository.getFavoritesMusics();
      emit(state.copyWith(isLiked: false, favoriteMusics: favorites));
    });
    on<DownloadMusic>((event, emit) async {
      final musicFiles = {
        'url_file': state.url_file,
        'url_image': state.url_image,
        'url_lrc': state.url_lrc
      };
      musicRepository.insertDownloadMusic(state.id, musicFiles);
    });
    on<LikedMusic>((event, emit) async {
      final result = await musicRepository.getLikedMusic(state.id);
      emit(state.copyWith(isLiked: result));
    });
    on<IsDownloadedMusic>((event, emit) async {
      final result = await musicRepository.getDownloadMusic(state.id);
      if(result==null || result['url_image']==null || result['url_file']==null || result['url_lrc']==null){
        emit(state.copyWith(isDownloaded: false));
        return;
      }
      emit(state.copyWith(
        isDownloaded: true,
        url_image: result['url_image'],
        url_file: result['url_file'],
        url_lrc: result['url_lrc'],
      ));
    });
  }
}
