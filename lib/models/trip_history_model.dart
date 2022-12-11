// ignore_for_file: non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel {
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? userName;
  String? userPhone;

  TripsHistoryModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.userName,
    this.userPhone,
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot) {
    time = (dataSnapshot.value as dynamic)["time"];
    originAddress = (dataSnapshot.value as dynamic)["pickup_address"];
    destinationAddress = (dataSnapshot.value as dynamic)["dropoff_address"];
    status = (dataSnapshot.value as dynamic)["status"];
    fareAmount = (dataSnapshot.value as dynamic)["fareAmount"];
    userName = (dataSnapshot.value as dynamic)["rider_name"];
    userPhone = (dataSnapshot.value as dynamic)["rider_phone"];
  }
}
