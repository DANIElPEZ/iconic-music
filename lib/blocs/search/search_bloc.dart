import 'package:iconicmusic/blocs/search/search_event.dart';
import 'package:iconicmusic/blocs/search/search_state.dart';
import 'package:iconicmusic/repository/search_repository.dart';
import 'package:bloc/bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({required this.searchRepository}) : super(SearchState.initial()) {
    on<setQuery>((event, emit) {
      emit(state.copyWith(query: event.query));
    });
    on<loadSearch>((event, emit) async {
      try {
        emit(state.copyWith(loading: true));
        final data = await searchRepository.search(state.query);
        emit(state.copyWith(data: data,loading: false));
      }catch(e){
        print(e);
      }
    });
  }
}