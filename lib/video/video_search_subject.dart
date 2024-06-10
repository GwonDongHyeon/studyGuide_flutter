import 'package:flutter/material.dart';
import 'package:studyguide_flutter/profile/my_profile.dart';
import 'package:studyguide_flutter/url/video_url_list.dart';
import 'package:studyguide_flutter/url/video_parse.dart';
import 'package:studyguide_flutter/url/video_url.dart';

class VideoSearchSubject extends StatelessWidget {
  const VideoSearchSubject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'videoSearchInSubject',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoSearchSubjectPage(
        searchQuery: '',
        subject: '',
        email: '',
      ),
    );
  }
}

class VideoSearchSubjectPage extends StatefulWidget {
  const VideoSearchSubjectPage({
    Key? key,
    required this.searchQuery,
    required this.subject,
    required this.email,
  }) : super(key: key);
  final String searchQuery;
  final String subject;
  final String email;

  @override
  // ignore: library_private_types_in_public_api
  _VideoSearchSubjectPageState createState() => _VideoSearchSubjectPageState();
}

class _VideoSearchSubjectPageState extends State<VideoSearchSubjectPage> {
  List<String> filteredVideos = [];
  late ScrollController _scrollController;
  final int _currentMax = 8;
  int skipIndex = 0;
  bool _isLoading = false;
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

  void _loadMoreVideos() async {
    if (_isLoading || !_hasMoreVideos) return;
    setState(() {
      _isLoading = true;
    });

    List<String> newVideos = await _filterVideos(widget.searchQuery, skipIndex);
    if (mounted) {
      setState(() {
        if (newVideos.isEmpty) {
          _hasMoreVideos = false;
        } else {
          filteredVideos.addAll(newVideos);
        }
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchedQueary =
        TextEditingController(text: widget.searchQuery);
    return Scaffold(
      body: Column(children: [
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
              controller: searchedQueary,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
              ),
              onSubmitted: (String query) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoSearchSubjectPage(
                      searchQuery: query,
                      subject: widget.subject,
                      email: widget.email,
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
            Text(widget.email),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyProfilePage(
                              email: widget.email,
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
          child: Stack(
            children: [
              filteredVideos.isEmpty && !_isLoading
                  ? const Center(child: Text('No videos found'))
                  : GridView.count(
                      controller: _scrollController,
                      crossAxisCount: 2,
                      children: filteredVideos
                          .map((url) => buildLinkItem(url, widget.email))
                          .toList(),
                    ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        )
      ]),
    );
  }

  Future<List<String>> _filterVideos(String query, int startIndex) async {
    List<String> filteredUrls = [];

    final urls = subjectVideoUrls[widget.subject] ?? [];

    for (var url in urls.skip(startIndex)) {
      try {
        final videoDetails = await fetchVideoDetails(url);
        startIndex++;
        skipIndex = startIndex;
        if (videoDetails.title.contains(query) ||
            videoDetails.channelTitle.contains(query)) {
          filteredUrls.add(url);
          if (filteredUrls.length % _currentMax == 0) {
            return filteredUrls;
          }
        }
      } catch (e) {
        //next url
      }
    }
    return filteredUrls;
  }
}
