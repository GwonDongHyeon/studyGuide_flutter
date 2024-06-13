import 'package:flutter/material.dart';

class CreatorProfile extends StatelessWidget {
  const CreatorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CreatorProfilePage(
        channelThumbnailUrl: '',
        channelTitle: '',
      ),
    );
  }
}

class CreatorProfilePage extends StatelessWidget {
  const CreatorProfilePage({
    Key? key,
    required this.channelThumbnailUrl,
    required this.channelTitle,
  }) : super(key: key);

  final String channelThumbnailUrl;
  final String channelTitle;

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
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey[300],
              child: CircleAvatar(
                backgroundImage: NetworkImage(channelThumbnailUrl),
                radius: 80,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              channelTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
