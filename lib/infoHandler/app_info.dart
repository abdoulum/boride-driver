import 'package:boride_driver/models/directions.dart';
import 'package:boride_driver/models/trip_history_model.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  String driverTotalEarnings = "0";
  String driverWeeklyEarnings = "0";
  String driverAverageRatings = "0";

  List<String> historyTripsKeysList = [];
  List<TripsHistoryModel>   allTripsHistoryInformationList = [];

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  updateOverAllTripsCounter(int overAllTripsCounter) {
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllTripsKeys(List<String> tripsKeysList) {
    historyTripsKeysList = tripsKeysList;
    notifyListeners();
  }

  updateOverAllTripsHistoryInformation(TripsHistoryModel eachTripHistory) {
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }

  updateDriverTotalEarnings(String driverEarnings) {
    driverTotalEarnings = driverEarnings;
    notifyListeners();
  }

  updateDriverWeeklyEarnings(String driverWeekEarnings) {
    driverWeeklyEarnings = driverWeekEarnings;
    notifyListeners();
  }

  updateDriverAverageRatings(String driverRating) {
    driverAverageRatings = driverRating;
    notifyListeners();
  }
}
