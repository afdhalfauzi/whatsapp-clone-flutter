import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/api_manager.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import 'package:flutter_application_1/views/widget_tree.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isVerified = false;
  bool isChecking = false;

  Future<void> checkVerification() async {
    setState(() => isChecking = true);

    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // refresh the user
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      setState(() => isVerified = true);
      final api = Provider.of<APIManager>(context, listen: false);
      final notif = Provider.of<NotificationService>(context, listen: false);
      api.post(
        table: "tenant",
        newData: {
          "tenantId": user.uid,
          "roomId": null,
          "name": user.displayName,
          "email": user.email,
          "photoUrl": user.photoURL,
          "phoneNumber": user.phoneNumber,
          "accountProvider": "email",
          "fcmToken": notif.FCMToken,
          "createdAt": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        },
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Email not verified yet.")));
    }

    setState(() => isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify your email")),
      body: Center(
        child: isVerified
            ? const Text("Email verified! Redirecting...")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "We’ve sent a verification link to your email.\n"
                    "Please verify before continuing.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Didn't get the email? check your spam folder or try resending",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isChecking ? null : checkVerification,
                    child: isChecking
                        ? const CircularProgressIndicator()
                        : const Text("I have verified"),
                  ),
                ],
              ),
      ),
    );
  }
}
