import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taxigo/brand_colors.dart';
import 'package:taxigo/widgets/button_widget.dart';

class RegistrationPage extends StatelessWidget {
  static const String id = "registration";

  const RegistrationPage({super.key});

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
                  child: Column(
                    children: [
                      // #fullname
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Fullname",
                        ),
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 10),

                      // #email
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email address",
                        ),
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 10),

                      // #fullname
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Phone number",
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
                TaxiButton(
                  title: "REGISTER",
                  color: BrandColors.accentPurple,
                  onPressed: () {},
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
