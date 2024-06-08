// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studyguide_flutter/user/login.dart';

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
  const MyProfilePage({Key? key, required this.email, required this.id})
      : super(key: key);

  final String email;
  final String id;

  @override
  // ignore: library_private_types_in_public_api
  _MyProfilePage createState() => _MyProfilePage();
}

class _MyProfilePage extends State<MyProfilePage> {
  File? image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final List<String> watchRecord = [
      'Video 1',
      'Video 2',
      'Video 3',
      'Video 4',
      'Video 5',
      'Video 6',
      'Video 7',
      'Video 8',
      'Video 9',
      'Video 10',
    ];

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
            const Text(
              '나중에 볼 동영상',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: watchRecord.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 160,
                    child: Card(
                      child: Center(
                        child: Text(watchRecord[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '좋아요 강사',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: watchRecord.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 160,
                    child: Card(
                      child: Center(
                        child: Text(watchRecord[index]),
                      ),
                    ),
                  );
                },
              ),
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
      const SnackBar(content: Text('로그아웃 되었습니다.')),
    );
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
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
        const SnackBar(content: Text('회원 탈퇴가 완료되었습니다.')),
      );
      Navigator.pop(context);
    }
  }
}
