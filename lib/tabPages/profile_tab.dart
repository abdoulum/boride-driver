import 'package:boride_driver/authentication/driver_registation.dart';
import 'package:boride_driver/authentication/login_screen.dart';
import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/mainScreens/bank_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {

  DatabaseReference ratingsRef = FirebaseDatabase.instance.ref().child('drivers').child(fAuth.currentUser!.uid).child("ratings");
  String ratings = "";

  @override
  Widget build(BuildContext context) {

    ratingsRef.once().then((snapshot)  {
      if(snapshot.snapshot.value !=null) {
        setState(() {
          ratings = snapshot.snapshot.value.toString();
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Profile",
            style: TextStyle(
                color: Colors.black, fontFamily: "Brand-Regular", fontSize: 25),
          ),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(children: [
          Column(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Stack(
                        children:  const [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'images/download.jpg',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(children: [
                    Text(onlineDriverData.name ?? "Getting name...",
                        style: const TextStyle(
                            fontSize: 24,
                            fontFamily: "Brand-Bold",
                            fontWeight: FontWeight.bold)),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(onlineDriverData.email ?? "Getting info...",
                          style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Brand-Regular",
                              fontWeight: FontWeight.w400)),
                    ),
                  ]),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade900,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ratings,
                                    style: const TextStyle(
                                      fontFamily: "Brand-Regular",
                                      fontSize: 25,
                                      // fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Ratings",
                            style: TextStyle(fontFamily: "Brand-Regular"),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02,
                      ),
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 130,
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade900,
                                borderRadius: BorderRadius.circular(50)),
                            child: const Center(
                                child: Text(
                                  "Oct, 22",
                                  style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontSize: 25,
                                    // fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Date Joined",
                            style: TextStyle(fontFamily: "Brand-Regular"),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02,
                      ),
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade900,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                Provider
                                    .of<AppInfo>(context, listen: false)
                                    .allTripsHistoryInformationList
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontSize: 25,
                                  // fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Trips",
                            style: TextStyle(fontFamily: "Brand-Regular"),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02,
                  ),
                  Container(

                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.indigo.shade900,
                        borderRadius: BorderRadius.circular(20)),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.15,
                    width: 370,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "Vehicle Model:    ${onlineDriverData.car_model ??
                                  "getting ...."}",
                              style: const TextStyle(color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Brand-Regular"),
                            )),
                        Container(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "Vehicle Color:   ${onlineDriverData.car_color ??
                                  "getting ...."}",
                              style: const TextStyle(color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Brand-Regular"),
                            )),
                        Container(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "Vehicle Number:   ${onlineDriverData
                                  .car_number ?? "getting ...."} ",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16, fontFamily: "Brand-Regular"
                              ),
                            )),

                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02,
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.07,),

                  Container(
                    width: 370,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(100, 225, 226, 233),
                        borderRadius: BorderRadius.circular(20)),
                    height: 300,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BankInfo()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.credit_card),
                                SizedBox(width: 40),
                                Expanded(
                                  child: Text(
                                    'Add bank details',
                                    style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_outlined)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.help_outline),
                              SizedBox(width: 40),
                              Expanded(
                                child: Text(
                                  'Help & Support',
                                  style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              Icon(Icons.arrow_forward_ios_outlined)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.person_add),
                              SizedBox(width: 40),
                              Expanded(
                                child: Text(
                                  'Invite Friends',
                                  style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              Icon(Icons.arrow_forward_ios_outlined)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.logout),
                                SizedBox(width: 40),
                                Expanded(
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.01,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
