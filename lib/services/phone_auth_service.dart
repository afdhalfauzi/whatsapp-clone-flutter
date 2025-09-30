import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/show_toast.dart';
import 'package:flutter_application_1/views/pages/otp_page.dart';

class PhoneAuthService {
  Future<String?> sendOTP({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    final completer = Completer<String?>();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verification (Android only)
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        print("Verification ID: $verificationId");
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return completer.future;
  }

  Future<User?> verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential user = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      print("User logged in: ${user.user?.phoneNumber}");

      return user.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-verification-code':
          print("❌ The OTP you entered is invalid.");
          showToast("❌ The OTP you entered is invalid.");
          break;
        case 'session-expired':
          print("❌ The OTP has expired. Please request a new one.");
          break;
        case 'too-many-requests':
          print("⚠️ Too many attempts. Please try again later.");
          break;
        case 'invalid-verification-id':
          print("⚠️ Invalid verification ID. Restart the process.");
          break;
        default:
          print("⚠️ FirebaseAuth error: ${e.code} — ${e.message}");
      }
    } catch (e) {
      print("⚠️ Unexpected error: $e");
    }
  }
}
