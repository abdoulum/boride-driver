import 'dart:async';

import 'package:boride_driver/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WaitingDocumentVerify extends StatefulWidget {
  const WaitingDocumentVerify({Key? key}) : super(key: key);

  @override
  State<WaitingDocumentVerify> createState() => _WaitingDocumentVerifyState();
}

class _WaitingDocumentVerifyState extends State<WaitingDocumentVerify> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:25),
        child: Center(
          child: Text(
            "You will receive an email when we verify your documents and will be able to use your account",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Brand-regular",
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkS();
  }

  checkS() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      checkDocumentVerified();
      Fluttertoast.showToast(msg: "waiting");
    });
  }

  Future<void> checkDocumentVerified() async {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("isDocVerified")
        .onValue
        .listen((event) {
      if (event.snapshot.value == "true") {
        timer!.cancel();
        Navigator.pop(context, "emailVerified");
      }
    });
  }
}
