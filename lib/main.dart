import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/firestore_manager.dart';
import 'package:flutter_application_1/data/notifiers.dart';
import 'package:flutter_application_1/data/api_manager.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/mqtt/mqtt_app_state.dart';
import 'package:flutter_application_1/mqtt/mqtt_connection.dart';
import 'package:flutter_application_1/services/local_notification_service.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import 'package:flutter_application_1/utils/show_toast.dart';
// import 'package:flutter_application_1/views/pages/api_delete_page.dart';
// import 'package:flutter_application_1/views/pages/api_get_page.dart';
import 'package:flutter_application_1/views/pages/signup_page.dart';
import 'package:flutter_application_1/views/widget_tree.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final fln = LocalNotificationService();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print(
        'Title: ${message.notification!.title} | Body: ${message.notification!.body}',
      );
      showToast('${message.notification!.body}');
      fln.showSimple(
        title: message.notification!.title!,
        body: message.notification!.body!,
      );
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser; 
    final Brightness brightness = MediaQuery.of(context).platformBrightness;

    isDarkModeNotifier.value = brightness == Brightness.dark;
    return MultiProvider(
      providers: [
        Provider<FirestoreManager>(create: (context) => FirestoreManager()),
        ChangeNotifierProvider(create: (context) => MQTTAppState()),
        Provider<APIManager>(create: (context) => APIManager()),
        Provider<MqttConnection>(create: (context) => MqttConnection()),
        Provider<NotificationService>(create: (context) => NotificationService()),
      ],
      child: ValueListenableBuilder(
        valueListenable: isDarkModeNotifier,
        builder: (context, isDarkMode, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: isDarkMode ? Brightness.dark : Brightness.light,
              ),
            ),
            // home: const WidgetTree(),
            // home: SignupPage(),
            home: currentUser != null ? WidgetTree() : SignupPage(),
            // home: APIDeletePage(),
          );
        },
      ),
    );
  }
}
