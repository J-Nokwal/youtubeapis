import 'dart:convert';

import 'package:http/http.dart';
import 'package:youtubeapi/data/model/details/details.dart';
import 'package:youtubeapi/data/model/search/search.dart';
import 'package:youtubeapi/data/model/search/youTubeSearchError.dart';
import 'package:youtubeapi/data/network/api_key.dart';

const int MAX_SEARCH_RESULTS = 5;

class YouTubeDataSource {
  final String _searchBaseUrl =
      'https://www.googleapis.com/youtube/v3/search?part=snippet' +
          '&maxResults=$MAX_SEARCH_RESULTS&type=video&key=$API_KEY';
  final String _videoBaseUrl =
      'https://www.googleapis.com/youtube/v3/videos?part=snippet&key=$API_KEY';
  Future<SearchData> searchVideos({
    String? query,
    String? pageToken = '',
  }) async {
    final urlRaw = _searchBaseUrl +
        '&q=$query' +
        (pageToken != '' ? '&pageToken=$pageToken' : '');
    print(urlRaw);
    final urlEncoded = Uri.encodeFull(urlRaw);
    final uri = Uri.parse(urlEncoded);
    Response response = await get(uri);
    if (response.statusCode == 200) {
      // for (int i = 0; i < 5; i++) {
      //   print(searchDataFromJson(response.body).items[i].snippet.title);
      // }
      print(response.body);
      return searchDataFromJson(response.body);
    } else if (response.statusCode == 403) {
      print("response code 403 occurred");
      throw YoutubeSearchError("response code 403 occurred");
    } else {
      print(json.decode(response.body)['error']['message']);
      throw YoutubeSearchError(json.decode(response.body));
    }
  }

  Future<VideosDetails> detailsOfVideos({
    required String? videoId,
  }) async {
    final urlRaw = _videoBaseUrl + (videoId!.isNotEmpty ? '&id=$videoId' : '');
    final urlEncoded = Uri.encodeFull(urlRaw);
    final uri = Uri.parse(urlEncoded);
    Response response = await get(uri);
    if (response.statusCode == 200) {
      return videosDetailsFromJson(response.body);
    } else {
      throw YoutubeSearchError(json.decode(response.body));
    }
  }
}
