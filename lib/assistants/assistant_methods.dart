import 'package:boride_driver/assistants/request_assistant.dart';
import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/global/map_key.dart';
import 'package:boride_driver/infoHandler/app_info.dart';
import 'package:boride_driver/models/bank_model.dart';
import 'package:boride_driver/models/direction_details_info.dart';
import 'package:boride_driver/models/directions.dart';
import 'package:boride_driver/models/trip_history_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoOrdinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng origionPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origionPosition.latitude},${origionPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "Error Occurred, Failed. No Response.") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static Future<DirectionDetailsInfo?> obtainOriginToEndTripDirectionDetails(
      LatLng origionPosition, LatLng destinationPosition) async {
    String urlOriginToEndTripDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origionPosition.latitude},${origionPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlOriginToEndTripDirectionDetails);

    if (responseDirectionApi == "Error Occurred, Failed. No Response.") {
      return null;
    }

    DirectionDetailsInfo endTripDirectionDetailsInfo = DirectionDetailsInfo();
    endTripDirectionDetailsInfo.e_points =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    endTripDirectionDetailsInfo.distance_text =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    endTripDirectionDetailsInfo.distance_value =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    endTripDirectionDetailsInfo.duration_text =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    endTripDirectionDetailsInfo.duration_value =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return endTripDirectionDetailsInfo;
  }

  static pauseLiveLocationUpdates() {
    streamSubscriptionPosition!.pause();
    streamSubscriptionPosition!.cancel();
    Geofire.removeLocation(fAuth.currentUser!.uid);
  }

  static resumeLiveLocationUpdates() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
  }

  //retrieve the trips KEYS for online user
  //trip key = ride request key
  static void readTripsKeysForOnlineDriver(context) {
    FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .orderByChild("driverId")
        .equalTo(fAuth.currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        Map keysTripsId = snap.snapshot.value as Map;

        //count total number trips and share it with Provider
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsCounter(overAllTripsCounter);

        //share trips keys with Provider
        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value) {
          tripsKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsKeys(tripsKeysList);

        //get trips keys data - read trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context) {
    var tripsAllKeys =
        Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for (String eachKey in tripsAllKeys) {
      FirebaseDatabase.instance
          .ref()
          .child("Ride Request")
          .child(eachKey)
          .once()
          .then((snaps) {
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snaps.snapshot);

        if ((snaps.snapshot.value as Map)["status"] == "ended") {
          //update-add each history to OverAllTrips History Data List
          Provider.of<AppInfo>(context, listen: false)
              .updateOverAllTripsHistoryInformation(eachTripHistory);
        }
      });
    }
  }

  //readDriverEarnings
  static void readDriverTotalEarnings(context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String driverEarnings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false)
            .updateDriverTotalEarnings(driverEarnings);
      }
    });
  }

  static void readDriverWeeklyEarnings(context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("weekly_earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String driverWeeklyEarnings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false)
            .updateDriverWeeklyEarnings(driverWeeklyEarnings);
      }
    });
  }

  static void readDriverRating(context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("ratings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String driverRating = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false)
            .updateDriverAverageRatings(driverRating);
      }
    });
  }

  static void getBankData(context) {
    DatabaseReference bankingRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("bank_details");
    bankingRef.once().then((snapshot) {
      if (snapshot.snapshot.value != null) {
        bankInfoModel = BankInfoModel.fromSnapshot(snapshot.snapshot);
      }
    });
  }

  static calculateFareAmountFromOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo) {
    // per km = ₦70,
    // per min = ₦10
    // base fare = ₦250

    double baseFare = 250;
    double distanceFare = (directionDetailsInfo.distance_value! / 1000) * 70;
    double timeFare = (directionDetailsInfo.duration_value! / 60) * 10;

    double totalFare = baseFare + distanceFare + timeFare;

    if (driverVehicleType == "boride-go") {
      if (totalFare <= 400) {
        totalFare = 500;
        return (((totalFare - 1) ~/ 100) * 100).toInt();
      }
    } else if (driverVehicleType == "boride-corporate") {
      totalFare = totalFare + 300;
      return (((totalFare - 0) ~/ 100) * 100).toInt();
    } else {
      return totalFare.truncate();
    }
  }

  static calculateFareAmountFromOriginToDestinationDiscount(
      DirectionDetailsInfo directionDetailsInfo, int discountP) {
    // per km = ₦70,
    // per min = ₦10
    // base fare = ₦250

    double baseFare = 250;
    double distanceFare = (directionDetailsInfo.distance_value! / 1000) * 70;
    double timeFare = (directionDetailsInfo.duration_value! / 60) * 10;

    double totalFare = baseFare + distanceFare + timeFare;

    if (driverVehicleType == "boride-go") {
      var dTotalFare;
      dTotalFare = totalFare - ((discountP / 100) * totalFare);
      return (((dTotalFare - 0) ~/ 100) * 100).toInt();
    } else if (driverVehicleType == "boride-corporate") {
      var nTotalFare = totalFare + 300;
      var dTotalFare = nTotalFare - ((discountP / 100) * totalFare);
      return (((dTotalFare - 0) ~/ 100) * 100).toInt();
    } else {
      return totalFare.truncate();
    }
  }
}
