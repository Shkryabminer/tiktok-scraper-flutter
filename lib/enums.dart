enum ScrapeVideoSource {
  OfficialSite("https://www.tiktok.com"),
  TikDownloader("https://tikdownloader.io/api/ajaxSearch");

  final String url;
  const ScrapeVideoSource(this.url);
}
