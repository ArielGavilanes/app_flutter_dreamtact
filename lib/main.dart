import 'package:app_dreamtact/pages/contact_view_page.dart';
import 'package:app_dreamtact/pages/create_contact_page.dart';
import 'package:app_dreamtact/pages/home_page.dart';
import 'package:app_dreamtact/pages/login_page.dart';
import 'package:app_dreamtact/pages/profile_page.dart';
import 'package:app_dreamtact/pages/register_page.dart';
import 'package:app_dreamtact/pages/specific_contact.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _routes = {
    '/add': (context) => const AddContactPage(),
    '/profile': (context) => const ProfilePage(),
    '/home': (context) => const HomePage(),
    '/register': (context) => const RegisterPage(),
    '/contacts': (context) => const ContactView(),
    '/login': (context) => const LoginPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        if (settings.name == '/specific') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return SpecificContactPage(id: args);
            },
          );
        }
        return MaterialPageRoute(
          builder: (context) => _routes[settings.name]!(context),
        );
      },
      routes: _routes,
    );
  }
}
