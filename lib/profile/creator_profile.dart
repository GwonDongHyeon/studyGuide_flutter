// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studyguide_flutter/api/api.dart';
import 'package:studyguide_flutter/profile/creator_info_list.dart';
import 'package:studyguide_flutter/profile/my_video_detail.dart';
import 'package:studyguide_flutter/video/video_player.dart';
import 'package:studyguide_flutter/video/video_url_list.dart';
import 'package:url_launcher/link.dart';

class CreatorProfile extends StatelessWidget {
  const CreatorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CreatorProfilePage(
        email: '',
        channelThumbnailUrl: '',
        urlCreator: '',
      ),
    );
  }
}

class CreatorProfilePage extends StatefulWidget {
  const CreatorProfilePage(
      {Key? key,
      required this.email,
      required this.channelThumbnailUrl,
      required this.urlCreator})
      : super(key: key);

  final String email;
  final String channelThumbnailUrl;
  final String urlCreator;

  @override
  _CreatorProfilePage createState() => _CreatorProfilePage();
}

class _CreatorProfilePage extends State<CreatorProfilePage> {
  bool _isSaved = false;
  List<String> savedCreators = [];
  List<List<String>> creatorInfo = [];
  List<String> creatorVideos = [];

  @override
  void initState() {
    super.initState();
    creatorInfo = creatorInfos[widget.urlCreator] ?? [];
    _initData();
  }

  Future<void> _initData() async {
    await _filterVideos();
    await _fetchDataCreator();
  }

  Future<void> _filterVideos() async {
    List<String> urls = [];
    List<String> creators = [];

    subjectVideoUrls.forEach(
      (subject, videos) {
        for (var video in videos) {
          urls.add(video[0]);
          creators.add(video[1]);
        }
      },
    );

    for (var index = 0; index < urls.length; index++) {
      try {
        if (creators[index] == widget.urlCreator) {
          creatorVideos.add(urls[index]);
        }
      } catch (e) {
        //next url
      }
    }
  }

  Future<void> _fetchDataCreator() async {
    try {
      final response = await http.post(
        Uri.parse(API.creatorOutput),
        body: {
          'email': widget.email,
        },
      );

      if (response.statusCode == 200) {
        savedCreators = List<String>.from(json.decode(response.body));
        _checkIfCreatorSaved();
      }
    } catch (e) {
      print(e);
    }
  }

  void _checkIfCreatorSaved() {
    setState(() {
      _isSaved = savedCreators.contains(widget.urlCreator);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('강사 프로필'),
        backgroundColor: const Color.fromARGB(255, 80, 180, 220),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[300],
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.channelThumbnailUrl),
                    radius: 80,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                    onPressed: () {
                      if (_isSaved) {
                        deleteCreatorNameForUser(
                            widget.email, widget.urlCreator);
                      } else {
                        saveCreatorNameForUser(widget.email, widget.urlCreator);
                      }
                      setState(() {
                        _isSaved = !_isSaved;
                      });
                    },
                    icon: _isSaved
                        ? const Icon(
                            Icons.favorite,
                            size: 50,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            size: 50,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.urlCreator,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            for (var info in creatorInfo)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: info[0],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            for (int i = 1; i < info.length; i++)
                              TextSpan(
                                text: '\n${info[i]}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: creatorVideos.isEmpty ? 1 : creatorVideos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 160,
                      child: Card(
                        child: Center(
                          child: creatorVideos.isEmpty
                              ? const Text('비어있습니다')
                              : buildLinkMyItem(
                                  creatorVideos[index],
                                  widget.urlCreator,
                                  widget.email,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildLinkMyItem(String videoUrl, String urlCreator, String email) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Link(
        uri: Uri.parse(videoUrl),
        builder: (BuildContext ctx, FollowLink? openLink) {
          return FutureBuilder<VideoDetail>(
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
                          urlCreator: urlCreator,
                          videoUrl: videoUrl,
                          title: video.title,
                          thumbnailUrl: video.thumbnailUrl,
                          viewCount: video.viewCount,
                          channelTitle: video.channelTitle,
                          channelThumbnailUrl: video.channelThumbnailUrl,
                        ),
                      ),
                    ).then(
                      (_) => {_fetchDataCreator()},
                    );
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

  Future<void> saveCreatorNameForUser(String email, String urlCreator) async {
    try {
      var response = await http.post(
        Uri.parse(API.creatorInput),
        body: {
          'email': email,
          'video_creator': urlCreator,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('좋아요 강사에 저장되었습니다.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCreatorNameForUser(String email, String urlCreator) async {
    try {
      var response = await http.post(
        Uri.parse(API.creatorDelete),
        body: {
          'email': email,
          'video_creator': urlCreator,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('좋아요 강사에서 삭제되었습니다.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
