import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:taxigo/brand_colors.dart';
import 'package:taxigo/screens/main_page.dart';
import 'package:taxigo/widgets/button_widget.dart';

import '../widgets/progress_dialog_widget.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = "registration";

  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Variables =================================================================

  var formKey = GlobalKey<FormState>();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  // Functions (validators) ====================================================
  String? validateFullName(String value) {
    if (value.isNotEmpty || value.length > 3) {
      return null;
    }
    return "Please, provide a valid full name";
  }

  String? validateEmail(String value) {
    if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return null;
    }
    return "Please, provide a valid email";
  }

  String? validatePhoneNumber(String value) {
    if (RegExp(r"^\+?[0-9]{10,}$").hasMatch(value)) {
      return null;
    }
    return "Please, provide a valid phone number";
  }

  String? validatePassword(String value) {
    if (value.length >= 8) {
      return null;
    }
    return "Please, provide a valid password";
  }

  // Functions =================================================================
  void register() async {
    if (!formKey.currentState!.validate()) return;

    // check internet connection
    if (!(await hasInternetConnection())) {
      showSnackbar("Please, check your internet connection");
    }

    apiRegister();
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
  void apiRegister() async {
    // show loading dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const ProgressDialog(status: "Registering you..."),
    );

    // firebaseAuth
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      showSnackbar(e.message);

      // close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      return;
    }

    // FirebaseDatabase
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        await apiPutUserInfo();
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

  Future<void> apiPutUserInfo() async {
    DatabaseReference newUserRef = FirebaseDatabase.instance
        .ref()
        .child("users/${FirebaseAuth.instance.currentUser!.uid}");

    // Prepare data to be saved on users table
    Map userMap = {
      "fullname": fullnameController.text,
      "email": emailController.text,
      "phone": phoneNumberController.text,
    };

    newUserRef.set(userMap);
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
                  "Create a Rider's account",
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
                      // #fullname
                      TextFormField(
                        controller: fullnameController,
                        decoration: const InputDecoration(
                          labelText: "Fullname",
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) => validateFullName(value ?? ""),
                      ),

                      const SizedBox(height: 10),

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

                      // #phone
                      TextFormField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Phone number",
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) => validatePhoneNumber(value ?? ""),
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
                  title: "REGISTER",
                  color: BrandColors.accentPurple,
                  onPressed: () {
                    register();
                  },
                ),

                const SizedBox(height: 25),

                // #button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have a RIDER account? Log in",
                    style: TextStyle(
                      fontSize: 17,
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
