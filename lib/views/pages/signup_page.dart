import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/views/pages/login_page.dart';
import 'package:flutter_application_1/views/pages/xmp_signInWithGoogle.dart';
import 'package:flutter_application_1/views/widget_tree.dart';
import 'package:flutter_application_1/views/widgets/appbar_widget.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController email_tf_controller = TextEditingController();
  final TextEditingController password_tf_controller = TextEditingController();
  final GoogleAuthService _authService = GoogleAuthService();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    // if (currentUser != null) {
    //   return Text(currentUser.email!);
    // } 
    // else {
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
                const SizedBox(height: 20),
                _signup(context),
                const SizedBox(height: 20),
                _googleSignin(context),
              ],
            ),
          ),
        ),
      );
      
    // }
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
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'password',
      ),
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
        await AuthService().signup(
          email: email_tf_controller.text,
          password: password_tf_controller.text,
          context: context,
        );
      },
      child: Text(
        'Sign Up',
        style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
      ),
    );
  }

  Widget _googleSignin(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        // await signInWithGoogle();
        // Attempt to sign in with Google
        User? user = await _authService.signInWithGoogle();
        // If sign-in is successful, navigate to the HomeScreen
        if (user != null) {
          Navigator.push(
            context,
            // MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
            MaterialPageRoute(builder: (_) => WidgetTree()),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/google_logo.png', height: 32, width: 32),
          const SizedBox(width: 8),
          const Text(
            'Sign Up with Google',
            style: TextStyle(color: Colors.black),
          ),
        ],
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
