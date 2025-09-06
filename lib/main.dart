import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/database_manager.dart';
import 'package:flutter_application_1/data/notifiers.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/mqtt/mqtt_connection.dart';
import 'package:flutter_application_1/views/widget_tree.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return MultiProvider(providers: [
      Provider<MqttConnection>(
        create: (context) {
          final mqtt = MqttConnection();
          mqtt.connectMQTT();
          return mqtt;
        },
      ),
      Provider<DatabaseManager>(create: (context) {
        final db = DatabaseManager();
        return db;
      },)
    ], child: ValueListenableBuilder(
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
            home: const WidgetTree(),
          );
        }));
  }
}
