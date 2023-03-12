// Optimize this flutter UI code and get me only code

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taxigo/screens/registration_page.dart';

class LoginPage extends StatelessWidget {
  static const String id = "login";

  const LoginPage({super.key});

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
                  child: Column(
                    children: [
                      // #email
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email address",
                        ),
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 10),

                      // #password
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // #button
                CupertinoButton(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(24),
                  onPressed: () {},
                  child: const SizedBox(
                    height: 40,
                    child: Center(
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
