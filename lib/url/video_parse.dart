import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:studyguide_flutter/url/video_url.dart';

Future<VideoDetail> fetchVideoDetails(String videoUrl) async {
  final videoId = videoUrl.split('v=')[1];
  const apiKey = 'AIzaSyCpJIzIv27HzCXJ-Gr7xDyia3N5s-jFaIw';
  final apiUrl =
      'https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&id=$videoId&key=$apiKey';
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final snippet = data['items'][0]['snippet'];
    final statistics = data['items'][0]['statistics'];
    final channelId = snippet['channelId'];

    final channelApiUrl =
        'https://www.googleapis.com/youtube/v3/channels?part=snippet&id=$channelId&key=$apiKey';
    final channelResponse = await http.get(Uri.parse(channelApiUrl));

    if (channelResponse.statusCode == 200) {
      final channelData = json.decode(channelResponse.body);
      final channelSnippet = channelData['items'][0]['snippet'];
      final channelTitle = channelSnippet['title'];
      final channelThumbnailUrl = channelSnippet['thumbnails']['high']['url'];

      final title = snippet['title'];
      final thumbnailUrl = snippet['thumbnails']['high']['url'];
      final viewCount = statistics['viewCount'];

      final formattedViewCount =
          NumberFormat('#,###').format(int.parse(viewCount));

      return VideoDetail(
        title: title,
        thumbnailUrl: thumbnailUrl,
        viewCount: formattedViewCount,
        channelTitle: channelTitle,
        channelThumbnailUrl: channelThumbnailUrl,
      );
    } else {
      throw Exception('Failed to load video details');
    }
  } else {
    throw Exception('Failed to load video details');
  }
}
