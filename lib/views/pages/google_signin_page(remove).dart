// //WORKS BUT TOO MUCH UNNECESSARY CODE

// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/services/auth_service.dart';
// import 'package:flutter_application_1/views/pages/login_page.dart';
// import 'package:flutter_application_1/views/widget_tree.dart';
// import 'package:flutter_application_1/views/widgets/appbar_widget.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// void main() {
//   runApp(const MaterialApp(title: 'Google Sign In', home: SignInDemo()));
// }

// /// The SignInDemo app.
// class SignInDemo extends StatefulWidget {
//   ///
//   const SignInDemo({super.key});

//   @override
//   State createState() => _SignInDemoState();
// }

// class _SignInDemoState extends State<SignInDemo> {
//   GoogleSignInAccount? _currentUser;
//   bool _isAuthorized = false; // has granted permissions?
//   String _contactText = '';
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();

//     // #docregion Setup
//     // final GoogleSignIn signIn = GoogleSignIn.instance;
//     // unawaited(
//     //   signIn.initialize().then((
//     //     _,
//     //   ) {
//     //     signIn.authenticationEvents
//     //         .listen(_handleAuthenticationEvent)
//     //         .onError(_handleAuthenticationError);

//     //     /// This example always uses the stream-based approach to determining
//     //     /// which UI state to show, rather than using the future returned here,
//     //     /// if any, to conditionally skip directly to the signed-in state.
//     //     signIn.attemptLightweightAuthentication();
//     //   }),
//     // );
//     // #enddocregion Setup
//   }

//   Future<void> _handleAuthenticationEvent(
//     GoogleSignInAuthenticationEvent event,
//   ) async {
//     // #docregion CheckAuthorization
//     final GoogleSignInAccount? user = // ...
//         // #enddocregion CheckAuthorization
//         switch (event) {
//           GoogleSignInAuthenticationEventSignIn() => event.user,
//           GoogleSignInAuthenticationEventSignOut() => null,
//         };

//     setState(() {
//       _currentUser = user;
//       // _isAuthorized = authorization != null;
//       _errorMessage = '';
//     });
//   }

//   Future<void> _handleAuthenticationError(Object e) async {
//     setState(() {
//       _currentUser = null;
//       _isAuthorized = false;
//       _errorMessage = e is GoogleSignInException
//           ? _errorMessageFromSignInException(e)
//           : 'Unknown error: $e';
//     });
//   }

//   Future<void> _handleSignOut() async {
//     // Disconnect instead of just signing out, to reset the example state as
//     // much as possible.
//     await GoogleSignIn.instance.signOut();
//   }

//   Widget body() {
//     return Scaffold(
//       appBar: AppbarWidget(),
//       bottomNavigationBar: _signin(context),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               _emailAddress(),
//               const SizedBox(height: 20),
//               _password(),
//               const SizedBox(height: 20),
//               _signup(context),
//               const SizedBox(height: 20),
//               _googleSignin(),
//             ],
//           ),
//         ),
//       ),
//     );
//     // if (_errorMessage.isNotEmpty) Text(_errorMessage),
//   }

//   /// Returns the list of widgets to include if the user is authenticated.
//   List<Widget> _buildAuthenticatedWidgets(GoogleSignInAccount user) {
//     return <Widget>[
//       // The user is Authenticated.
//       ListTile(
//         leading: GoogleUserCircleAvatar(identity: user),
//         title: Text(user.displayName ?? ''),
//         subtitle: Text(user.email),
//       ),
//       const Text('Signed in successfully.'),
//       if (_isAuthorized) ...<Widget>[
//         // The user has Authorized all required scopes.
//         if (_contactText.isNotEmpty) Text(_contactText),
//         ElevatedButton(child: const Text('REFRESH'), onPressed: () {}),
//       ],
//       ElevatedButton(onPressed: _handleSignOut, child: const Text('SIGN OUT')),
//     ];
//   }

//   /// Returns the list of widgets to include if the user is not authenticated.
//   List<Widget> _buildUnauthenticatedWidgets() {
//     return <Widget>[
//       const Text('You are not currently signed in.'),
//       // #docregion ExplicitSignIn
//       if (GoogleSignIn.instance.supportsAuthenticate())
//         ElevatedButton(
//           onPressed: () async {
//             try {
//               await GoogleSignIn.instance.authenticate();
//             } catch (e) {
//               // #enddocregion ExplicitSignIn
//               _errorMessage = e.toString();
//               // #docregion ExplicitSignIn
//             }
//           },
//           child: const Text('SIGN IN'),
//         )
//       else ...<Widget>[
//         if (kIsWeb)
//           throw StateError('This should only be called on web')
//         // #enddocregion ExplicitSignIn
//         else
//           const Text(
//             'This platform does not have a known authentication method',
//           ),
//         // #docregion ExplicitSignIn
//       ],
//       // #enddocregion ExplicitSignIn
//     ];
//   }

//   final TextEditingController email_tf_controller = TextEditingController();
//   final TextEditingController password_tf_controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final GoogleSignInAccount? user = _currentUser;
//     return user != null ? WidgetTree() : body();
//   }

//   Widget _emailAddress() {
//     return TextField(
//       controller: email_tf_controller,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(),
//         labelText: 'e-mail',
//       ),
//     );
//   }

//   Widget _password() {
//     return TextField(
//       controller: password_tf_controller,
//       obscureText: true,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(),
//         labelText: 'password',
//       ),
//     );
//   }

//   Widget _signup(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Theme.of(context).colorScheme.tertiary,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//         minimumSize: const Size(double.infinity, 60),
//         elevation: 0,
//       ),
//       onPressed: () async {
//         await AuthService().signup(
//           email: email_tf_controller.text,
//           password: password_tf_controller.text,
//           context: context,
//         );
//       },
//       child: Text(
//         'Sign Up',
//         style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
//       ),
//     );
//   }

//   Widget _googleSignin() {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//         minimumSize: const Size(double.infinity, 60),
//         elevation: 0,
//       ),
//       onPressed: () async {
//         // await signInWithGoogle();
//         final GoogleSignIn signIn = GoogleSignIn.instance;
//         unawaited(
//           signIn.initialize().then((_) {
//             signIn.authenticationEvents
//                 .listen(_handleAuthenticationEvent)
//                 .onError(_handleAuthenticationError);

//             signIn.attemptLightweightAuthentication();
//           }),
//         );
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset('assets/images/google_logo.png', height: 32, width: 32),
//           const SizedBox(width: 8),
//           const Text(
//             'Sign Up with Google',
//             style: TextStyle(color: Colors.black),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _signin(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: RichText(
//         textAlign: TextAlign.center,
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: "Already Have an Account? ",
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.onSurface,
//                 fontWeight: FontWeight.normal,
//                 fontSize: 16,
//               ),
//             ),
//             TextSpan(
//               text: "Log In",
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.tertiary,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginPage()),
//                   );
//                 },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _errorMessageFromSignInException(GoogleSignInException e) {
//     return switch (e.code) {
//       GoogleSignInExceptionCode.canceled => 'Sign in canceled',
//       _ => 'GoogleSignInException ${e.code}: ${e.description}',
//     };
//   }
// }
