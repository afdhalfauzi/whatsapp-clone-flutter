import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/show_toast.dart';
import 'package:flutter_application_1/views/pages/verify_email_page.dart';
import 'package:flutter_application_1/views/widget_tree.dart';

class AuthService {
  Future<User?> signup({
    required String email,
    required String password,
    required BuildContext context,
    required String displayName,
    required String photoURL,
  }) async {
    try {
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = cred.user;

      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        //Send Verification
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          showToast("Verification email has been sent to ${user.email}");
        }
      }

      //Navigate
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const VerifyEmailPage(),
        ),
      );
      return user;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email is invalid.';
      }
      showToast(message);
    } catch (e) {}
  }

  Future<User?> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const WidgetTree(),
        ),
      );

      return user;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        message = 'Wrong password. Did you sign up with Google?';
      } else if (e.code == 'user-disabled') {
        message = 'The user account has been disabled by an administrator.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      showToast(message);
    } catch (e) {}
  }

  Future<void> signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
  }
}
