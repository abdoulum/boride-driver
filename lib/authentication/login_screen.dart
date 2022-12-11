import 'package:boride_driver/assistants/assistant_methods.dart';
import 'package:boride_driver/authentication/driver_registation.dart';
import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/mainScreens/main_screen.dart';
import 'package:boride_driver/splashScreen/splash_screen.dart';
import 'package:boride_driver/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool hasCompletedRegistration = false;

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
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .whenComplete(() {
      AssistantMethods.readDriverTotalEarnings(context);
      AssistantMethods.readDriverWeeklyEarnings(context);
      AssistantMethods.readDriverRating(context);
    }).catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
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
                const Center(
                  child: Text(
                    "Boride Driver",
                    style: TextStyle(
                      fontSize: 45,
                      fontFamily: "Brand-Bold",
                      color: Colors.indigo,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Center(
                        child: Text(
                            "Drive with boride and earn with your personal vehicle",
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(fontFamily: "Brand-Regular"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      //     margin: EdgeInsets.all(12),
                      height: 45,
                      width: 350,
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
                              hintText: "Example@gmail.com",
                              prefixStyle: TextStyle(color: Colors.black),
                              // prefixIcon: Icon(Icons.person),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(fontFamily: "Brand-Regular"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      //     margin: EdgeInsets.all(12),
                      height: 45,
                      width: 350,
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
                              prefixStyle: TextStyle(color: Colors.black),
                              // prefixIcon: Icon(Icons.person),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
