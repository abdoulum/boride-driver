import 'package:boride_driver/brand_colors.dart';
import 'package:boride_driver/models/trip_history_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class HistoryDesignUIWidget extends StatefulWidget {

  TripsHistoryModel? tripsHistoryModel;

  HistoryDesignUIWidget({Key? key, this.tripsHistoryModel}) : super(key: key);

  @override
  State<HistoryDesignUIWidget> createState() => _HistoryDesignUIWidgetState();
}

class _HistoryDesignUIWidgetState extends State<HistoryDesignUIWidget> {
  String formatDateAndTime(String dateTimeFromDB) {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);

    // Dec 10                            //2022                         //1:12 pm
    String formattedDatetime =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDatetime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //driver name + Fare Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    "Rider:  " + widget.tripsHistoryModel!.userName!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "Brand-Regular",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "\$ " + widget.tripsHistoryModel!.fareAmount!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: "Brand-Regular",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),

            // phone details
            Row(
              children: [
                const Icon(
                  Ionicons.phone_portrait_outline,
                  color: Colors.black,
                  size: 28,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  widget.tripsHistoryModel!.userPhone!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: "Brand-Regular",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),


            Row(
              children: [
                const Icon(Ionicons.pin_outline,
                  color: Colors.red,),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    widget.tripsHistoryModel!.originAddress!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Brand-Regular",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            Row(
              children: [
                 Icon(
                  Ionicons.location,
                  color: Colors.greenAccent.shade700,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    widget.tripsHistoryModel!.destinationAddress!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            //trip time and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(""),
                Text(
                  widget.tripsHistoryModel!.time!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: "Brand-Regular",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
