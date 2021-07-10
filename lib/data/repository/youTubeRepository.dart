import 'package:youtubeapi/data/model/details/details.dart';
import 'package:youtubeapi/data/model/search/search.dart';
import 'package:youtubeapi/data/network/youTubeDataSource.dart';

class YouTubeRepository {
  final YouTubeDataSource _youTubeDataSource = YouTubeDataSource();
  String? _lastSearchQuery;
  String? _nextPageToken;
  int? pageCount;
  int? _currentPage;

  void _cacheValues(
      {required String? query,
      required String? nextPageToken,
      int? currentPage}) {
    _lastSearchQuery = query;
    _nextPageToken = nextPageToken;
    _currentPage = currentPage;
  }

  Future<List<Item>> searchVideos(String? query) async {
    final searchResult =
        await this._youTubeDataSource.searchVideos(query: query);
    // print("$_nextPageToken, ${searchResult.nextPageToken}");
    this.pageCount =
        (searchResult.pageInfo.totalResults / MAX_SEARCH_RESULTS).ceil();
    _cacheValues(
        query: query,
        nextPageToken: searchResult.nextPageToken,
        currentPage: 1);
    if (searchResult.items.isEmpty) throw NoSearchResultsException();
    return searchResult.items;
  }

  Future<List<Item>> fetchNextResultPage() async {
    if (_lastSearchQuery == null) {
      throw SearchNotInitiatedException();
    }

    if (_nextPageToken == null) {
      throw NoNextPageTokenException();
    }
    if (pageCount! < this._currentPage!) {
      return <Item>[];
    }
    final nextPageSearchResult = await this
        ._youTubeDataSource
        .searchVideos(query: _lastSearchQuery, pageToken: _nextPageToken);
    // print("$_nextPageToken, ${nextPageSearchResult.nextPageToken}");
    _cacheValues(
        query: _lastSearchQuery,
        nextPageToken: nextPageSearchResult.nextPageToken,
        currentPage: this._currentPage! + 1);

    // for (int i = 0; i < 5; i++) {
    //   print(nextPageSearchResult.items[i].snippet.title);
    // }
    return nextPageSearchResult.items;
  }

  Future<List<ItemOfDetails>> fetchVideoInfo({required String? id}) async {
    final videoResponse =
        await this._youTubeDataSource.detailsOfVideos(videoId: id);
    if (videoResponse.items.isEmpty) throw NoSuchVideoException();
    return videoResponse.items;
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
