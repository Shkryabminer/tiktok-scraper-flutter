import 'dart:convert';

import 'package:tiktok_scraper/tiktok_scraper.dart';
import 'dart:developer';

void main() async {
  var username = 'mubashardev';
  Author author = await TiktokScraper.getUserInfo(username);

  log(jsonEncode(author.toMap()));

  var videoUrl =
      'https://www.tiktok.com/@mubashardev/video/7393468652906925317';
  TiktokVideo video = await TiktokScraper.getVideoInfo(videoUrl);

  log(jsonEncode(video.toMap()));
}
