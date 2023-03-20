import 'package:flutter/material.dart';
import 'package:taxigo/brand_colors.dart';

class SearchPage extends StatefulWidget {
  static const String id = "search_page";
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Set Destination",
          style: TextStyle(fontFamily: "Brand-Bold", color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // #textfields
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: .5,
                  offset: Offset(.7, .7),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // #current location
                Row(
                  children: [
                    Image.asset(
                      "assets/images/pickicon.png",
                      height: 16,
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Pickup location",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: BrandColors.lightGrayFair,
                          filled: true,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // #to location
                Row(
                  children: [
                    Image.asset(
                      "assets/images/desticon.png",
                      height: 16,
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Where to?",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: BrandColors.lightGrayFair,
                          filled: true,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // #search results
        ],
      ),
    );
  }
}
