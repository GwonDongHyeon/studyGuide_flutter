import 'package:flutter/material.dart';
import 'package:studyguide_flutter/url/video_url.dart';

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
        myVideoUrls: [],
        email: '',
      ),
    );
  }
}

class MyProfileVideoListPage extends StatefulWidget {
  const MyProfileVideoListPage({
    super.key,
    required this.myVideoUrls,
    required this.email,
  });

  final List<String> myVideoUrls;
  final String email;

  @override
  // ignore: library_private_types_in_public_api
  _MyProfileVideoListPage createState() => _MyProfileVideoListPage();
}

class _MyProfileVideoListPage extends State<MyProfileVideoListPage> {
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
    if (videoUrls.length + _currentMax >= widget.myVideoUrls.length) {
      _hasMoreVideos = false;
    }
    setState(() {
      videoUrls
          .addAll(widget.myVideoUrls.skip(videoUrls.length).take(_currentMax));
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
          Expanded(
            child: GridView.count(
              controller: _scrollController,
              crossAxisCount: 2,
              children: videoUrls
                  .map((url) => buildLinkItem(url, widget.email))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
