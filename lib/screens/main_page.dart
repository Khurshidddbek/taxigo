import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:taxigo/datamodels/address.dart' as address;
import 'package:taxigo/datamodels/direction_details.dart';
import 'package:taxigo/datamodels/search_area.dart' as search_area;
import 'package:taxigo/dataprovider/app_data.dart';
import 'package:taxigo/domains/location_service.dart';
import 'package:taxigo/screens/search_page.dart';
import 'package:taxigo/widgets/button_widget.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as y_mapkit;

import '../brand_colors.dart';
import '../widgets/progress_dialog_widget.dart';

class MainPage extends StatefulWidget {
  static const String id = "main";

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mapControllerCompleter = Completer<y_mapkit.YandexMapController>();
  late final List<y_mapkit.MapObject> mapObjects = [];
  bool showLocationLoading = false;

  DirectionDetails? directionDetails;

  double searchSheetHeight = 290;
  double rideSheetHeight = 0; // 270
  double requestingSheetHeight = 0; // 220
  double mapBottomPaddingHeight = 286; // sheetHeight - 4

  bool get drawerCanOpen => rideSheetHeight == 0;

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
    address.Address currentLocation;
    final defLocation = address.TashkentLocation();

    try {
      currentLocation = await LocationService().getCurrentLocation();
    } catch (e) {
      currentLocation = defLocation;
    }

    // #geocoding
    GeocodeResponse? geocodeResponse =
        await LocationService().getAddressByCordinates(currentLocation);
    if (geocodeResponse != null) {
      // #TODO: currentLocation.placeId = ...something
      currentLocation.placeName = geocodeResponse.firstAddress?.formatted;
      currentLocation.placeFormattedName =
          geocodeResponse.firstFullAddress.formattedAddress;
    }

