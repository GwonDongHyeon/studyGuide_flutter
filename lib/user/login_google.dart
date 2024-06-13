// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:studyguide_flutter/video/video_subject.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> loginWithGoogle(BuildContext context) async {
  try {
    final googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();

    final account = await googleSignIn.signIn();

    if (account != null) {
      final id = account.displayName;
      final email = account.email;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoSubjectPage(
            email: email,
            id: id.toString(),
          ),
        ),
      );
    } else {
      print('Google sign-in cancelled');
    }
  } catch (error) {
    print("Error signing in with Google: $error");
  }
}
