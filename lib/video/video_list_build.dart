import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:studyguide_flutter/video/video_detail.dart';
import 'package:studyguide_flutter/profile/creator_profile.dart';
import 'package:studyguide_flutter/video/video_player.dart';

class VideoDetail {
  final String title;
  final String thumbnailUrl;
  final String viewCount;
  final String channelTitle;
  final String channelThumbnailUrl;

  VideoDetail({
    required this.title,
    required this.thumbnailUrl,
    required this.viewCount,
    required this.channelTitle,
    required this.channelThumbnailUrl,
  });
}

Widget buildLinkItem(String videoUrl, String urlCreators, String email) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Link(
      uri: Uri.parse(videoUrl),
      builder: (BuildContext ctx, FollowLink? openLink) {
        return FutureBuilder<VideoDetail>(
          future: fetchVideoDetails(videoUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final video = snapshot.data!;
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPage(
                        email: email,
                        urlCreator: urlCreators,
                        videoUrl: videoUrl,
                        title: video.title,
                        thumbnailUrl: video.thumbnailUrl,
                        viewCount: video.viewCount,
                        channelTitle: video.channelTitle,
                        channelThumbnailUrl: video.channelThumbnailUrl,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        video.thumbnailUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '조회수: ${video.viewCount}',
                            style: const TextStyle(fontSize: 8),
                          ),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreatorProfilePage(
                                      email: email,
                                      channelThumbnailUrl:
                                          video.channelThumbnailUrl,
                                      urlCreator: urlCreators),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(video.channelThumbnailUrl),
                                  radius: 8,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  video.channelTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    ),
  );
}
