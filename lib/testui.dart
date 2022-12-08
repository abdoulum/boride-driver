import 'package:boride_driver/global/global.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TestUi extends StatelessWidget {
  const TestUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white70,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 14,),

            Image.asset(
              "images/car_logo.png",
              width: 100,
            ),

            const SizedBox(height: 10,),

            //title
            const Text(
              "New Ride Request",
              style: TextStyle(
                fontFamily: "Brand-Regular",
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.grey
              ),
            ),

            const SizedBox(height: 10.0),

            const Divider(
              height: 2,
              thickness: 0.2,
              color: Colors.black,
            ),

            //addresses origin destination
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //origin location with icon
                  Row(
                    children: [
                      Image.asset(
                        "images/origin.png",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 14,),
                      const Expanded(
                        child: Text(
                          "Nile university of nigeria",
                          style: TextStyle(
                            fontFamily: "Brand-Regular",

                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),

                  //destination location with icon
                  Row(
                    children: [
                      Image.asset(
                        "images/destination.png",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 14,),
                      const Expanded(
                        child: Text(

                         "No26,  D Sheni street",
                          style: TextStyle(
                            fontFamily: "Brand-Regular",

                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            const Divider(
              height: 2,
              thickness: 0.2,
              color: Colors.black,
            ),


            //buttons cancel accept
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    // onPressed: ()
                    // {
                    //
                    //   //cancel the rideRequest
                    //   FirebaseDatabase.instance.ref()
                    //       .child("Ride Request")
                    //       .child(widget.userRideRequestDetails!.rideRequestId!)
                    //       .remove().then((value)
                    //   {
                    //     FirebaseDatabase.instance.ref()
                    //         .child("drivers")
                    //         .child(currentFirebaseUser!.uid)
                    //         .child("newRide")
                    //         .set("idle");
                    //   }).then((value)
                    //   {
                    //     FirebaseDatabase.instance.ref()
                    //         .child("drivers")
                    //         .child(currentFirebaseUser!.uid)
                    //         .child("tripsHistory")
                    //         .child(widget.userRideRequestDetails!.rideRequestId!)
                    //         .remove();
                    //   }).then((value)
                    //   {
                    //     Fluttertoast.showToast(msg: "Ride Request has been Cancelled.");
                    //   });
                    //
                    //   Future.delayed(const Duration(milliseconds: 3000), ()
                    //   {
                    //     Navigator.pop(context);
                    //   });
                    // },
                    onPressed: () {  },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontFamily: "Brand-Regular",

                        fontSize: 12.0,
                      ),
                    ),
                  ),

                  const SizedBox(width: 25.0),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: ()
                    {
                      //accept the rideRequest
                      //acceptRideRequest(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
