// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:studyguide_flutter/user/login_google.dart';
import 'package:studyguide_flutter/user/signup.dart';
import 'package:studyguide_flutter/video/video_subject.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Study Guide',
            style: TextStyle(fontSize: 20),
          ),
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(60.0),
              child: Image.asset('assets/images/studyGuide_logo.png'),
            ),
            SizedBox(
              width: 250,
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'email'),
              ),
            ),
            SizedBox(
              width: 250,
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 80, 180, 220),
                fixedSize: const Size(200, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                '로그인',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              child: const Text(
                '회원가입',
                style: TextStyle(color: Color.fromARGB(255, 80, 180, 220)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                loginWithGoogle(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                fixedSize: const Size(200, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google_logo.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 2),
                  const Text(
                    '구글로 로그인',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print("User signed in: ${userCredential.user}");

      User? user = _auth.currentUser;
      String? displayName = user?.displayName;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoSubjectPage(
            email: _emailController.text,
            id: displayName!,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print("Failed to sign in: $e");
    } catch (e) {
      print("Failed to sign in: $e");
    }
  }
}
