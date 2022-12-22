import 'package:boride_driver/models/trip_history_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TripHistoryDisplay extends StatefulWidget {
  int? index;
  TripsHistoryModel? tripsHistoryModel;

  TripHistoryDisplay({
    Key? key,
    this.tripsHistoryModel,
    this.index,
  }) : super(key: key);

  @override
  State<TripHistoryDisplay> createState() => _TripHistoryDisplayState();
}

class _TripHistoryDisplayState extends State<TripHistoryDisplay> {
  String name = "";
  String phone = "";
  String price = "";

  Color color = const Color.fromARGB(50, 200, 200, 200);

  @override
  Widget build(BuildContext context) {
    // id = Provider.of<AppInfo>(context).driverList[widget.index!].id.toString();
    name = widget.tripsHistoryModel!.userName.toString();
    phone = widget.tripsHistoryModel!.userPhone.toString();
    price = widget.tripsHistoryModel!.fareAmount.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Trip Information",
            style: TextStyle(
                fontSize: 20,
                fontFamily: "Brand-Regular",
                color: Colors.black)),
        elevation: 0.5,
        leading: const Icon(
          CupertinoIcons.chevron_back,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Status:  ${"completed"}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Brand-Regular"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text("Name:  $name",
                            style: const TextStyle(
                                fontSize: 16, fontFamily: "Brand-Regular")),
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text("Phone:  $phone",
                            style: const TextStyle(
                                fontSize: 16, fontFamily: "Brand-Regular")),
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text("Fare amount:  $price",
                            style: const TextStyle(
                                fontSize: 16, fontFamily: "Brand-Regular")),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Ionicons.pin,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              widget.tripsHistoryModel!.originAddress!.length >
                                      32
                                  ? widget.tripsHistoryModel!.originAddress!
                                      .substring(0, 32)
                                  : widget.tripsHistoryModel!.originAddress!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
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
                          const Icon(
                            Ionicons.location,
                            color: Colors.indigo,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              widget.tripsHistoryModel!.destinationAddress!
                                          .length >
                                      28
                                  ? widget
                                      .tripsHistoryModel!.destinationAddress!
                                      .substring(0, 28)
                                  : widget
                                      .tripsHistoryModel!.destinationAddress!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(25),
                    child: Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.7,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.red.shade500,
                borderRadius: BorderRadius.circular(30)),
            child: const Center(
              child: Text("Report Rider",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Brand-Bold")),
            ),
          ),
        ],
      ),
    );
  }
}
