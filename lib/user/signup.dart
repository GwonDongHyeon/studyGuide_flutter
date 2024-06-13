// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String _confirmPasswordError = '';
  String _emailError = '';
  String _idError = '';
  String _passwordError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('화원가입'),
        backgroundColor: const Color.fromARGB(255, 80, 180, 220),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailError.isNotEmpty ? _emailError : null,
              ),
            ),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'Id',
                errorText: _idError.isNotEmpty ? _idError : null,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _passwordError.isNotEmpty ? _passwordError : null,
              ),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                errorText: _confirmPasswordError.isNotEmpty
                    ? _confirmPasswordError
                    : null,
              ),
              onChanged: (value) {
                if (_passwordController.text == value) {
                  setState(() {
                    _confirmPasswordError = '';
                  });
                }
              },
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 80, 180, 220),
              ),
              child: const Text('회원가입'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('로그인',
                  style: TextStyle(color: Color.fromARGB(255, 80, 180, 220))),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    setState(() {
      _emailError = '';
      _idError = '';
      _passwordError = '';
      _confirmPasswordError = '';
    });

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Email을 입력해 주세요';
      });
    }
    if (_idController.text.isEmpty) {
      setState(() {
        _idError = 'Id를 입력해 주세요';
      });
    }
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password를 입력해 주세요';
      });
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = 'Password가 일치하지 않습니다';
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Password가 일치하지 않습니다'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      await userCredential.user!
          .updateProfile(displayName: _idController.text.trim());
      await userCredential.user!.reload();
      User? updatedUser = _auth.currentUser;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': _emailController.text.trim(),
        'displayName': updatedUser?.displayName,
      });

      print("User signed up: ${userCredential.user}");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('회원가입 성공'),
            content: const Text('화원가입에 성공하였습니다'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print("Failed to sign up: $e");
    } catch (e) {
      print("Failed to sign up: $e");
    }
  }
}
