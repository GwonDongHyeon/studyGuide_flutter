import 'package:flutter/material.dart';
import 'package:studyguide_flutter/video/video_list.dart';
import 'package:studyguide_flutter/video/video_search.dart';
import 'package:studyguide_flutter/profile/my_profile.dart';

class VideoSubject extends StatelessWidget {
  const VideoSubject({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VideoSubjectPage(
        email: '',
        id: '',
      ),
    );
  }
}

class VideoSubjectPage extends StatefulWidget {
  const VideoSubjectPage({Key? key, required this.email, required this.id})
      : super(key: key);

  final String email;
  final String id;

  @override
  // ignore: library_private_types_in_public_api
  _VideoSubjectPage createState() => _VideoSubjectPage();
}

class _VideoSubjectPage extends State<VideoSubjectPage> {
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
                      builder: (context) => VideoSearchPage(
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(widget.id),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyProfilePage(
                            email: widget.email,
                            id: widget.id,
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
              ),
            ],
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
                _buildSubjectButton(context, '동기부여&공부자극'),
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
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 190, 190, 190).withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoListPage(
                      subject: subject,
                      email: widget.email,
                      id: widget.id,
                    ),
                  ),
                );
              },
              child: Image.asset(
                'assets/images/$subject.png',
                fit: BoxFit.cover,
                height: 140,
                width: 140,
              ),
            ),
          ),
          Text(subject),
        ],
      ),
    );
  }
}
