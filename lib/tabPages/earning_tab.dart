import 'package:boride_driver/assistants/assistant_methods.dart';
import 'package:boride_driver/brand_colors.dart';
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
  void initState()
  {
    super.initState();
    AssistantMethods.readDriverEarnings(context);


  }



  @override
  Widget build(BuildContext context) {

    double tEarnings = double.parse(Provider.of<AppInfo>(context, listen: true).driverTotalEarnings.toString());

    return Container(
      color: Colors.white,
      child: Column(
        children: [

          //earnings
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 75),
              child: Column(
                children: [

                  const Text(
                    "Your Earnings :",
                    style: TextStyle(
                      fontFamily: "Brand-Regular",
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 8,),

                  Text(
                    "\$ " + tEarnings.toStringAsFixed(0),
                    style: const TextStyle(
                      fontFamily: "Brand-Bold",
                      color: Colors.grey,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),

          //total number of trips
          ElevatedButton(
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const TripsHistoryScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandColors.colorAccent2
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  children: [

                    Image.asset(
                      "images/car_logo.png",
                      width: 100,
                    ),

                    const SizedBox(
                      width: 6,
                    ),

                    const Text(
                      "Trips Completed",
                      style: TextStyle(
                        fontFamily: "Brand-Regular",
                        color: Colors.black54,
                      ),
                    ),

                    Expanded(
                      child: Text(
                        Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.toSet().toList().length.toString(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontFamily: "Brand-Bold",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),


                  ],
                ),
              ),
          ),

        ],
      ),
    );
  }

}
