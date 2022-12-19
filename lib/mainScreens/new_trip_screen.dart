import 'dart:async';

import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/models/user_ride_request_information.dart';
import 'package:boride_driver/widgets/receive_pay.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';

import '../assistants/assistant_methods.dart';
import '../widgets/progress_dialog.dart';

class NewTripScreen extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;

  NewTripScreen({
    Key? key,
    this.userRideRequestDetails,
  }) : super(key: key);

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  GoogleMapController? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(9.074329, 7.507098),
    zoom: 17,
  );

  String? buttonTitle = "Arrived";
  Color? buttonColor = Colors.green;

  Set<Marker> setOfMarkers = <Marker>{};
  Set<Circle> setOfCircle = <Circle>{};
  Set<Polyline> setOfPolyline = <Polyline>{};
  List<LatLng> polyLinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double mapPadding = 0;
  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();
  Position? onlineDriverCurrentPosition;

  String rideRequestStatus = "accepted";

  String durationFromOriginToDestination = "";

  bool isRequestDirectionDetails = false;

  bool? hasDiscount;
  int? discountP;

  String paymentMethod = "";
  String phone = "";

  Future<void> drawPolyLineFromOriginToDestination(
      LatLng originLatLng, LatLng destinationLatLng) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    polyLinePositionCoordinates.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      for (var pointLatLng in decodedPolyLinePointsResultList) {
        polyLinePositionCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.grey.shade900,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        width: 4,
        points: polyLinePositionCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      setOfPolyline.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newTripGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      setOfMarkers.add(originMarker);
      setOfMarkers.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.greenAccent,
      radius: 10,
      strokeWidth: 2,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.redAccent,
      radius: 10,
      strokeWidth: 2,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

  @override
  void initState() {
    super.initState();
    streamSubscriptionPosition!.pause();
    streamSubscriptionPosition!.cancel();
    listener();
    checkForDiscount();
    saveAssignedDriverDetailsToUserRideRequest();
  }

  checkForDiscount() {
    //check for discount
    FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .child("p_discount")
        .once()
        .then((value) {
      if (value.snapshot.value != null) {
        setState(() {
          hasDiscount = true;
          discountP = value.snapshot.value as int;
        });
      } else {
        setState(() {
          hasDiscount = false;
        });
      }
    });
  }

  createDriverIconMarker() {
    if (iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png")
          .then((value) {
        iconAnimatedMarker = value;
      });
    }
  }

  getDriversLocationUpdatesAtRealTime() {
    LatLng oldLatLng = const LatLng(0, 0);

    streamSubscriptionDriverLivePosition =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;
      onlineDriverCurrentPosition = position;

      LatLng latLngLiveDriverPosition = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude,
      );

      Marker animatingMarker = Marker(
        markerId: const MarkerId("AnimatedMarker"),
        position: latLngLiveDriverPosition,
        icon: iconAnimatedMarker!,
        infoWindow: const InfoWindow(title: "This is your Position"),
      );

        CameraPosition cameraPosition =
            CameraPosition(target: latLngLiveDriverPosition, zoom: 16);
        newTripGoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        setOfMarkers.removeWhere(
            (element) => element.markerId.value == "AnimatedMarker");
        setOfMarkers.add(animatingMarker);


      oldLatLng = latLngLiveDriverPosition;
      updateDurationTimeAtRealTime();

      //updating driver location at real time in Database
      Map driverLatLngDataMap = {
        "latitude": onlineDriverCurrentPosition!.latitude.toString(),
        "longitude": onlineDriverCurrentPosition!.longitude.toString(),
      };
      FirebaseDatabase.instance
          .ref()
          .child("Ride Request")
          .child(widget.userRideRequestDetails!.rideRequestId!)
          .child("driverLocation")
          .set(driverLatLngDataMap);
    });
  }

  updateDurationTimeAtRealTime() async {
    if (isRequestDirectionDetails == false) {
      isRequestDirectionDetails = true;

      if (onlineDriverCurrentPosition == null) {
        return;
      }

      var originLatLng = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude,
      ); //Driver current Location

      LatLng? destinationLatLng;

      if (rideRequestStatus == "accepted") {
        destinationLatLng =
            widget.userRideRequestDetails!.originLatLng; //user PickUp Location
      } else //arrived
      {
        destinationLatLng = widget
            .userRideRequestDetails!.destinationLatLng; //user DropOff Location
      }

      var directionInformation =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
              originLatLng, destinationLatLng!);

      if (directionInformation != null) {
        setState(() {
          durationFromOriginToDestination = directionInformation.duration_text!;
        });
      }

      isRequestDirectionDetails = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    createDriverIconMarker();

    phone = widget.userRideRequestDetails!.userPhone!;

    return Scaffold(
      body: Stack(
        children: [
          //google map
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _kGooglePlex,
            markers: setOfMarkers,
            circles: setOfCircle,
            polylines: setOfPolyline,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;

              setState(() {
                mapPadding = 260;
              });

              var driverCurrentLatLng = LatLng(driverCurrentPosition!.latitude,
                  driverCurrentPosition!.longitude);

              var userPickUpLatLng =
                  widget.userRideRequestDetails!.originLatLng;

              drawPolyLineFromOriginToDestination(
                  driverCurrentLatLng, userPickUpLatLng!);

              getDriversLocationUpdatesAtRealTime();
            },
          ),

          //ui
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.35,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    Text(
                      durationFromOriginToDestination,
                      style: const TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Brand-Regular",
                          color: Colors.indigo),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.userRideRequestDetails!.userName!,
                          style: const TextStyle(
                              fontFamily: "Brand-Regular", fontSize: 22.0),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 243, 245, 247),
                                  borderRadius: BorderRadius.circular(30)),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                radius: 25.0,
                                child: IconButton(
                                  icon: const Icon(Ionicons.call),
                                  color: Colors.green,
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            const Text(
                              "Call rider",
                              style: TextStyle(
                                  fontSize: 12, fontFamily: "Brand-Regular"),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "images/origin.png",
                          height: 16.0,
                          width: 16.0,
                        ),
                        const SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: const TextStyle(
                                fontSize: 16.0, fontFamily: "Brand-Regular"),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "images/destination.png",
                          height: 16.0,
                          width: 16.0,
                        ),
                        const SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: const TextStyle(
                                fontSize: 16.0, fontFamily: "Brand-Regular"),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Divider(
                          height: 10,
                          thickness: 0.2,
                          color: Colors.black,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          //[driver has arrived at user PickUp Location] - Arrived Button
                          if (rideRequestStatus == "accepted") {
                            rideRequestStatus = "arrived";

                            FirebaseDatabase.instance
                                .ref()
                                .child("Ride Request")
                                .child(widget
                                    .userRideRequestDetails!.rideRequestId!)
                                .child("status")
                                .set(rideRequestStatus);

                            setState(() {
                              buttonTitle = "Let's Go"; //start the trip
                              buttonColor = Colors.lightGreen;
                            });

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext c) => ProgressDialog(
                                message: "Loading...",
                              ),
                            );

                            await drawPolyLineFromOriginToDestination(
                                widget.userRideRequestDetails!.originLatLng!,
                                widget.userRideRequestDetails!
                                    .destinationLatLng!);

                            Navigator.pop(context);
                          }
                          //[user has already sit in driver's car. Driver start trip now] - Lets Go Button
                          else if (rideRequestStatus == "arrived") {
                            rideRequestStatus = "onride";

                            FirebaseDatabase.instance
                                .ref()
                                .child("Ride Request")
                                .child(widget
                                    .userRideRequestDetails!.rideRequestId!)
                                .child("status")
                                .set(rideRequestStatus);

                            setState(() {
                              buttonTitle = "End Trip"; //end the trip
                              buttonColor = Colors.redAccent;
                            });
                          }
                          //[user/Driver reached to the dropOff Destination Location] - End Trip Button
                          else if (rideRequestStatus == "onride") {
                            endTripNow();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                        ),
                        icon: const Icon(
                          Icons.directions_car,
                          color: Colors.white,
                          size: 25,
                        ),
                        label: Text(
                          buttonTitle!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Brand-Regular",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  listener() {
    FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .child("status")
        .onValue
        .listen((event) {
      if (event.snapshot.value == "cancelled") {
        streamSubscriptionDriverLivePosition!.cancel();
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(fAuth.currentUser!.uid)
            .child("newRide")
            .set("idle");
        Geofire.removeLocation(fAuth.currentUser!.uid);
        Phoenix.rebirth(context);
      }
    });
  }

  endTripNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    Map endingTripLocationMap = {
      "latitude": driverCurrentPosition!.latitude.toString(),
      "longitude": driverCurrentPosition!.longitude.toString(),
    };
    DatabaseReference endTripLocationRef = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(widget.userRideRequestDetails!.rideRequestId!);
    endTripLocationRef.child("trip_end_location").set(endingTripLocationMap);



    //get the tripDirectionDetails = distance travelled
    var currentDriverPositionLatLng = LatLng(
      onlineDriverCurrentPosition!.latitude,
      onlineDriverCurrentPosition!.longitude,
    );

    var tripDirectionDetails =
        await AssistantMethods.obtainOriginToEndTripDirectionDetails(
            currentDriverPositionLatLng,
            widget.userRideRequestDetails!.originLatLng!);


    if (hasDiscount = true) {


      //fare amount with discount
      int totalFareAmount =
          AssistantMethods.calculateFareAmountFromOriginToDestinationDiscount(
              tripDirectionDetails!, discountP!);


      FirebaseDatabase.instance
          .ref()
          .child("Ride Request")
          .child(widget.userRideRequestDetails!.rideRequestId!)
          .child("fareAmount")
          .set(totalFareAmount.toString());

      FirebaseDatabase.instance
          .ref()
          .child("Ride Request")
          .child(widget.userRideRequestDetails!.rideRequestId!)
          .child("status")
          .set("ended");

      streamSubscriptionDriverLivePosition!.cancel();

      Navigator.pop(context);

      DatabaseReference paymentRef = FirebaseDatabase.instance
          .ref()
          .child("Ride Request")
          .child(widget.userRideRequestDetails!.rideRequestId!);
      paymentRef.child("payment_method").once().then((snap) {
        if (snap.snapshot.value != null) {
          setState(() {
            paymentMethod = snap.snapshot.value.toString();
          });
        }
      });

      if (paymentMethod == "Card") {
      } else {
        var response = await showDialog(
          context: context,
          builder: (BuildContext c) => FareAmountCollectionDialog(
            totalFareAmount: totalFareAmount.toDouble(),
          ),
        );

        if (response == "fareCollected") {
          FirebaseDatabase.instance
              .ref()
              .child("drivers")
              .child(fAuth.currentUser!.uid)
              .child("newRide")
              .set("idle");
          Phoenix.rebirth(context);
        }
      }

      //save fare amount to driver total earnings
      saveFareAmountToDriverTotalEarnings(totalFareAmount.toDouble());
      saveFareAmountToDriverWeeklyEarnings(totalFareAmount.toDouble());
    }
    else {
      //fare amount without discount
      int totalFareAmount =
          AssistantMethods.calculateFareAmountFromOriginToDestination(
              tripDirectionDetails!);

      FirebaseDatabase.instance
          .ref()
          .child("Ride Request")
          .child(widget.userRideRequestDetails!.rideRequestId!)
          .child("fareAmount")
          .set(totalFareAmount.toString());

      FirebaseDatabase.instance
          .ref()
          .child("Ride Request")
          .child(widget.userRideRequestDetails!.rideRequestId!)
          .child("status")
          .set("ended");

      streamSubscriptionDriverLivePosition!.cancel();

      Navigator.pop(context);

      DatabaseReference paymentRef = FirebaseDatabase.instance
          .ref()
          .child("Ride Request")
          .child(widget.userRideRequestDetails!.rideRequestId!);
      paymentRef.child("payment_method").once().then((snap) {
        if (snap.snapshot.value != null) {
          setState(() {
            paymentMethod = snap.snapshot.value.toString();
          });
        }
      });

      if (paymentMethod == "Card") {
      } else {
        var response = await showDialog(
          context: context,
          builder: (BuildContext c) => FareAmountCollectionDialog(
            totalFareAmount: totalFareAmount.toDouble(),
          ),
        );

        if (response == "fareCollected") {
          FirebaseDatabase.instance
              .ref()
              .child("drivers")
              .child(fAuth.currentUser!.uid)
              .child("newRide")
              .set("idle");
          Phoenix.rebirth(context);
        }
      }

      //save fare amount to driver total earnings
      saveFareAmountToDriverTotalEarnings(totalFareAmount.toDouble());
      saveFareAmountToDriverWeeklyEarnings(totalFareAmount.toDouble());
    }
    Navigator.pop(context);
  }

  saveFareAmountToDriverTotalEarnings(double totalFareAmount) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) //earnings sub Child exists
      {
        //12
        double oldEarnings = double.parse(snap.snapshot.value.toString());
        double driverTotalEarnings = totalFareAmount + oldEarnings;

        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("earnings")
            .set(driverTotalEarnings.toString());
      } else //earnings sub Child do not exists
      {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("earnings")
            .set(totalFareAmount.toString());
      }
    });
  }

  saveFareAmountToDriverWeeklyEarnings(double totalFareAmount) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("weekly_earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) //earnings sub Child exists
      {
        //12
        double oldEarnings = double.parse(snap.snapshot.value.toString());
        double driverTotalEarnings = totalFareAmount + oldEarnings;

        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("weekly_earnings")
            .set(driverTotalEarnings.toString());
      } else //earnings sub Child do not exists
      {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("weekly_earnings")
            .set(totalFareAmount.toString());
      }
    });
  }

  saveAssignedDriverDetailsToUserRideRequest() {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(widget.userRideRequestDetails!.rideRequestId!);

    Map driverLocationDataMap = {
      "latitude": driverCurrentPosition!.latitude.toString(),
      "longitude": driverCurrentPosition!.longitude.toString(),
    };
    databaseReference.child("driverLocation").set(driverLocationDataMap);

    databaseReference.child("status").set("accepted");
    databaseReference.child("driverId").set(onlineDriverData.id);
    databaseReference.child("driverName").set(onlineDriverData.name);
    databaseReference.child("driverPhone").set(onlineDriverData.phone);
    databaseReference.child("driverPhoto").set(onlineDriverData.photoUrl);
    databaseReference
        .child("car_color")
        .set(onlineDriverData.car_color.toString());
    databaseReference
        .child("car_model")
        .set(onlineDriverData.car_model.toString());
    databaseReference
        .child("car_number")
        .set(onlineDriverData.car_number.toString());

    saveRideRequestIdToDriverHistory();
  }

  saveRideRequestIdToDriverHistory() {
    DatabaseReference tripsHistoryRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("tripsHistory");

    tripsHistoryRef
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .set(true);
  }
}
