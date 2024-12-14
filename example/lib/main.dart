import 'package:tiktok_scraper/tiktok_scraper.dart';

void main() async {
  // var username = 'mubashardev';
  // Author author = await TiktokScraper.getUserInfo(username);

  var videoUrl =
      'https://www.tiktok.com/@mubashardev/video/7393468652906925317';
  TiktokVideo video = await TiktokScraper.getVideoInfo(videoUrl);

  print(video.toMap());
}
