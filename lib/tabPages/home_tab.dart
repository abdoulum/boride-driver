import 'dart:async';

import 'package:boride_driver/assistants/assistant_methods.dart';
import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/push_notifications/push_notification_system.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kBorideHq = CameraPosition(
    target: LatLng(9.074329, 7.507098),
    zoom: 17,
  );

  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  String statusText = "Now Offline";
  Color buttonColor = Colors.grey;
  bool isDriverActive = false;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 16);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    await AssistantMethods.searchAddressForGeographicCoOrdinates(
        driverCurrentPosition!, context);
  }

  readCurrentDriverInformation() async {
    currentFirebaseUser = fAuth.currentUser;
    await FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .once()
        .then((DatabaseEvent snap) async {
      if (snap.snapshot.value != null) {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.earnings = (snap.snapshot.value as Map)["earnings"];
        onlineDriverData.ratings =
            (snap.snapshot.value as Map)["ratings"] ?? "0";
        onlineDriverData.photoUrl =
            (snap.snapshot.value as Map)["driver_photo"];
        onlineDriverData.car_color =
            (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_model =
            (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineDriverData.car_number =
            (snap.snapshot.value as Map)["car_details"]["car_number"];
        onlineDriverData.car_brand =
            (snap.snapshot.value as Map)["car_details"]["car_brand"];
        driverVehicleType = (snap.snapshot.value as Map)["car_details"]["type"];

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('my_name', onlineDriverData.name!);
        prefs.setString('my_email', onlineDriverData.email!);
        prefs.setString('my_phone', onlineDriverData.phone!);
        prefs.setString('v_number', onlineDriverData.car_number!);
        prefs.setString('v_color', onlineDriverData.car_color!);
        prefs.setString('v_model', onlineDriverData.car_model!);
        prefs.setString('v_brand', onlineDriverData.car_brand!);
        prefs.setString('my_ratings', onlineDriverData.ratings!);
      }
    });

    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initialize(context);
    pushNotificationSystem.generateAndGetToken();

    AssistantMethods.readDriverTotalEarnings(context);
    AssistantMethods.readDriverWeeklyEarnings(context);
    AssistantMethods.readDriverRating(context);
  }

  @override
  void initState() {
    super.initState();

    checkState();
    readCurrentDriverInformation();
  }

  checkState() async {
    final prefs = await SharedPreferences.getInstance();
    final stat = prefs.getString("user_stat");

    if (stat == "active") {
      isDriverActive = true;
      driverIsOnlineNow();
    } else {
      setState(() {
        isDriverActive = false;
        driverIsOfflineNow();
      });
    }

    if (isDriverActive) {
      setState(() {
        statusText = "Now Online";
        buttonColor = Colors.transparent;
      });
      driverIsOnlineNow();
    } else {
      setState(() {
        statusText = "Now Offline";
        buttonColor = Colors.grey;
      });
      driverIsOfflineNow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          initialCameraPosition: _kBorideHq,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locateDriverPosition();
          },
        ),

        //ui for online offline driver

        statusText != "Now Online"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black87,
              )
            : Container(),

        //locate ui
        Positioned(
          right: 15,
          bottom: 10,
          child: GestureDetector(
            onTap: () {
              locateDriverPosition();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 1.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0,
                      0,
                    ),
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25.0,
                child: Icon(Ionicons.locate, color: Colors.indigo),
              ),
            ),
          ),
        ),

        //button for online offline driver
        Positioned(
          top: statusText != "Now Online"
              ? MediaQuery.of(context).size.height * 0.5
              : 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (isDriverActive != true) //offline
                  {
                    setState(() {
                      statusText = "Now Online";
                      isDriverActive = true;
                      buttonColor = Colors.transparent;
                    });
                    driverIsOnlineNow();
                    updateDriversLocationAtRealTime();
                  } else //online
                  {
                    setState(() {
                      statusText = "Now Offline";
                      isDriverActive = false;
                      buttonColor = Colors.grey;
                    });
                    driverIsOfflineNow();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusText != "Now Online"
                      ? const Color.fromARGB(255, 241, 42, 28)
                      : Colors.indigo,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: statusText != "Now Online"
                    ? Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Ionicons.phone_portrait,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");

    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRide");

    ref.set("idle"); //searching for ride request
    ref.onValue.listen((event) {});

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_stat", "active");
  }

  updateDriversLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;

      if (isDriverActive == true) {
        Geofire.setLocation(currentFirebaseUser!.uid,
            driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude,
      );

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow() async {
    streamSubscriptionPosition!.pause();
    await streamSubscriptionPosition!.cancel();
    Geofire.removeLocation(fAuth.currentUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRide");
    ref.onDisconnect();
    ref.remove();
    ref = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_stat", "inactive");
  }
}
