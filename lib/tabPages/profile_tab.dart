import 'dart:async';
import 'dart:io';

import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/mainScreens/bank_info.dart';
import 'package:boride_driver/mainScreens/help_support_screen.dart';
import 'package:boride_driver/widgets/brand_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../infoHandler/app_info.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  DatabaseReference ratingsRef = FirebaseDatabase.instance
      .ref()
      .child('drivers')
      .child(fAuth.currentUser!.uid)
      .child("ratings");

  String name = "";
  String email = "";
  String phone = "";
  String vNumber = "";
  String vColor = "";
  String vModel = "";
  String vBrand = "";
  String profilePic = "";
  String? ratings;

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String? downloadUrl;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('my_name') ?? onlineDriverData.name!;
      email = prefs.getString('my_email') ?? onlineDriverData.email!;
      phone = prefs.getString('my_phone') ?? onlineDriverData.phone!;
      vNumber = prefs.getString('v_number') ?? onlineDriverData.car_number!;
      vBrand = prefs.getString('v_brand') ?? onlineDriverData.car_brand!;
      vColor = prefs.getString('v_color') ?? onlineDriverData.car_color!;
      vModel = prefs.getString('v_model') ?? onlineDriverData.car_model!;
      ratings = onlineDriverData.ratings.toString();
    });
  }

  selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);
    if (result == null) {
      Fluttertoast.showToast(msg: 'No file selected');
    }
    setState(() {
      pickedFile = result!.files.first;
    });
    final file = File(pickedFile!.path!);

    final ppRef = FirebaseStorage.instance
        .ref()
        .child("Drivers")
        .child(fAuth.currentUser!.uid);
    TaskSnapshot uploadTask = await ppRef.child("driver_license").putFile(file);
    downloadUrl = await (uploadTask).ref.getDownloadURL();

    fAuth.currentUser!.updatePhotoURL(downloadUrl).then((value) {
      fAuth.currentUser!.reload();
      Fluttertoast.showToast(msg: "//////");
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    margin: const EdgeInsets.only(bottom: 15, top: 15),
                    child: ClipOval(
                        child: Image.network(
                      fAuth.currentUser!.photoURL!,
                      scale: 18,
                    )),
                  ),
                  Column(children: [
                    Text(onlineDriverData.name!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontFamily: "Brand-regular",
                        )),
                    Text(
                      " ${onlineDriverData.car_color} $vBrand ${onlineDriverData.car_model}, ${onlineDriverData.car_number}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: "Brand-regular",
                          color: BrandColors.colorTextT),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Good Driver",
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Brand-Bold",
                          color: Colors.green),
                    ),
                  ]),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade900,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ratings!,
                                    style: const TextStyle(
                                      fontFamily: "Brand-Regular",
                                      fontSize: 20,
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
                        width: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Column(
                        children: [
                          Container(
                            height: 55,
                            width: 130,
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade900,
                                borderRadius: BorderRadius.circular(50)),
                            child: const Center(
                                child: Text(
                              "Oct, 22",
                              style: TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 20,
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
                        width: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Column(
                        children: [
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade900,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                Provider.of<AppInfo>(context, listen: false)
                                    .allTripsHistoryInformationList
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontSize: 20,
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
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.07,),

                  Container(
                    width: 370,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(100, 225, 226, 233),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(msg: "Coming soon");
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
                                    'Campaign',
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
                                    'Bank details',
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Support()));
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
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => const Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.indigo,
                                    )));
                            Timer(const Duration(seconds: 1), () async {
                              checkDebt();
                            });
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
                                Icon(Icons.warning_amber_rounded),
                                SizedBox(width: 40),
                                Expanded(
                                  child: Text(
                                    'Settle OD',
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
                        GestureDetector(
                          onTap: () {
                            Share.share(
                                'https://boride.page.link/driver/${"0Np0X5"}');
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
                                Icon(Icons.person_add),
                                SizedBox(width: 40),
                                Expanded(
                                  child: Text(
                                    'Invite',
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
                        GestureDetector(
                          onTap: () async {
                            await FirebaseAuth.instance
                                .signOut()
                                .whenComplete(() {
                              Phoenix.rebirth(context);
                            });
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
                height: MediaQuery.of(context).size.height * 0.01,
              ),
            ],
          ),
        ]),
      ),
    );
  }

  checkDebt() {
    String debtAmount;

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("debt")
        .once()
        .then((value) {
      if (value.snapshot.value != null) {
        debtAmount = value.snapshot.value.toString();
        Navigator.pop(context);
        _handlePaymentInitialization(debtAmount);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "You do not have an outstanding pay");
      }
    });
  }

  bool isTestMode = true;

  _handlePaymentInitialization(String debtAmount) async {
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
        amount: debtAmount.toString(),
        customer: customer,
        paymentOptions: "card, bank transfer",
        customization: Customization(title: "Test Payment"),
        isTestMode: isTestMode);
    // ignore: unused_local_variable
    final ChargeResponse response = await flutterWave.charge();
    if (response != null) {
      if (response.status == "successful") {
        Fluttertoast.showToast(msg: response.status!);
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(fAuth.currentUser!.uid)
            .child("debt")
            .remove();
      } else {
        Fluttertoast.showToast(msg: response.status!);
      }
    }
  }

  String getPublicKey() {
    if (isTestMode) return "FLWPUBK_TEST-05883fda3bc8c92020311be726ca4d7a-X";
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
