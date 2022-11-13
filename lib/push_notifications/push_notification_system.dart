import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/models/user_ride_request_information.dart';
import 'package:boride_driver/push_notifications/notification_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initialize(BuildContext context) async {

    //1. Terminated
    //When the app is completely closed and opened directly from the push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //display ride request information - user information who request a ride
        readUserRideRequestInformation(
            remoteMessage.data["rideRequestId"], context);
      }
    });

    //2. Foreground
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      //display ride request information - user information who request a ride
      readUserRideRequestInformation(
          remoteMessage!.data["rideRequestId"], context);
    });

    //3. Background
    //When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      //display ride request information - user information who request a ride
      readUserRideRequestInformation(
          remoteMessage!.data["rideRequestId"], context);
    });
  }

  readUserRideRequestInformation(
      String userRideRequestId, BuildContext context) {

    FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(userRideRequestId)
        .once()
        .then((snapData) {
      if (snapData.snapshot.value != null) {
        double originLat = double.parse(
            (snapData.snapshot.value! as Map)["pickup"]["latitude"]);
        double originLng = double.parse(
            (snapData.snapshot.value! as Map)["pickup"]["longitude"]);
        String originAddress =
            (snapData.snapshot.value! as Map)["pickup_address"];

        double destinationLat = double.parse(
            (snapData.snapshot.value! as Map)["dropoff"]["latitude"]);
        double destinationLng = double.parse(
            (snapData.snapshot.value! as Map)["dropoff"]["longitude"]);
        String destinationAddress =
            (snapData.snapshot.value! as Map)["dropoff_address"];

        String userName = (snapData.snapshot.value! as Map)["rider_name"];
        String userPhone = (snapData.snapshot.value! as Map)["rider_phone"];
        String paymentMethod = (snapData.snapshot.value! as Map)["payment_method"];

        String? rideRequestId = snapData.snapshot.key;

        UserRideRequestInformation userRideRequestDetails =
            UserRideRequestInformation();

        userRideRequestDetails.originLatLng = LatLng(originLat, originLng);
        userRideRequestDetails.originAddress = originAddress;

        userRideRequestDetails.destinationLatLng =
            LatLng(destinationLat, destinationLng);
        userRideRequestDetails.destinationAddress = destinationAddress;

        userRideRequestDetails.userName = userName;
        userRideRequestDetails.userPhone = userPhone;
        userRideRequestDetails.paymentMethod = paymentMethod;

        userRideRequestDetails.rideRequestId = rideRequestId;

        showDialog(
          context: context,
          builder: (BuildContext context) => NotificationDialogBox(
            userRideRequestDetails: userRideRequestDetails,
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "This Ride Request Id do not exists.");
      }
    });
  }

  Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}
