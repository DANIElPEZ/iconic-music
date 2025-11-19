abstract class SearchEvent{}

class setQuery extends SearchEvent{
  final String query;
  setQuery(this.query);
}

class loadSearch extends SearchEvent{}