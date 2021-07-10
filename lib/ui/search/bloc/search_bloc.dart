import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:youtubeapi/data/model/search/search.dart';
import 'package:youtubeapi/data/network/youTubeDataSource.dart';
import 'package:youtubeapi/data/repository/youTubeRepository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchState? currentState;
  YouTubeRepository _youTubeRepository = YouTubeRepository();
  SearchBloc() : super(SearchState());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    try {
      if (event is SearchVideosPressButton) {
        yield state.loading();
        List<Item> items = await _youTubeRepository.searchVideos(event.query);
        if (items.length < MAX_SEARCH_RESULTS) {
          yield state.loadSuccessFull(items: items, hasReachedMax: true);
        } else {
          yield state.loadSuccessFull(items: items);
        }
      } else if (event is SearchMoreVideosEvent) {
        List<Item> items = await _youTubeRepository.fetchNextResultPage();
        // state.searchMore(items: items);

        state.items..addAll(items);
        if (items.length < MAX_SEARCH_RESULTS) {
          yield state.loadSuccessFull(items: state.items, hasReachedMax: true);
        } else {
          yield state.loadSuccessFull(items: state.items);
        }
      }
    } on Exception catch (e) {
      print(e.toString());
      throw SearchBlocError();
    }
  }
}

class SearchBlocError implements Exception {}
