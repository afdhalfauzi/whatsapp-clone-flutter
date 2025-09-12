import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/widget_tree.dart';

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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email not verified yet.")),
      );
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
