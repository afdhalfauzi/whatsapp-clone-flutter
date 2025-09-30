import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/email_auth_service.dart';
import 'package:flutter_application_1/views/pages/login_page.dart';
import 'package:flutter_application_1/views/pages/verify_email_page.dart';
import 'package:flutter_application_1/views/widget_tree.dart';
import 'package:flutter_application_1/views/widgets/appbar_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController email_tf_controller = TextEditingController();
  final TextEditingController password_tf_controller = TextEditingController();

  bool obscurePassword = true;
  bool showPassChecked = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // return Text(currentUser.email!);
      return WidgetTree();
    } else {
      // sign in first
      return Scaffold(
        appBar: AppbarWidget(),
        bottomNavigationBar: _signin(context),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _emailAddress(),
                const SizedBox(height: 20),
                _password(),
                _showPassword(),
                const SizedBox(height: 20),
                _signup(context),
                const SizedBox(height: 20),
                // _googleSignin(context),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _emailAddress() {
    return TextField(
      controller: email_tf_controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'e-mail',
      ),
    );
  }

  Widget _password() {
    return TextField(
      controller: password_tf_controller,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'password',
      ),
    );
  }

  Widget _showPassword() {
    return Row(
      children: [
        Checkbox(
          value: showPassChecked,
          onChanged: (value) {
            setState(() {
              showPassChecked = value ?? false;
              obscurePassword = !showPassChecked;
            });
          },
        ),
        Text("Show Password"),
      ],
    );
  }

  Widget _signup(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        setState(() => isLoading = true);
        User? user = await EmailAuthService().signup(
          email: email_tf_controller.text,
          password: password_tf_controller.text,
          displayName: email_tf_controller.text.split('@')[0],
          photoURL:
              "https://cdn.vectorstock.com/i/1000v/66/13/default-avatar-profile-icon-social-media-user-vector-49816613.jpg",
          context: context,
        );
        setState(() => isLoading = false);
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const VerifyEmailPage(),
            ),
          );
        }
      },
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white,)
          : Text(
              'Sign Up',
              style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
            ),
    );
  }

  Widget _signin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already Have an Account? ",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: "Log In",
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
