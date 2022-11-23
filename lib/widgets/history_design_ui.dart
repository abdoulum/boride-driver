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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 225, 226, 233),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //driver name + Fare Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rider:  " + widget.tripsHistoryModel!.userName!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "Brand-Regular",
                    fontWeight: FontWeight.bold,
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

            // phone details
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Icon(
                  Ionicons.pin,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(widget.tripsHistoryModel!.originAddress!.length > 32 ?
                    widget.tripsHistoryModel!.originAddress!.substring(0, 32) : widget.tripsHistoryModel!.originAddress!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "Brand-Regular",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),

            Row(
              children: [
                const Icon(
                  Ionicons.location,
                  color: Colors.indigo,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.tripsHistoryModel!.destinationAddress!.length > 32 ?
                    widget.tripsHistoryModel!.destinationAddress!.substring(0, 32) : widget.tripsHistoryModel!.destinationAddress!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 14,
                    ),
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