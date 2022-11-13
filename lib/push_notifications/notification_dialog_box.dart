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
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10.0),
            Image.asset("images/car_logo.png", width: 150.0,),
            const SizedBox(height: 0.0,),
            const Text("New Ride Request", style: TextStyle(fontFamily: "Brand Bold", fontSize: 20.0,),),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/origin.png", height: 16.0, width: 16.0,),
                      const SizedBox(width: 20.0,),
                      Expanded(
                        child: Text(widget.userRideRequestDetails!.originAddress!, style: const TextStyle(fontSize: 18.0),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/destination.png", height: 16.0, width: 16.0,),
                      const SizedBox(width: 20.0,),
                      Expanded(
                          child: Text(widget.userRideRequestDetails!.destinationAddress!, style: const TextStyle(fontSize: 18.0),)
                      ),
                    ],
                  ),
                  const SizedBox(height: 0.0),

                ],
              ),
            ),

            const SizedBox(height: 15.0),
            const Divider(height: 2.0, thickness: 4.0,),
            const SizedBox(height: 0.0),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  TextButton(

                    onPressed: ()
                    {

                      Navigator.pop(context);

                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                  const SizedBox(width: 25.0),

                  ElevatedButton(

                    onPressed: ()
                    {
                      acceptRideRequest(context);
                    },
                    child: Text("Accept".toUpperCase(),
                        style: const TextStyle(fontSize: 14)),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 0.0),
          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context) {
    String getRideRequestId = "";
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRide")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        getRideRequestId = snap.snapshot.value.toString();
      } else {
        Fluttertoast.showToast(msg: "Ride does not exit anymore");
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
      }
      else if(getRideRequestId == "cancelled")
      {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Ride has been Cancelled.");
      }
      else if(getRideRequestId == "timeout")
      {
        Fluttertoast.showToast(msg: "Ride has time out.");
      }else {
        Fluttertoast.showToast(msg: "Ride does not exit anymore");
      }
    });
  }
}
