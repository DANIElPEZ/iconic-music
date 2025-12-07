class SearchState {
  SearchState(
      {required this.query,
      this.data,
      required this.loading,
      required this.searchExecuted});

  final String query;
  List<dynamic>? data;
  final bool loading;
  final bool searchExecuted;

  factory SearchState.initial() {
    return SearchState(
        query: '',
        data: [],
        loading: false,
        searchExecuted: false);
  }

  SearchState copyWith(
      {String? query,
      List<dynamic>? data,
      bool? loading,
      bool? searchExecuted}) {
    return SearchState(
        query: query ?? this.query,
        data: data ?? this.data,
        loading: loading ?? this.loading,
        searchExecuted: searchExecuted ?? this.searchExecuted);
  }
}
