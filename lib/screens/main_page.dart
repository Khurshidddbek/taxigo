import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxigo/domains/app_lat_long.dart';
import 'package:taxigo/domains/location_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../brand_colors.dart';

class MainPage extends StatefulWidget {
  static const String id = "main";

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mapControllerCompleter = Completer<YandexMapController>();
  late final List<MapObject> mapObjects = [];
  bool showLocationLoading = false;

  @override
  void initState() {
    super.initState();
    _initLocationPermission().ignore();
  }

  // Functions =================================================================

  Future<void> _initLocationPermission() async {
    setState(() {
      showLocationLoading = true;
    });

    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }

    await _fetchCurrentocation();

    setState(() {
      showLocationLoading = false;
    });
  }

  Future<void> _fetchCurrentocation() async {
    AppLatLong currentLocation;
    const defLocation = TashkentLocation();

    try {
      currentLocation = await LocationService().getCurrentLocation();
    } catch (e) {
      currentLocation = defLocation;
    }

    _moveToCurrentLocation(currentLocation);
  }

  Future<void> _moveToCurrentLocation(AppLatLong currentLocation) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.smooth, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
              latitude: currentLocation.lat, longitude: currentLocation.long),
          zoom: 15,
        ),
      ),
    );

    _addCurrentLocationToMapObjects(currentLocation);
  }

  void _addCurrentLocationToMapObjects(AppLatLong currentLocation) {
    setState(() {
      mapObjects.add(
        PlacemarkMapObject(
          mapId: const MapObjectId('current_location'),
          point: Point(
            latitude: currentLocation.lat,
            longitude: currentLocation.long,
          ),
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              scale: 2.5,
              image:
                  BitmapDescriptor.fromAssetImage('assets/images/pickicon.png'),
            ),
          ),
        ),
      );
    });
  }

  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/user_icon.png",
                    height: 100,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      // #username
                      Text(
                        "Khurshid",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Brand-Bold",
                        ),
                      ),

                      Text("View Profile"),
                    ],
                  ),
                ],
              ),
            ),

            // #1
            ListTile(
              leading: const Icon(Icons.card_giftcard_outlined),
              title: const Text(
                "Free Rides",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {},
            ),

            // #2
            ListTile(
              leading: const Icon(Icons.credit_card_rounded),
              title: const Text(
                "Payments",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {},
            ),

            // #3
            ListTile(
              leading: const Icon(Icons.history_outlined),
              title: const Text(
                "Ride History",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {},
            ),

            // #4
            ListTile(
              leading: const Icon(Icons.contact_support_outlined),
              title: const Text(
                "Support",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {},
            ),

            // #5
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text(
                "About",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // #map
          YandexMap(
            mapObjects: mapObjects,
            onMapCreated: (controller) {
              mapControllerCompleter.complete(controller);
            },
          ),

          // #drawer call button
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: .5,
                        offset: Offset(.7, .7),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.menu, color: Colors.black87),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // #gps button
                Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 20),
                  child: GestureDetector(
                    onTap: () => _initLocationPermission(),
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            spreadRadius: .5,
                            offset: Offset(.7, .7),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 28,
                        child: showLocationLoading
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.gps_fixed_outlined,
                                color: Colors.black87,
                              ),
                      ),
                    ),
                  ),
                ),

                // #bottomsheet
                Container(
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
                          style:
                              TextStyle(fontFamily: "Brand-Bold", fontSize: 18),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
