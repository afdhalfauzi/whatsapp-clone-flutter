import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/api_manager.dart';
import 'package:flutter_application_1/services/email_auth_service.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import 'package:flutter_application_1/views/pages/login_phone_page.dart';
import 'package:flutter_application_1/services/google_auth_service.dart';
import 'package:flutter_application_1/views/widget_tree.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool obscurePassword = true;
  bool showPassChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _signup(context),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: const Center(child: Icon(Icons.arrow_back_ios_new_rounded)),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Hello Again',
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              _emailAddress(),
              const SizedBox(height: 20),
              _password(),
              _showPassword(),
              const SizedBox(height: 20),
              _signin(context),
              const SizedBox(height: 20),
              Row(children: [_googleSignin(context),const SizedBox(width: 10), _phoneSignin(context)]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailAddress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Email address',
            hintStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _password() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: obscurePassword,
          controller: _passwordController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Password',
            hintStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
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

  Widget _signin(BuildContext context) {
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

        User? user = await EmailAuthService().signin(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
        api.put(
          table: "tenant",
          newData: {"tenantId": user!.uid, "fcmToken": notif.FCMToken},
        );
      },
      child: Text(
        "Sign In",
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
    );
  }

  Widget _signup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "New User? ",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            TextSpan(
              text: "Create Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleSignin(context) {
    final notif = Provider.of<NotificationService>(context, listen: false);
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: Colors.black26, width:1),
          minimumSize: const Size(double.infinity, 60),
          elevation: 0,
        ),
        onPressed: () async {
          // Attempt to sign in with Google
          User? user = await GoogleAuthService().signInWithGoogle();
          if (user != null) {
            final api = Provider.of<APIManager>(context, listen: false);
      
            final existingTenant = await api.get(
              table: "tenant",
              condition: {"tenantId": user.uid},
            );
      
            if (existingTenant.isNotEmpty) {
              await api.put(
                table: "tenant",
                newData: {"tenantId": user.uid, "fcmToken": notif.FCMToken},
              );
            } else {
              api.post(
                table: "tenant",
                newData: {
                  "tenantId": user.uid,
                  "roomId": null,
                  "name": user.displayName,
                  "email": user.email,
                  "photoUrl": user.photoURL,
                  "phoneNumber": user.phoneNumber,
                  "accountProvider": "google",
                  "fcmToken": notif.FCMToken,
                  "createdAt": DateFormat(
                    'yyyy-MM-dd HH:mm:ss',
                  ).format(DateTime.now()),
                },
              );
            }
            Navigator.push(
              context,
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
              'Google',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _phoneSignin(context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: Colors.black26, width:1),
          minimumSize: const Size(double.infinity, 60),
          elevation: 0,
        ),
        onPressed: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginPhonePage()),
            );},
        child: Row(
          children: [
            Icon(Icons.phone_android,color: Colors.black,size: 24,),
            const SizedBox(width: 8),
            const Text('Phone Number',style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
