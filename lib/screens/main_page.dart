import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxigo/brand_colors.dart';

class MainPage extends StatelessWidget {
  static const String id = "main";

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // #map
          Container(
            color: Colors.blue[50],
          ),

          // #bottomsheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    spreadRadius: .5,
                    offset: Offset(.7, .7),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nice to see you!",
                      style: TextStyle(fontSize: 12),
                    ),
                    const Text(
                      "Where are you going?",
                      style: TextStyle(fontFamily: "Brand-Bold", fontSize: 18),
                    ),

                    const SizedBox(height: 20),

                    // #search
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: .5,
                            offset: Offset(.7, .7),
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            CupertinoIcons.search,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(width: 10),
                          Text("Search destination"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // #home
                    Row(
                      children: [
                        const Icon(
                          Icons.home_outlined,
                          color: BrandColors.dimText,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Add Home",
                              style: TextStyle(
                                fontFamily: "Brand-Bold",
                                color: BrandColors.textSemiLight,
                              ),
                            ),
                            Text(
                              "Your residential address",
                              style: TextStyle(
                                fontSize: 14,
                                color: BrandColors.dimText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Divider(
                      height: 40,
                      color: BrandColors.dimText,
                    ),

                    // #work
                    Row(
                      children: [
                        const Icon(
                          Icons.work_outline,
                          color: BrandColors.dimText,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Add Work",
                              style: TextStyle(
                                fontFamily: "Brand-Bold",
                                color: BrandColors.textSemiLight,
                              ),
                            ),
                            Text(
                              "Your office address",
                              style: TextStyle(
                                fontSize: 14,
                                color: BrandColors.dimText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
