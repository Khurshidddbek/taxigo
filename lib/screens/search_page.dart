import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxigo/brand_colors.dart';
import 'package:taxigo/dataprovider/app_data.dart';

class SearchPage extends StatefulWidget {
  static const String id = "search_page";
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // #set current location
    pickupController.text =
        Provider.of<AppData>(context).currentLocation?.placeName ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Set Destination",
          style: TextStyle(fontFamily: "Brand-Bold", color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            if (FocusScope.of(context).hasFocus) {
              FocusScope.of(context).unfocus();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
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
                      Expanded(
                        child: TextField(
                          controller: pickupController,
                          decoration: const InputDecoration(
                            hintText: "Pickup location",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
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
                      Expanded(
                        child: TextField(
                          controller: destinationController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: "Where to?",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
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
      ),
    );
  }
}
