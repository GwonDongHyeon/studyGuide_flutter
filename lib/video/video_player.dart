// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyguide_flutter/api/api.dart';
import 'package:studyguide_flutter/profile/creator_profile.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class VideoPlayer extends StatelessWidget {
  const VideoPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoPage(
        email: '',
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
  const VideoPage({
    super.key,
    required this.email,
    required this.videoUrl,
    required this.title,
    required this.thumbnailUrl,
    required this.viewCount,
    required this.channelTitle,
    required this.channelThumbnailUrl,
  });

  final String email;
  final String videoUrl;
  final String title;
  final String thumbnailUrl;
  final String viewCount;
  final String channelTitle;
  final String channelThumbnailUrl;

  @override
  _VideoPage createState() => _VideoPage();
}

class _VideoPage extends State<VideoPage> {
  late YoutubePlayerController _controller;
  bool _isSaved = false;
  List<String> savedVideos = [];

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _fetchData();
  }

  void _checkIfSaved() {
    setState(() {
      _isSaved = savedVideos.contains(widget.videoUrl);
    });
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

  Future<void> _fetchData() async {
    try {
      final response = await http.post(
        Uri.parse(API.output),
        body: {
          'email': widget.email,
        },
      );
      if (response.statusCode == 200) {
        savedVideos = List<String>.from(json.decode(response.body));
        _checkIfSaved();
      }
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
                    ' 조회수 ${widget.viewCount}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const SizedBox(width: 3),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatorProfilePage(
                                channelThumbnailUrl: widget.channelThumbnailUrl,
                                channelTitle: widget.channelTitle,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(widget.channelThumbnailUrl),
                              radius: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(widget.channelTitle),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (_isSaved) {
                            deleteURLForUser(widget.email, widget.videoUrl);
                          } else {
                            saveURLForUser(widget.email, widget.videoUrl);
                          }
                          setState(() {
                            _isSaved = !_isSaved;
                          });
                        },
                        icon: _isSaved
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
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
      const SnackBar(
        content: Text('URL이 클립보드에 복사되었습니다.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> saveURLForUser(String email, String url) async {
    try {
      var response = await http.post(
        Uri.parse(API.input),
        body: {
          'email': email,
          'video_url': url,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('나중에 볼 동영상에 저장되었습니다.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteURLForUser(String email, String url) async {
    try {
      var response = await http.post(
        Uri.parse(API.delete),
        body: {
          'email': email,
          'video_url': url,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('나중에 볼 동영상에서 삭제되었습니다.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
