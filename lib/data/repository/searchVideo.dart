//
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class YouTubeRepository {
  String? _nextPageToken;
  late int pageCount;
  late int _currentPage;
  late String? query;
  late int maxResults;

  late YouTubeApi youTubeApi;
  YouTubeRepository({required AuthClient client}) {
    this.youTubeApi = YouTubeApi(client);
  }

  Future<List<SearchResult>> searchVideos(String? query, {int maxResults = 30}) async {
    SearchListResponse searchListResponse =
        await youTubeApi.search.list(["snippet"], q: query ?? "flutter", maxResults: maxResults, type: ["video"]);
    pageCount = (searchListResponse.pageInfo!.totalResults! / searchListResponse.pageInfo!.resultsPerPage!).ceil();

    this._currentPage = 1;
    this.query = query;
    this.maxResults = maxResults;
    this._nextPageToken = searchListResponse.nextPageToken;

    return searchListResponse.items!;
  }

  Future<List<SearchResult>> fetchNextResultPage() async {
    try {
      if (this._nextPageToken == null) {
        throw MaxSearchResultReachException();
      }
      SearchListResponse searchListResponse = await youTubeApi.search.list(["snippet"],
          q: this.query ?? "flutter", maxResults: this.maxResults, type: ["video"], pageToken: _nextPageToken);
      this._currentPage += 1;
      this._nextPageToken = searchListResponse.nextPageToken;
      return searchListResponse.items!;
    } on MaxSearchResultReachException {
      throw MaxSearchResultReachException();
    } on Exception catch (e) {
      throw e;
    }
  }
}

class NoSearchResultsException implements Exception {
  final message = 'No such video';
}

class SearchNotInitiatedException implements Exception {
  final message = 'Cannot get the next result page without searching first.';
}

class NoNextPageTokenException implements Exception {}

class NoSuchVideoException implements Exception {
  final message = 'No such video';
}

class MaxSearchResultReachException implements Exception {
  final message = 'Max Search Result Reach';
}
