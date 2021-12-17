part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchVideosPressButton extends SearchEvent {
  final String? query;
  final int maxResults;
  SearchVideosPressButton({@required this.query, this.maxResults = 30});
}

class SearchMoreVideosEvent extends SearchEvent {}
