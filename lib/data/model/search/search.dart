// To parse this JSON data, do
//
//     final searchData = searchDataFromJson(jsonString);

import 'dart:convert';

SearchData searchDataFromJson(String str) =>
    SearchData.fromJson(json.decode(str));

String searchDataToJson(SearchData data) => json.encode(data.toJson());

class SearchData {
  SearchData({
    required this.kind,
    required this.etag,
    required this.nextPageToken,
    required this.regionCode,
    required this.pageInfo,
    required this.items,
  });

  String kind;
  String etag;
  String nextPageToken;
  String regionCode;
  PageInfo pageInfo;
  List<Item> items;

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        kind: json['kind'],
        etag: json['etag'],
        nextPageToken: json['nextPageToken'],
        regionCode: json['regionCode'],
        pageInfo: PageInfo.fromJson(json["pageInfo"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "nextPageToken": nextPageToken,
        "regionCode": regionCode,
        "pageInfo": pageInfo.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet,
  });

  String kind;
  String etag;
  Id id;
  Snippet snippet;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        kind: json["kind"],
        etag: json["etag"],
        id: Id.fromJson(json["id"]),
        snippet: Snippet.fromJson(json["snippet"]),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "id": id.toJson(),
        "snippet": snippet.toJson(),
      };
}

class Id {
  Id({
    required this.kind,
    required this.videoId,
  });

  String kind;
  String videoId;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        kind: json["kind"],
        videoId: json["videoId"],
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "videoId": videoId,
      };
}

class Snippet {
  Snippet({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.liveBroadcastContent,
    required this.publishTime,
  });

  DateTime publishedAt;
  String channelId;
  String title;
  String description;
  Thumbnails thumbnails;
  String channelTitle;
  String liveBroadcastContent;
  DateTime publishTime;

  factory Snippet.fromJson(Map<String, dynamic> json) => Snippet(
        publishedAt: DateTime.parse(json["publishedAt"]),
        channelId: json["channelId"],
        title: json["title"],
        description: json["description"],
        thumbnails: Thumbnails.fromJson(json["thumbnails"]),
        channelTitle: json["channelTitle"],
        liveBroadcastContent: json["liveBroadcastContent"],
        publishTime: DateTime.parse(json["publishTime"]),
      );

  Map<String, dynamic> toJson() => {
        "publishedAt": publishedAt.toIso8601String(),
        "channelId": channelId,
        "title": title,
        "description": description,
        "thumbnails": thumbnails.toJson(),
        "channelTitle": channelTitle,
        "liveBroadcastContent": liveBroadcastContent,
        "publishTime": publishTime.toIso8601String(),
      };
}

class Thumbnails {
  Thumbnails({
    required this.thumbnailsDefault,
    required this.medium,
    required this.high,
  });

  Default thumbnailsDefault;
  Default medium;
  Default high;

  factory Thumbnails.fromJson(Map<String, dynamic> json) => Thumbnails(
        thumbnailsDefault: Default.fromJson(json["default"]),
        medium: Default.fromJson(json["medium"]),
        high: Default.fromJson(json["high"]),
      );

  Map<String, dynamic> toJson() => {
        "default": thumbnailsDefault.toJson(),
        "medium": medium.toJson(),
        "high": high.toJson(),
      };
}

class Default {
  Default({
    required this.url,
    required this.width,
    required this.height,
  });

  String url;
  int width;
  int height;

  factory Default.fromJson(Map<String, dynamic> json) => Default(
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
      };
}

class PageInfo {
  PageInfo({
    required this.totalResults,
    required this.resultsPerPage,
  });

  int totalResults;
  int resultsPerPage;

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        totalResults: json["totalResults"],
        resultsPerPage: json["resultsPerPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalResults": totalResults,
        "resultsPerPage": resultsPerPage,
      };
}
// ignore_for_file: prefer_single_quotes