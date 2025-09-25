import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/api_manager.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import 'package:flutter_application_1/views/pages/login_page.dart';
import 'package:flutter_application_1/views/pages/xmp_signInWithGoogle.dart';
import 'package:flutter_application_1/views/widget_tree.dart';
import 'package:flutter_application_1/views/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController email_tf_controller = TextEditingController();
  final TextEditingController password_tf_controller = TextEditingController();
  final GoogleAuthService _authService = GoogleAuthService();

  bool obscurePassword = true;
  bool showPassChecked = false;

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
        final api = Provider.of<APIManager>(context, listen: false);
        final notif = Provider.of<NotificationService>(context, listen: false);

        User? user = await AuthService().signup(
          email: email_tf_controller.text,
          password: password_tf_controller.text,
          displayName: email_tf_controller.text.split('@')[0],
          photoURL:
              "https://cdn.vectorstock.com/i/1000v/66/13/default-avatar-profile-icon-social-media-user-vector-49816613.jpg",
          context: context,
        );
        api.post(
          table: "tenant",
          newData: {
            "tenantId": user!.uid,
            "roomId": null,
            "name": user.displayName,
            "email": user.email,
            "photoUrl": user.photoURL,
            "phoneNumber": user.phoneNumber,
            "accountProvider": "email",
            "fcmToken": notif.FCMToken,
            "createdAt": DateFormat(
              'yyyy-MM-dd HH:mm:ss',
            ).format(DateTime.now()),
          },
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
        // Attempt to sign in with Google
        User? user = await _authService.signInWithGoogle();
        // If sign-in is successful, navigate to the HomeScreen
        if (user != null) {
          Navigator.pushReplacement(
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
