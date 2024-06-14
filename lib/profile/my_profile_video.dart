import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:studyguide_flutter/api/api.dart';
import 'package:studyguide_flutter/profile/creator_profile.dart';
import 'package:studyguide_flutter/url/video_parse.dart';
import 'package:studyguide_flutter/url/video_url.dart';
import 'package:studyguide_flutter/video/video_player.dart';
import 'package:url_launcher/link.dart';
import 'package:http/http.dart' as http;

class MyProfileVideoList extends StatelessWidget {
  const MyProfileVideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyProfile Video Links List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyProfileVideoListPage(
        email: '',
      ),
    );
  }
}

class MyProfileVideoListPage extends StatefulWidget {
  const MyProfileVideoListPage({
    super.key,
    required this.email,
  });

  final String email;

  @override
  // ignore: library_private_types_in_public_api
  _MyProfileVideoListPage createState() => _MyProfileVideoListPage();
}

class _MyProfileVideoListPage extends State<MyProfileVideoListPage> {
  List<String> savedVideos = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.post(
        Uri.parse(API.output),
        body: {
          'email': widget.email,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          savedVideos = List<String>.from(json.decode(response.body));
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나중에 볼 동영상'),
        backgroundColor: const Color.fromARGB(255, 80, 180, 220),
      ),
      body: Column(
        children: [
          Expanded(
            child: savedVideos.isEmpty
                ? const Center(
                    child: Text('비어있습니다'),
                  )
                : GridView.count(
                    crossAxisCount: 2,
                    children: savedVideos
                        .map((url) => buildLinkItem(url, widget.email))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildLinkItem(String videoUrl, String email) {
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
                          videoUrl: videoUrl,
                          title: video.title,
                          thumbnailUrl: video.thumbnailUrl,
                          viewCount: video.viewCount,
                          channelTitle: video.channelTitle,
                          channelThumbnailUrl: video.channelThumbnailUrl,
                        ),
                      ),
                    ).then((_) => _fetchData());
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
                                        channelThumbnailUrl:
                                            video.channelThumbnailUrl,
                                        creatorName: videoUrl),
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
}
