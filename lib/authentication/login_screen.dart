import 'package:boride_driver/authentication/driver_registation.dart';
import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/mainScreens/main_screen.dart';
import 'package:boride_driver/splashScreen/splash_screen.dart';
import 'package:boride_driver/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
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
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful.");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (c) => const MainScreen()));
        } else {
          Fluttertoast.showToast(msg: "No record exist with this email.");
          fAuth.signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              Text(
                "Login as a Driver",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: "Brand-Regular",
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                          keyboardType: TextInputType.name,
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
                            hintText: "********",
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
              ElevatedButton(
                onPressed: () {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ),
              CupertinoButton(
                  child: const Text("Already have an account"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const NewDriver()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
