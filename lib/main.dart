import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taxigo/firebase_options.dart';
import 'package:taxigo/screens/login_page.dart';
import 'package:taxigo/screens/main_page.dart';
import 'package:taxigo/screens/registration_page.dart';

void main() async {
  // Firebase init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TAXIGO',
      theme: ThemeData(
        fontFamily: "Brand-Regular",
      ),
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => const LoginPage(),
        RegistrationPage.id: (context) => const RegistrationPage(),
        MainPage.id: (context) => const MainPage(),
      },
    );
  }
}
