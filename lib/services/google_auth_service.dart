// //NEEDS FIXING
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// Future signInWithGoogle() async {
//   // Trigger the authentication flow
//   final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication googleAuth = googleUser!.authentication;

//   // Create a new credential
//   final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }


// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// String? clientId;
// String? serverClientId;
// GoogleSignInAccount? _currentUser;
//   bool _isAuthorized = false; // has granted permissions?
//   String _contactText = '';
//   String _errorMessage = '';
//   String _serverAuthCode = '';

// Future signInWithGoogle() async {
//   final GoogleSignIn signIn = GoogleSignIn.instance;
//   unawaited(
//     signIn.initialize(clientId: clientId, serverClientId: serverClientId).then((
//       _,
//     ) {
//       signIn.authenticationEvents
//           .listen(_handleAuthenticationEvent)
//           .onError(_handleAuthenticationError);

//       /// This example always uses the stream-based approach to determining
//       /// which UI state to show, rather than using the future returned here,
//       /// if any, to conditionally skip directly to the signed-in state.
//       signIn.attemptLightweightAuthentication();
//     }),
//   );

//   // Trigger the authentication flow
//   final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
//       .authenticate();

//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication googleAuth = googleUser!.authentication;

//   // Create a new credential
//   final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }

//  Future<void> _handleAuthenticationEvent(
//     GoogleSignInAuthenticationEvent event,
//   ) async {
//     // #docregion CheckAuthorization
//     final GoogleSignInAccount? user = // ...
//     // #enddocregion CheckAuthorization
//     switch (event) {
//       GoogleSignInAuthenticationEventSignIn() => event.user,
//       GoogleSignInAuthenticationEventSignOut() => null,
//     };

//     // Check for existing authorization.
//     // #docregion CheckAuthorization
//     final GoogleSignInClientAuthorization? authorization = await user
//         ?.authorizationClient
//         .authorizationForScopes(scopes);
//     // #enddocregion CheckAuthorization

//     setState(() {
//       _currentUser = user;
//       _isAuthorized = authorization != null;
//       _errorMessage = '';
//     });

//     // If the user has already granted access to the required scopes, call the
//     // REST API.
//     // if (user != null && authorization != null) {
//     //   unawaited(_handleGetContact(user));
//     // }
//   }

//   Future<void> _handleAuthenticationError(Object e) async {
//     setState(() {
//       _currentUser = null;
//       _isAuthorized = false;
//       _errorMessage =
//           e is GoogleSignInException
//               ? _errorMessageFromSignInException(e)
//               : 'Unknown error: $e';
//     });
//   }
