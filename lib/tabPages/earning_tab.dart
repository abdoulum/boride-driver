// ignore_for_file: unused_element

import 'package:boride_driver/infoHandler/app_info.dart';
import 'package:boride_driver/mainScreens/trips_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({Key? key}) : super(key: key);

  @override
  _EarningsTabPageState createState() => _EarningsTabPageState();
}

class _EarningsTabPageState extends State<EarningsTabPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double wEarnings = double.parse(Provider.of<AppInfo>(context, listen: true)
        .driverWeeklyEarnings
        .toString());

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Earnings",
            style: TextStyle(color: Colors.black, fontFamily: "Brand-Regular"),
          ),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    color: Colors.white,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Week earnings: ",
                            style: TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\$ " + wEarnings.toStringAsFixed(0),
                            style: const TextStyle(
                              fontFamily: "Brand-Bold",
                              color: Colors.black87,
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  //total number of trips
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(15)),
                    width: MediaQuery.of(context).size.width * 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const TripsHistoryScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 225, 226, 233),
                          shadowColor: Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "Trip History",
                              style: TextStyle(
                                fontFamily: "Brand-Bold",
                                fontSize: 25,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Image.asset(
                              "images/car_logo.png",
                              width: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