    if (context.mounted) {
      Provider.of<AppData>(context, listen: false)
          .updateCurrentLocation(currentLocation);

      _moveCameraToCurrentLocation(currentLocation);
    }
  }

  Future<void> _moveCameraToCurrentLocation(
      address.Address currentLocation) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const y_mapkit.MapAnimation(
          type: y_mapkit.MapAnimationType.smooth, duration: 1),
      y_mapkit.CameraUpdate.newCameraPosition(
        y_mapkit.CameraPosition(
          target: y_mapkit.Point(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude,
          ),
          zoom: 15,
        ),
      ),
    );

    await updateSearchArea();

    _addCurrentLocationToMapObjects(currentLocation);
  }

  Future<void> updateSearchArea() async {
    search_area.SearchArea? newSearchArea;

    (await mapControllerCompleter.future).getFocusRegion().then((value) {
      newSearchArea?.lowerLeftLongitude = value.bottomLeft.longitude;
      newSearchArea?.lowerLeftLatitude = value.bottomLeft.latitude;
      newSearchArea?.upperRightLongitude = value.topRight.longitude;
      newSearchArea?.upperRightLatitude = value.topRight.latitude;
    });

    if (newSearchArea != null && context.mounted) {
      Provider.of<AppData>(context, listen: false)
          .updateSearchArea(newSearchArea);
    }
  }

  void _addCurrentLocationToMapObjects(address.Address currentLocation) {
    setState(() {
      mapObjects.add(
        y_mapkit.PlacemarkMapObject(
          mapId: const y_mapkit.MapObjectId('current_location_radius'),
          point: y_mapkit.Point(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude,
          ),
          icon: y_mapkit.PlacemarkIcon.single(
            y_mapkit.PlacemarkIconStyle(
              scale: 3,
              image: y_mapkit.BitmapDescriptor.fromAssetImage(
                  'assets/images/pickicon.png'),
            ),
          ),
          opacity: .35,
        ),
      );
      mapObjects.add(
        y_mapkit.PlacemarkMapObject(
          mapId: const y_mapkit.MapObjectId('current_location'),
          point: y_mapkit.Point(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude,
          ),
          icon: y_mapkit.PlacemarkIcon.single(
            y_mapkit.PlacemarkIconStyle(
              scale: 1.5,
              image: y_mapkit.BitmapDescriptor.fromAssetImage(
                  'assets/images/pickicon.png'),
            ),
          ),
          opacity: 1,
        ),
      );
    });
  }

  Future<void> getDirection() async {
    // show loading dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const ProgressDialog(status: "Please wait..."),
    );

    var appDataProvider = Provider.of<AppData>(context, listen: false);
    address.Address? pickup = appDataProvider.currentLocation;
    address.Address? destination = appDataProvider.searchedLocation;

    if (pickup == null || destination == null) {
      // close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      showSnackbar("Current location is not available, please try again");
      return;
    }

    directionDetails =
        await LocationService().getDirectionDetails(pickup, destination);

    // close loading dialog
    if (context.mounted) {
      Navigator.pop(context);
    }

    if (directionDetails == null) {
      // cleaning up the old
      mapObjects.removeWhere(
          (e) => e.mapId == const y_mapkit.MapObjectId('polyline'));
      setState(() {});

      showSnackbar("Connection failed, please try again");
      return;
    }

    // #add points (direction) to map
    final List<y_mapkit.Point> points = [];

    for (var point
        in PolylinePoints().decodePolyline(directionDetails!.encodedPoints)) {
      points.add(
          y_mapkit.Point(latitude: point.latitude, longitude: point.longitude));
    }

    final mapObject = y_mapkit.PolylineMapObject(
      mapId: const y_mapkit.MapObjectId('polyline'),
      polyline: y_mapkit.Polyline(points: points),
    );

    setState(() {
      mapObjects.add(mapObject);
    });

    addPickupAndDestionIconsToMapObjects(pickup, destination);
    zoomCameraToFitPolylineOnScreen(points, directionDetails!.distanceInMeters);
  }

  void showSnackbar(String? text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(child: Text(text ?? "")),
    ));
  }

  void zoomCameraToFitPolylineOnScreen(
      List<y_mapkit.Point> points, double distanceInMeters) async {
    if (points.length < 2) {
      return;
    }

    // Calculate the bounding box of the polyline
    // approximately 0.000001 per kilometer.
    late double bboxMargin;
    if (distanceInMeters <= 1000) {
      bboxMargin = 0.001;
    } else {
      bboxMargin = distanceInMeters > 50000
          ? distanceInMeters * 0.000001
          : distanceInMeters * 0.0000015;
    }

    final lats = points.map((p) => p.latitude);
    final lons = points.map((p) => p.longitude);

    final northEast = y_mapkit.Point(
        latitude: lats.reduce(max) + bboxMargin,
        longitude: lons.reduce(max) + bboxMargin);
    final southWest = y_mapkit.Point(
        latitude: lats.reduce(min) - bboxMargin,
        longitude: lons.reduce(min) - bboxMargin);

    final bbox =
        y_mapkit.BoundingBox(northEast: northEast, southWest: southWest);

    var mapController = await mapControllerCompleter.future;

    // Calculate the zoom level required to fit the polyline on the screen
    mapController.moveCamera(
      animation: const y_mapkit.MapAnimation(
          type: y_mapkit.MapAnimationType.smooth, duration: 1),
      y_mapkit.CameraUpdate.newCameraPosition(
        y_mapkit.CameraPosition(
          target: y_mapkit.Point(
            latitude: (bbox.northEast.latitude + bbox.southWest.latitude) / 2,
            longitude:
                (bbox.northEast.longitude + bbox.southWest.longitude) / 2,
          ),
          // zoom: 15,
        ),
      ),
    );

    // Set bounding box
    mapController.moveCamera(
      animation: const y_mapkit.MapAnimation(
          type: y_mapkit.MapAnimationType.smooth, duration: 1),
      y_mapkit.CameraUpdate.newBounds(bbox),
    );
  }

  void addPickupAndDestionIconsToMapObjects(
      address.Address pickup, address.Address destination) {
    _addCurrentLocationToMapObjects(pickup);

    setState(() {
      mapObjects.add(
        y_mapkit.PlacemarkMapObject(
          mapId: const y_mapkit.MapObjectId('destination_location'),
          point: y_mapkit.Point(
            latitude: destination.latitude,
            longitude: destination.longitude,
          ),
          icon: y_mapkit.PlacemarkIcon.single(
            y_mapkit.PlacemarkIconStyle(
              scale: 1,
              image: y_mapkit.BitmapDescriptor.fromAssetImage(
                  'assets/images/route_start.png'),
            ),
          ),
          opacity: 1,
        ),
      );
    });
  }

  void showRideSheet() {
    rideSheetHeight = 270;
    searchSheetHeight = 0;
    mapBottomPaddingHeight = rideSheetHeight - 4;
    setState(() {});
  }

  void showRequestingSheet() {
    rideSheetHeight = 0;
    requestingSheetHeight = 220;
    mapBottomPaddingHeight = requestingSheetHeight - 4;
    setState(() {});
  }

  void hideRideSheetAndResetMap() {
    rideSheetHeight = 0;
    searchSheetHeight = 290;
    mapBottomPaddingHeight = 286;
    mapObjects.clear();

    setState(() {});

    _initLocationPermission();
  }

  double estimateFares(DirectionDetails? directionDetails) {
    if (directionDetails == null) return 0;

    /// any estimate fares can be here.
    /// here the prices in Uzbekistan are taken as an example.
    const double baseFare = 6500.0; // base fare in Uzbekistan Som (UZS)
    const double perKmCharge = 1500.0; // per kilometer charge in UZS
    const double perMinCharge = 500.0; // per minute charge in UZS
    const double usdToUzsRate = 11393.65; // conversion rate from USD to UZS

    double distanceInKm = directionDetails.distanceInMeters / 1000.0;
    double durationInMin = directionDetails.durationInSeconds / 60.0;

    double fare = baseFare +
        (distanceInKm * perKmCharge) +
        (durationInMin * perMinCharge);

    // convert fare from UZS to USD
    double fareInUsd = fare / usdToUzsRate;

    return fareInUsd;
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
          Positioned(
            left: 0,
            right: 0,
            child: AnimatedSize(
              duration: kThemeAnimationDuration,
              curve: Curves.easeIn,
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.bottom -
                    mapBottomPaddingHeight,
                child: y_mapkit.YandexMap(
                  mapObjects: mapObjects,
                  onMapCreated: (controller) {
                    mapControllerCompleter.complete(controller);
                  },
                  logoAlignment: const y_mapkit.MapAlignment(
                    horizontal: y_mapkit.HorizontalAlignment.left,
                    vertical: y_mapkit.VerticalAlignment.bottom,
                  ),
                ),
              ),
            ),
          ),

          // #drawer call button
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  drawerCanOpen
                      ? _scaffoldKey.currentState?.openDrawer()
                      : hideRideSheetAndResetMap();
                },
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
                    child: Icon(drawerCanOpen ? Icons.menu : Icons.arrow_back,
                        color: Colors.black87),
                  ),
                ),
              ),
            ),
          ),

          // #bottomsheets
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

                // #searchsheet
                AnimatedSize(
                  duration: kThemeAnimationDuration,
                  curve: Curves.easeIn,
                  child: SafeArea(
                    top: false,
                    left: false,
                    right: false,
                    bottom: searchSheetHeight == 0 ? false : true,
                    child: Container(
                      height: searchSheetHeight,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: .5,
                            offset: Offset(0, -.7),
                          ),
                          BoxShadow(
                            color: BrandColors.scaffold,
                            offset: const Offset(0, 15),
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
                              style: TextStyle(
                                  fontFamily: "Brand-Bold", fontSize: 18),
                            ),

                            const SizedBox(height: 20),

                            // #search
                            GestureDetector(
                              onTap: () async {
                                var result = await Navigator.pushNamed(
                                    context, SearchPage.id);

                                if (result == "getDirection") {
                                  await getDirection();
                                  showRideSheet();
                                }
                              },
                              child: Container(
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
                ),

                // #ridesheet
                AnimatedSize(
                  duration: kThemeAnimationDuration,
                  curve: Curves.easeIn,
                  child: SafeArea(
                    top: false,
                    left: false,
                    right: false,
                    bottom: rideSheetHeight == 0 ? false : true,
                    child: Container(
                      height: rideSheetHeight,
                      decoration: BoxDecoration(
                        color: BrandColors.scaffold,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: .5,
                            offset: Offset(0, -.7),
                          ),
                          BoxShadow(
                            color: BrandColors.scaffold,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        top: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            // destination and price
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              color: BrandColors.accent1,
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/taxi.png",
                                    height: 70,
                                    width: 70,
                                  ),

                                  const SizedBox(width: 10),

                                  // #distance in meters
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Taxi",
                                        style: TextStyle(
                                          fontFamily: "Brand-Bold",
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "${(directionDetails?.distanceInKilometers ?? 0).toStringAsFixed(2)} km",
                                        style: const TextStyle(
                                          color: BrandColors.dimText,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Spacer(),

                                  // #price
                                  Text(
                                    "\$${estimateFares(directionDetails).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontFamily: "Brand-Bold",
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // #cash
                            Row(
                              children: const [
                                SizedBox(width: 20),
                                Icon(
                                  Icons.money_rounded,
                                  color: BrandColors.dimText,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Cash",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: BrandColors.dimText,
                                    fontFamily: "Brand-Bold",
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: BrandColors.dimText,
                                  size: 16,
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TaxiButton(
                                title: "REQUEST CAB",
                                color: BrandColors.accent,
                                onPressed: () {
                                  showRequestingSheet();
                                },
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // #requestingsheet
                if (requestingSheetHeight != 0)
                  AnimatedSize(
                    duration: kThemeAnimationDuration,
                    curve: Curves.easeIn,
                    child: SafeArea(
                      top: false,
                      left: false,
                      right: false,
                      bottom: requestingSheetHeight == 0 ? false : true,
                      child: Container(
                        height: requestingSheetHeight,
                        decoration: BoxDecoration(
                          color: BrandColors.scaffold,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: .5,
                              offset: Offset(0, -.7),
                            ),
                            BoxShadow(
                              color: BrandColors.scaffold,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: SafeArea(
                          top: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),

                              // #requesting animation
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: LinearProgressIndicator(
                                  color: BrandColors.textSemiLight,
                                  backgroundColor: BrandColors.scaffold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "Requesting a Ride...",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: 'Brand-Bold',
                                  color: BrandColors.text,
                                ),
                              ),

                              const SizedBox(height: 30),

                              // #button cancel
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: BrandColors.scaffold,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 1,
                                          color: BrandColors.lightGrayFair,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.clear_rounded,
                                        color: BrandColors.text,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Cancel Ride',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: BrandColors.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
