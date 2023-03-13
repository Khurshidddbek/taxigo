// Optimize this flutter UI code and get me only code

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:taxigo/brand_colors.dart';
import 'package:taxigo/screens/registration_page.dart';
import 'package:taxigo/widgets/button_widget.dart';
import 'package:taxigo/widgets/progress_dialog_widget.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  static const String id = "login";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variables =================================================================

  var formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Functions (validators) ====================================================

  String? validateEmail(String value) {
    if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return null;
    }
    return "Please, provide a valid email";
  }

  String? validatePassword(String value) {
    if (value.length >= 8) {
      return null;
    }
    return "Please, provide a valid password";
  }

  // Functions =================================================================
  void login() async {
    if (!formKey.currentState!.validate()) return;

    // check internet connection
    if (!(await hasInternetConnection())) {
      showSnackbar("Please, check your internet connection");
    }

    apiLogin();
  }

  Future<bool> hasInternetConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }

  void showSnackbar(String? text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(child: Text(text ?? "")),
    ));
  }

  // APIs ======================================================================
  Future<void> apiLogin() async {
    // show loading dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const ProgressDialog(status: "Loggin you in"),
    );

    // firebaseAuth
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      showSnackbar(e.message);

      // close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      return;
    }

    // check user info is available
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        await apiGetUserInfo();
      } on PlatformException catch (e) {
        showSnackbar(e.message);

        // close loading dialog
        if (context.mounted) {
          Navigator.pop(context);
        }

        return;
      } catch (e) {
        showSnackbar(e.toString());

        // close loading dialog
        if (context.mounted) {
          Navigator.pop(context);
        }

        return;
      }

      // Navigate to main page
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, MainPage.id, (route) => false);
      } else {
        showSnackbar("context is not mounted");
      }
    }
  }

  Future<void> apiGetUserInfo() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users/${FirebaseAuth.instance.currentUser!.uid}");

    await userRef.once().then((value) {
      if (value.snapshot.value == null) {
        throw PlatformException(
            code: "",
            message:
                "Your account information could not be retrieved. Please try again later.");
      }
    });
  }

  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 70),

                // #logo
                SvgPicture.asset(
                  "assets/Logo Files/For Web/svg/White logo - no background.svg",
                  height: 200,
                  width: 200,
                ),

                const SizedBox(height: 35),

                // #title
                const Text(
                  "Sign in as Rider",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Brand-Bold",
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // #textfields
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // #email
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email address",
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) => validateEmail(value ?? ""),
                      ),

                      const SizedBox(height: 10),

                      // #password
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        validator: (value) => validatePassword(value ?? ""),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // #button
                TaxiButton(
                  title: "LOGIN",
                  color: BrandColors.green,
                  onPressed: () {
                    login();
                  },
                ),

                const SizedBox(height: 25),

                // #button
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationPage.id);
                  },
                  child: const Text(
                    "Don't have an account? Sign up here",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
