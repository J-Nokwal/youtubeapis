part of 'search_bloc.dart';

enum ListStatus { initial, loading, success, failure }

@immutable
class SearchState {
  final ListStatus status;
  final List<Item> items;

  final bool hasReachedMax;

// this.items= List<Item>;
  const SearchState({
    this.items = const <Item>[],
    this.hasReachedMax = false,
    this.status = ListStatus.initial,
  });
  SearchState loading() {
    return SearchState(status: ListStatus.loading);
  }

  SearchState loadSuccessFull(
      {required List<Item> items,
      ListStatus status = ListStatus.success,
      bool hasReachedMax = false}) {
    return SearchState(
        items: items, status: status, hasReachedMax: hasReachedMax);
  }
}

// class SearchInitial extends SearchState {}

// class SearchVideosLoadingState extends SearchState {}

// class SearchVideosSuccessfullState extends SearchState {
  
  

//   SearchVideosSuccessfullState();
// }

// class SearchVideosErrorState extends SearchState {}

// class SearchMoreVideosLoadingState extends SearchState {}

// class SearchMoreVideosSuccessfullState extends SearchState {
//   final List<Item>? items;

//   SearchMoreVideosSuccessfullState({@required this.items});
// }
