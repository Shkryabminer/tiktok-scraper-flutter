import 'dart:convert';

import 'package:tiktok_scraper/models/tiktok_video.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
export 'models/tiktok_video.dart';

class TiktokScraper {
  static Future<Map<String, dynamic>> _data(
      String url, List<String> nestedPath) async {
    // Fetch the response from the provided URL
    var response = await Dio().get(url);

    // Parse the HTML document
    var document = html_parser.parse(response.data);
    var element = document.getElementById('__UNIVERSAL_DATA_FOR_REHYDRATION__');
    String? jsonString = element?.text;

    if (jsonString == null) {
      throw Exception('No records found!!');
    }

    // Parse the JSON data
    var data = jsonDecode(jsonString);

    // Traverse the JSON object using the nested path
    dynamic result = data;
    for (var key in nestedPath) {
      if (result is Map<String, dynamic> && result.containsKey(key)) {
        result = result[key];
      } else {
        throw Exception('Invalid nested path or data not found for key: $key');
      }
    }

    // Return the final result as a Map
    if (result is Map<String, dynamic>) {
      return result;
    } else {
      throw Exception(
          'Expected a Map at the final path but found ${result.runtimeType}');
    }
  }

  /// Fetch user information by username.
  ///
  /// Throws an [Exception] if the username is invalid or the user data is not found.
  ///
  /// Returns a [Author] object containing the user information.
  static Future<Author> getUserInfo(String username) async {
    var url =
        "https://tiktok.com/${username.startsWith('@') ? username : "@$username"}";

    var mainData = await _data(
        url, ['__DEFAULT_SCOPE__', 'webapp.user-detail', 'userInfo']);
    var user = mainData['user'];
    var stats = mainData['stats'];

    if (user == null || stats == null) {
      throw Exception(
          "Something went wrong with this user data or username \"$username\" doesn't exist");
    }

    return Author(
        id: user['id'].toString(),
        username: username,
        name: user['nickname'].toString(),
        avatar: user['avatarLarger'].toString(),
        followerCount: stats['followerCount'],
        followingCount: stats['followingCount'],
        heartCount: stats['heartCount'],
        videoCount: stats['videoCount'],
        diggCount: stats['diggCount']);
  }

  /// Fetch video information by video URL.
  ///
  /// Throws an [Exception] if the video URL is invalid or the video data is not found.
  ///
  /// Returns a [TiktokVideo] object containing the video information.
  static Future<TiktokVideo> getVideoInfo(String url) async {
    var mainData = await _data(url,
        ['__DEFAULT_SCOPE__', 'webapp.video-detail', 'itemInfo', 'itemStruct']);
    var videoData = mainData['video'];
    var authorData = mainData['author'];
    var authorStats = mainData['authorStats'];

    return TiktokVideo(
      id: mainData['id'].toString(),
      description: mainData['des'].toString(),
      createTime: mainData['createTime'].toString(),
      height: videoData['height'],
      width: videoData['width'],
      duration: videoData['duration'],
      defaultResolution: videoData['ratio'],
      thumbnail: videoData['cover'].toString(),
      downloadUrl: (videoData['downloadAddr'] != null &&
              videoData['downloadAddr'].toString().isNotEmpty)
          ? videoData['downloadAddr']
          : videoData['playAddr'].toString(),
      audioUrl: (mainData['music']?['playUrl']).toString(),
      author: Author(
          id: authorData['id'].toString(),
          username: authorData['uniqueId'].toString(),
          name: authorData['nickname'].toString(),
          avatar: authorData['avatarLarger'].toString(),
          followerCount: authorStats['followerCount'],
          followingCount: authorStats['followingCount'],
          heartCount: authorStats['heartCount'],
          videoCount: authorStats['videoCount'],
          diggCount: authorStats['diggCount']),
    );
  }
}
