import 'package:boride_driver/assistants/assistant_methods.dart';
import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/mainScreens/new_trip_screen.dart';
import 'package:boride_driver/models/user_ride_request_information.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationDialogBox extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({Key? key, this.userRideRequestDetails})
      : super(key: key);

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white70,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 14,
            ),

            Image.asset(
              "images/car_logo.png",
              width: 100,
            ),

            const SizedBox(
              height: 10,
            ),

            //title
            const Text(
              "New Ride Request",
              style: TextStyle(
                  fontFamily: "Brand-Regular",
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black),
            ),

            const SizedBox(height: 10.0),

            const Divider(
              height: 2,
              thickness: 0.2,
              color: Colors.black,
            ),

            //addresses origin destination
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //origin location with icon
                  Row(
                    children: [
                      Image.asset(
                        "images/origin.png",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails!.originAddress!,
                          style: const TextStyle(
                            fontFamily: "Brand-Regular",
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),

                  //destination location with icon
                  Row(
                    children: [
                      Image.asset(
                        "images/destination.png",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails!.destinationAddress!,
                          style: const TextStyle(
                            fontFamily: "Brand-Regular",
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(
              height: 2,
              thickness: 0.2,
              color: Colors.black,
            ),

            //buttons cancel accept
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      FirebaseDatabase.instance
                          .ref()
                          .child("drivers")
                          .child(fAuth.currentUser!.uid)
                          .child("newRide")
                          .set("cancelled");
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 25.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      //accept the rideRequest
                      acceptRideRequest(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context) {
    Navigator.pop(context);
    String getRideRequestId = "";
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRide")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        setState(() {
          getRideRequestId = snap.snapshot.value.toString();
        });
      } else {
        Fluttertoast.showToast(msg: "Ride not available");
      }

      if (getRideRequestId == widget.userRideRequestDetails!.rideRequestId) {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("newRide")
            .set("accepted");

        AssistantMethods.pauseLiveLocationUpdates();

        //trip started now - send driver to new tripScreen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => NewTripScreen(
                      userRideRequestDetails: widget.userRideRequestDetails,
                    )));
      } else if (getRideRequestId == "cancelled") {
        Fluttertoast.showToast(msg: "Ride not available");
      } else if (getRideRequestId == "timeout") {
        Fluttertoast.showToast(msg: "Ride not available");
      } else {
        Fluttertoast.showToast(msg: "Ride not available");
      }
    });
  }
}
