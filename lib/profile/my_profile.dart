// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:studyguide_flutter/api/api.dart';
import 'package:studyguide_flutter/profile/my_profile_video.dart';
import 'package:studyguide_flutter/url/video_url.dart';
import 'package:studyguide_flutter/user/login.dart';
import 'package:studyguide_flutter/video/video_player.dart';
import 'package:url_launcher/link.dart';
import 'package:http/http.dart' as http;

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyProfilePage(
        email: '',
        id: '',
      ),
    );
  }
}

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({
    Key? key,
    required this.email,
    required this.id,
  }) : super(key: key);

  final String email;
  final String id;

  @override
  // ignore: library_private_types_in_public_api
  _MyProfilePage createState() => _MyProfilePage();
}

class _MyProfilePage extends State<MyProfilePage> {
  File? image;
  final picker = ImagePicker();
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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이 프로필'),
        backgroundColor: const Color.fromARGB(255, 80, 180, 220),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: getImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: image != null ? FileImage(image!) : null,
                    child: image == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  if (image == null)
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.add,
                        color: Color.fromARGB(255, 80, 180, 220),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.id,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      '나중에 볼 동영상',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyProfileVideoListPage(
                              myVideoUrls: savedVideos,
                              email: widget.email,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        '전체 보기 >>',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 95,
                  child: savedVideos.isEmpty
                      ? const Center(child: Text('비어있습니다'))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: savedVideos.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 160,
                              child: Card(
                                child: Center(
                                  child: buildLinkMyItem(
                                      savedVideos[index], widget.email),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '좋아요 강사',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            //
                          },
                          child: const Text(
                            '전체 보기 >>',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: savedVideos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 160,
                            child: Card(
                              child: Center(
                                child: Text(savedVideos[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 80, 180, 220),
                  ),
                  child: const Text('로그아웃'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: deleteAccount,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 80, 180, 220)),
                  child: const Text('회원 탈퇴'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {}
    });
  }

  void logout() {
    // 로그아웃 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('로그아웃 되었습니다.'),
        duration: Duration(seconds: 1),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void deleteAccount() async {
    // 회원 탈퇴 로직 구현
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Text('정말로 탈퇴하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('탈퇴'),
          ),
        ],
      ),
    );

    if (confirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('회원 탈퇴가 완료되었습니다.'),
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Widget buildLinkMyItem(String videoUrl, String email) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Link(
        uri: Uri.parse(videoUrl),
        builder: (BuildContext ctx, FollowLink? openLink) {
          return FutureBuilder<YouTubeVideo>(
            future: fetchMyVideoDetails(videoUrl),
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
                  child: Image.network(
                    video.thumbnailUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Future<YouTubeVideo> fetchMyVideoDetails(String videoUrl) async {
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

        return YouTubeVideo(
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
}

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
