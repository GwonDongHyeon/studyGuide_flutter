import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:studyguide_flutter/url/video_parse.dart';
import 'package:studyguide_flutter/profile/creator_profile.dart';
import 'package:studyguide_flutter/video/video_player.dart';

class YouTubeVideo {
  final String title;
  final String thumbnailUrl;
  final String viewCount;
  final String channelTitle;
  final String channelThumbnailUrl;

  YouTubeVideo({
    required this.title,
    required this.thumbnailUrl,
    required this.viewCount,
    required this.channelTitle,
    required this.channelThumbnailUrl,
  });
}

Widget buildLinkItem(String videoUrl, String id) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Link(
      uri: Uri.parse(videoUrl),
      builder: (BuildContext ctx, FollowLink? openLink) {
        return FutureBuilder<YouTubeVideo>(
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
                        email: id,
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
                onLongPress: () {
                  showDialog(
                    context: ctx,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('저장'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('나중에 볼 동영상'),
                              onTap: () {
                                //saveVideoForLaterWatching(video, context);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
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
                          const SizedBox(height: 4),
                          Text(
                            'View: ${video.viewCount}',
                            style: const TextStyle(fontSize: 8),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreatorProfilePage(
                                              nameText: ''),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(video.channelThumbnailUrl),
                                  radius: 8,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CreatorProfilePage(
                                                nameText: ''),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    video.channelTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
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
