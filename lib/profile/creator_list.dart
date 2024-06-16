import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:studyguide_flutter/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:studyguide_flutter/profile/creator_profile.dart';

class MyProfileCreatorList extends StatelessWidget {
  const MyProfileCreatorList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyProfile Video Links List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyProfileCreatorListPage(
        email: '',
      ),
    );
  }
}

class MyProfileCreatorListPage extends StatefulWidget {
  const MyProfileCreatorListPage({
    super.key,
    required this.email,
  });

  final String email;

  @override
  // ignore: library_private_types_in_public_api
  _MyProfileCreatorListPage createState() => _MyProfileCreatorListPage();
}

class _MyProfileCreatorListPage extends State<MyProfileCreatorListPage> {
  List<String> savedCreators = [];

  @override
  void initState() {
    super.initState();
    _fetchDataCreator();
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
        setState(() {
          savedCreators = List<String>.from(json.decode(response.body));
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
        title: const Text('좋아요 강사'),
        backgroundColor: const Color.fromARGB(255, 80, 180, 220),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 5,
        ),
        itemCount: savedCreators.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatorProfilePage(
                        email: widget.email,
                        channelThumbnailUrl: '',
                        urlCreator: savedCreators[index]),
                  ),
                ).then((value) => _fetchDataCreator());
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                  shadowColor: Colors.grey,
                  elevation: 4),
              child: Text(savedCreators[index]),
            ),
          );
        },
      ),
    );
  }
}
