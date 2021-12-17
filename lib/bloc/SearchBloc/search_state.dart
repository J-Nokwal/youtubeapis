part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

@immutable
class SearchState {
  final SearchStatus searchStatus;
  final List<SearchResult> items;

  final bool hasReachedMax;

// this.items= List<Item>;
  const SearchState({
    this.items = const <SearchResult>[],
    this.hasReachedMax = false,
    this.searchStatus = SearchStatus.initial,
  });
  SearchState loading() {
    return SearchState(searchStatus: SearchStatus.loading);
  }

  SearchState loadSuccessFull(
      {required List<SearchResult> items,
      SearchStatus searchStatus = SearchStatus.success,
      bool hasReachedMax = false}) {
    return SearchState(items: items, searchStatus: searchStatus, hasReachedMax: hasReachedMax);
  }
}
