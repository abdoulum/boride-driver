import 'package:boride_driver/assistants/assistant_methods.dart';
import 'package:boride_driver/authentication/driver_registration.dart';
import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/mainScreens/main_screen.dart';
import 'package:boride_driver/splashScreen/intro_screen.dart';
import 'package:boride_driver/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:once/once.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool hasCompletedRegistration = false;

  @override
  void initState() {
    super.initState();
    Once.runOnce("First_visit", callback: visitIntroPage);
  }

  visitIntroPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const IntroScreen()));
  }

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required.");
    } else {
      loginDriverNow();
    }
  }

  loginDriverNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.indigo,
            ),
          );
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .whenComplete(() async {
      await loadData();
    }).catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Please check your credentials");
    }))
        .user;

    if (firebaseUser != null) {
      checkRegistrationStatus();
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful.");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => const MainScreen()));
        } else {
          Fluttertoast.showToast(msg: "No record exist with this email.");
          FirebaseAuth.instance.signOut().whenComplete(() {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (c) => const MySplashScreen()));
          });
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login.");
    }
  }

  checkIfDocumentsIsVerified() {
    var status;
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("isDocVerified")
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        status = value.snapshot.value.toString();
        if (status == "true") {
        } else {
          return;
        }
      }
    });
  }

  loadData() {
    AssistantMethods.readDriverTotalEarnings(context);
    AssistantMethods.readDriverWeeklyEarnings(context);
    AssistantMethods.readDriverRating(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Center(
                    child: Image.asset(
                  "images/boridedriver_logo.png",
                  color: Colors.indigo,
                  width: MediaQuery.of(context).size.width * 0.5,
                )),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Center(
                        child: Text(
                            "Drive with boride and earn with your personal vehicle",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Brand-Regular",
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Container(
                  //     margin: EdgeInsets.all(12),
                  height: 55,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 245, 247),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: emailTextEditingController,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(fontFamily: "Brand-regular"),
                          prefixStyle: TextStyle(
                              color: Colors.black, fontFamily: "Brand-regular"),
                          // prefixIcon: Icon(Icons.person),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  //     margin: EdgeInsets.all(12),
                  height: 55,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 245, 247),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: passwordTextEditingController,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(fontFamily: "Brand-regular"),
                          prefixStyle: TextStyle(color: Colors.black),
                          // prefixIcon: Icon(Icons.person),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    validateForm();
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Brand-Regular",
                          fontSize: 18),
                    )),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NewDriver()));
                    },
                    child: const Text("Register as a driver",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Brand-Regular",
                            fontSize: 18))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  checkRegistrationStatus() {
    FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(fAuth.currentUser!.uid)
        .child("profile_photo")
        .once()
        .then((value) {
      if (value.snapshot.value != null) {
        Fluttertoast.showToast(msg: "Registration not complete");
        setState(() {
          hasCompletedRegistration == true;
        });
      }
    });
  }
}
