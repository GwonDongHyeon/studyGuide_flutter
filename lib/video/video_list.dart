import 'package:flutter/material.dart';
import 'package:studyguide_flutter/url/video_url_list.dart';
import 'package:studyguide_flutter/video/video_search_subject.dart';
import 'package:studyguide_flutter/profile/my_profile.dart';
import 'package:studyguide_flutter/url/video_url.dart';

class VideoList extends StatelessWidget {
  const VideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Links',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoListPage(
        subject: '',
        email: '',
        id: '',
      ),
    );
  }
}

class VideoListPage extends StatefulWidget {
  const VideoListPage({
    super.key,
    required this.subject,
    required this.email,
    required this.id,
  });

  final String subject;
  final String email;
  final String id;

  @override
  // ignore: library_private_types_in_public_api
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  List<String> videoUrls = [];
  final int _currentMax = 8;
  late ScrollController _scrollController;
  bool _hasMoreVideos = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadMoreVideos();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreVideos() {
    if (!_hasMoreVideos) return;
    if (videoUrls.length + _currentMax >=
        subjectVideoUrls[widget.subject]!.length) _hasMoreVideos = false;
    final allVideos = subjectVideoUrls[widget.subject] ?? [];
    setState(() {
      videoUrls.addAll(allVideos.skip(videoUrls.length).take(_currentMax));
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 35, bottom: 20, left: 5, right: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: '과목 내에서 검색',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
                onSubmitted: (String query) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoSearchSubjectPage(
                        subject: widget.subject,
                        searchQuery: query,
                        email: widget.email,
                        id: widget.id,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 5),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer(),
              Text(widget.id),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: IconButton(
                        onPressed: () {
                          var email = widget.email;
                          var id = widget.id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProfilePage(
                                email: email,
                                id: id,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: GridView.count(
              controller: _scrollController,
              crossAxisCount: 2,
              children: videoUrls.map((url) => buildLinkItem(url)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
