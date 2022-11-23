import 'package:boride_driver/global/global.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TestUi extends StatelessWidget {
  const TestUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Stack(children: [
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 16.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            height:MediaQuery.of(context).size.height * 0.35,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  const Text(
                    "27 mins",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Brand-Regular",
                        color: Colors.indigo),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Abdullahi Umar ",
                        style: TextStyle(
                            fontFamily: "Brand-Regular", fontSize: 22.0),
                      ),

                      const Spacer(),

                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                color:
                                const Color.fromARGB(255, 243, 245, 247),
                                borderRadius: BorderRadius.circular(30)),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              radius: 25.0,
                              child: IconButton(
                                icon: const Icon(Ionicons.call),
                                color: Colors.green,
                                onPressed: () {
                                },
                              ),
                            ),
                          ),
                          const Text(
                            "Call rider",
                            style: TextStyle(
                                fontSize: 12, fontFamily: "Brand-Regular"),
                          )
                        ],
                      ),

                    ],
                  ),

                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/origin.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      const Expanded(
                        child: Text(
                          'No 2, D Isheni street',
                          style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Regular"),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/destination.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      const Expanded(
                        child: Text(
                          "No 2 Kufena road, u/rimi",
                          style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Regular"),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Divider(
                        height: 10,
                        thickness: 0.2,
                        color: Colors.black,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton.icon(
                      // onPressed: () async {
                      //   //[driver has arrived at user PickUp Location] - Arrived Button
                      //   if (rideRequestStatus == "accepted") {
                      //     rideRequestStatus = "arrived";
                      //
                      //     FirebaseDatabase.instance
                      //         .ref()
                      //         .child("Ride Request")
                      //         .child(widget
                      //         .userRideRequestDetails!.rideRequestId!)
                      //         .child("status")
                      //         .set(rideRequestStatus);
                      //
                      //     setState(() {
                      //       buttonTitle = "Let's Go"; //start the trip
                      //       buttonColor = Colors.lightGreen;
                      //     });
                      //
                      //     showDialog(
                      //       context: context,
                      //       barrierDismissible: false,
                      //       builder: (BuildContext c) => ProgressDialog(
                      //         message: "Loading...",
                      //       ),
                      //     );
                      //
                      //     await drawPolyLineFromOriginToDestination(
                      //         widget.userRideRequestDetails!.originLatLng!,
                      //         widget.userRideRequestDetails!
                      //             .destinationLatLng!);
                      //
                      //     Navigator.pop(context);
                      //   }
                      //   //[user has already sit in driver's car. Driver start trip now] - Lets Go Button
                      //   else if (rideRequestStatus == "arrived") {
                      //     rideRequestStatus = "onride";
                      //
                      //     FirebaseDatabase.instance
                      //         .ref()
                      //         .child("Ride Request")
                      //         .child(widget
                      //         .userRideRequestDetails!.rideRequestId!)
                      //         .child("status")
                      //         .set(rideRequestStatus);
                      //
                      //     setState(() {
                      //       buttonTitle = "End Trip"; //end the trip
                      //       buttonColor = Colors.redAccent;
                      //     });
                      //   }
                      //   //[user/Driver reached to the dropOff Destination Location] - End Trip Button
                      //   else if (rideRequestStatus == "onride") {
                      //     endTripNow();
                      //   }
                      // },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                      ),
                      icon: const Icon(
                        Icons.directions_car,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: const Text(
                        "buttonTitle",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Brand-Regular",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
