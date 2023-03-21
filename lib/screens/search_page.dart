import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxigo/brand_colors.dart';
import 'package:taxigo/dataprovider/app_data.dart';
import 'package:taxigo/networkservice/http_requests.dart';
import 'package:taxigo/networkservice/parser.dart';
import 'package:taxigo/networkservice/query_parameters.dart';

import '../datamodels/searched_address.dart';
import '../networkservice/apis.dart';
import '../networkservice/debouncer.dart';

class SearchPage extends StatefulWidget {
  static const String id = "search_page";
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();
  List<SearchedAddress> searchedAddresses = [];

  Debouncer debouncer = Debouncer(milliseconds: 1000);

  void searchPlaceByText(String text) async {
    setState(() {
      searchedAddresses = [];
    });

    if (text.length < 3) {
      debouncer.cancel();
      return;
    }

    debouncer.run(() async {
      String? responeData = await HttpRequests.get(
        Apis.searchPlaceByText,
        QueryParameters.searchPlaceByText(
          text: text,
          searchArea: Provider.of<AppData>(context, listen: false).searchArea,
        ),
      );

      setState(() {
        searchedAddresses = Parser.searchPlaceByText(responeData ?? "");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // #set current location
    pickupController.text = Provider.of<AppData>(context, listen: true)
            .currentLocation
            ?.placeName ??
        "";

    return Scaffold(
      backgroundColor: Colors.white,
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
                          onChanged: (value) => searchPlaceByText(value),
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

            const SizedBox(height: 10),

            // #search results
            Expanded(
              child: ListView.separated(
                itemCount: searchedAddresses.length,
                itemBuilder: (context, index) =>
                    SearchedItem(searchedAddress: searchedAddresses[index]),
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchedItem extends StatelessWidget {
  final SearchedAddress searchedAddress;
  const SearchedItem({
    required this.searchedAddress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: BrandColors.dimText,
          ),

          const SizedBox(width: 10),

          // #searched address info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(searchedAddress.name),
                const SizedBox(height: 5),
                Text(
                  searchedAddress.address,
                  style: const TextStyle(color: BrandColors.dimText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
