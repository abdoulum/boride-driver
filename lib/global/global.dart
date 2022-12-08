import 'dart:async';

import 'package:boride_driver/models/bank_model.dart';
import 'package:boride_driver/models/driver_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
BankInfoModel? bankInfoModel;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
Position? driverCurrentPosition;
DriverData onlineDriverData = DriverData();
String? driverVehicleType = "";
String titleStarsRating = "";
bool isDriverActive = false;
String statusText = "Now Offline";
Color buttonColor = Colors.grey;
