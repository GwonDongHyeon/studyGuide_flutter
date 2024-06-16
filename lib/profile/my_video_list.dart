import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:studyguide_flutter/api/api.dart';
import 'package:studyguide_flutter/video/video_list_build.dart';
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
  List<String> creatorNames = [];

  @override
  void initState() {
    super.initState();
    _fetchDataUrl();
  }

  Future<void> _fetchDataUrl() async {
    try {
      final response = await http.post(
        Uri.parse(API.urlOutput),
        body: {
          'email': widget.email,
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          savedVideos = [];
          creatorNames = [];
          for (var item in responseData) {
            savedVideos.add(item['video_url']);
            creatorNames.add(item['video_creator']);
          }
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
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: savedVideos.length,
                    itemBuilder: (context, index) {
                      return buildLinkItem(
                        savedVideos[index],
                        creatorNames[index],
                        widget.email,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
