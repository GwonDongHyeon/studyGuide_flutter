import 'package:flutter/material.dart';
import 'package:studyguide_flutter/video/video_list.dart';
import 'package:studyguide_flutter/video/video_search.dart';

class VideoSubject extends StatelessWidget {
  const VideoSubject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subjects',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoSubjectPage(),
    );
  }
}

class VideoSubjectPage extends StatelessWidget {
  const VideoSubjectPage({Key? key}) : super(key: key);

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
                  hintText: '검색',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
                onSubmitted: (String query) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoSearchPage(searchQuery: query),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8.0),
              children: [
                _buildSubjectButton(context, '국어'),
                _buildSubjectButton(context, '수학'),
                _buildSubjectButton(context, '영어'),
                _buildSubjectButton(context, '사회탐구'),
                _buildSubjectButton(context, '과학탐구'),
                _buildSubjectButton(context, '한국사'),
                _buildSubjectButton(context, '공부법'),
                _buildSubjectButton(context, '동기부여'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectButton(BuildContext context, String subject) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoListPage(subject: subject),
            ),
          );
        },
        child: Text(subject, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}