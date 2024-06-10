import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyguide_flutter/user/login.dart';
import 'package:studyguide_flutter/video/video_subject.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(80.0),
          child: Image.asset(
            'assets/images/studyGuide_loading.png',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _logout();
    _auth();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _auth() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (FirebaseAuth.instance.currentUser == null) {
        Get.off(() => const LoginPage());
      } else {
        Get.off(
          () => const VideoSubjectPage(
            email: '',
          ),
        );
      }
    });
  }

  _logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
