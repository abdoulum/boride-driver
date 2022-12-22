// ignore_for_file: unused_element

import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/infoHandler/app_info.dart';
import 'package:boride_driver/mainScreens/trips_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({Key? key}) : super(key: key);

  @override
  _EarningsTabPageState createState() => _EarningsTabPageState();
}

class _EarningsTabPageState extends State<EarningsTabPage> {
  bool isTestMode = true;

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
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handlePaymentInitialization() async {
    showLoading("Loading, please wait ......");

    final Customer customer = Customer(
        name: onlineDriverData.name!,
        phoneNumber: onlineDriverData.phone!,
        email: onlineDriverData.email!);

    final Flutterwave flutterWave = Flutterwave(
        context: context,
        publicKey: getPublicKey(),
        currency: "NGN",
        redirectUrl: 'https://facebook.com',
        txRef: "${const Uuid().v1()}-Txd",
        amount: "8000",
        customer: customer,
        paymentOptions: "card, bank transfer",
        customization: Customization(title: "Test Payment"),
        isTestMode: isTestMode);
    // ignore: unused_local_variable
    final ChargeResponse response = await flutterWave.charge().whenComplete(() {
      Fluttertoast.showToast(msg: "Success///");
      Navigator.pop(context);
    });
  }

  String getPublicKey() {
    if (isTestMode) return "FLWPUBK_TEST-1b50fcec6e04d0b2b0e471d74827197b-X";
    return "FLWPUBK-45587fdb1c84335354ab0fa388b803d5-X";
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}
