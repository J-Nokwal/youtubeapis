part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchVideosPressButton extends SearchEvent {
  final String? query;

  SearchVideosPressButton({@required this.query});
}

class SearchMoreVideosEvent extends SearchEvent {}
