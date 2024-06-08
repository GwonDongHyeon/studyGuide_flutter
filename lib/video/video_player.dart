// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyguide_flutter/profile/creator_profile.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatelessWidget {
  const VideoPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoPage(
        videoUrl: '',
        title: '',
        thumbnailUrl: '',
        viewCount: '',
        channelTitle: '',
        channelThumbnailUrl: '',
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String thumbnailUrl;
  final String viewCount;
  final String channelTitle;
  final String channelThumbnailUrl;

  const VideoPage({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.thumbnailUrl,
    required this.viewCount,
    required this.channelTitle,
    required this.channelThumbnailUrl,
  });

  @override
  _VideoPage createState() => _VideoPage();
}

class _VideoPage extends State<VideoPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      if (videoId == null) {
        return;
      }
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: const Text('Video Player'),
          backgroundColor: const Color.fromARGB(255, 80, 180, 220),
        ),
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '조회수 ${widget.viewCount}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreatorProfilePage(nameText: ''),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.channelThumbnailUrl),
                          radius: 20,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(widget.channelTitle),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          _saveURLToFirestore(widget.videoUrl);
                        },
                        icon: const Icon(Icons.favorite),
                      ),
                      IconButton(
                        onPressed: () {
                          _copyToClipboard(widget.videoUrl);
                        },
                        icon: const Icon(Icons.share),
                      ),
                      IconButton(
                        onPressed: () {
                          _copyToClipboard(widget.videoUrl);
                        },
                        icon: const Icon(Icons.copy),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('URL이 클립보드에 복사되었습니다.')),
    );
  }

  Future<void> _saveURLToFirestore(String url) async {
    try {
      await FirebaseFirestore.instance.collection('urls').add({
        'url': url,
      });
      print('URL이 Firestore에 저장되었습니다.');
    } catch (error) {
      print('Firestore에 URL 저장 중 오류가 발생했습니다: $error');
    }
  }
}
