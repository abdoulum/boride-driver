import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';
import '../widgets/history_design_ui.dart';

class TripsHistoryScreen extends StatefulWidget {
  const TripsHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}

class _TripsHistoryScreenState extends State<TripsHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    double tEarnings = double.parse(Provider.of<AppInfo>(context, listen: true)
        .driverTotalEarnings
        .toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text(
          "Trips History",
          style: TextStyle(color: Colors.black, fontFamily: 'Brand-Regular'),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              color: Colors.white,
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.only(top: 10),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      "Total earnings: ",
                      style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$ ${tEarnings.toStringAsFixed(0)}",
                      style: const TextStyle(
                          fontFamily: "Brand-Bold", fontSize: 40),
                    ),
                  ],
                ),
              ),
            ),
            ListView.separated(
              separatorBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: const Divider(
                  thickness: 0.2,
                  height: 1,
                  color: Colors.black,
                ),
              ),
              itemBuilder: (context, i) {
                return Card(
                  color: Colors.white54,
                  child: HistoryDesignUIWidget(
                    tripsHistoryModel:
                        Provider.of<AppInfo>(context, listen: false)
                            .allTripsHistoryInformationList[i],
                  ),
                );
              },
              itemCount: Provider.of<AppInfo>(context, listen: false)
                  .allTripsHistoryInformationList
                  .length,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
