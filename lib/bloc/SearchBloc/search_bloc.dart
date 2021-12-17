import 'package:bloc/bloc.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:meta/meta.dart';
import 'package:youtubeapis/data/repository/searchVideo.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late YouTubeRepository youTubeRepo;
  SearchBloc({required AuthClient client}) : super(SearchState()) {
    youTubeRepo = YouTubeRepository(client: client);
    // on<SearchEvent>((event, emit) {
    // });
    on<SearchVideosPressButton>((event, emit) async {
      // yield state.loading();
      List<SearchResult> items = await youTubeRepo.searchVideos(event.query, maxResults: event.maxResults);
      emit(state.loadSuccessFull(items: items));
    });

    on<SearchMoreVideosEvent>((event, emit) async {
      // yield state.loading();
      try {
        List<SearchResult> items = await youTubeRepo.fetchNextResultPage();
        items = state.items..addAll(items);
        emit(state.loadSuccessFull(items: items));
      } on MaxSearchResultReachException {
        emit(state.loadSuccessFull(items: state.items, hasReachedMax: true));
      }
    });
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }
  // @override
  // Stream<SearchState> mapEventToState(
  //   SearchEvent event,
  // ) async* {
  //   try {
  //     if (event is SearchVideosPressButton) {
  //       // yield state.loading();
  //       List<SearchResult> items = await youTubeRepo.searchVideos(event.query, maxResults: event.maxResults);
  //       yield state.loadSuccessFull(items: items);
  //     } else if (event is SearchMoreVideosEvent) {
  //       // yield state.loading();
  //       List<SearchResult> items = await youTubeRepo.fetchNextResultPage();
  //       items = state.items..addAll(items);
  //       yield state.loadSuccessFull(items: items);
  //     }
  //   } on MaxSearchResultReachException {
  //     yield state.loadSuccessFull(items: state.items, hasReachedMax: true);
  //   } on Exception catch (e) {
  //   }
  // }
}
