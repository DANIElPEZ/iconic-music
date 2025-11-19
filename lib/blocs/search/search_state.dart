class SearchState {
  SearchState({required this.query, this.data, required this.loading});

  final String query;
  List<dynamic>? data;
  final bool loading;

  factory SearchState.initial(){
    return SearchState(query: '', data: [], loading: false);
  }

  SearchState copyWith({String? query, List<dynamic>? data, bool? loading}){
    return SearchState(
      query: query ?? this.query,
      data: data ?? this.data,
      loading: loading ?? this.loading
    );
  }
}